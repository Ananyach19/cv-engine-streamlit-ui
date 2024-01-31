import streamlit as st
import re
import requests
import boto3
from botocore.exceptions import NoCredentialsError
import json


batch_uuidPV = ""


def list_json_files_in_folder(bucket_name, folder_name, profile, region):
    try:

        session = boto3.Session(profile_name=profile, region_name=region)
        s3 = session.client("s3")
        response = s3.list_objects_v2(Bucket=bucket_name, Prefix=f"{folder_name}/")
        json_files = [
            obj["Key"]
            for obj in response.get("Contents", [])
            if obj["Key"].lower().endswith(".json")
        ]
        st.write(f"{json_files[0]} is created in the bucket: {bucket_name}")
        # selected_json_file = st.selectbox("Select a JSON file:", json_files)
        # if selected_json_file:
        # json_file_contents = read_json_from_s3(bucket_name, selected_json_file, profile, region)
        # st.write(f"Contents of {selected_json_file}:", json_file_contents)

    except NoCredentialsError as e:
        if "PartialCredentialsError" in str(e):
            st.warning(
                "Partial credentials provided. Ensure both 'aws_access_key_id' and 'aws_secret_access_key' are set."
            )
        else:
            st.warning("Credentials not available or invalid.")
    except Exception as e:
        st.error(f"An error occurred: {str(e)}")


# def read_json_from_s3(bucket_name, json_file_key, profile, region):
# st.write("Reading contents of json")
# try:
# session = boto3.Session(profile_name=profile, region_name=region)
# s3 = session.client('s3')
# response = s3.get_object(Bucket=bucket_name, Key=json_file_key)
# json_contents = response['Body'].read().decode('utf-8')
# json_data = json.loads(json_contents)

# return json_data

# except Exception as e:
# st.error(f"An error occurred while reading the JSON file: {str(e)}")
# return None


def is_valid_bucket_name(bucket_name):
    if not (3 <= len(bucket_name) <= 63):
        return False

    if not bucket_name[0].isalnum() or not bucket_name[-1].isalnum():
        return False

    valid_characters = set("abcdefghijklmnopqrstuvwxyz0123456789-.")
    if not all(char in valid_characters for char in bucket_name):
        return False

    if (
        ".." in bucket_name
        or "--" in bucket_name
        or "-." in bucket_name
        or ".-" in bucket_name
    ):
        return False

    return True


def is_valid_video_path(video_path):
    return bool(re.match("^[a-zA-Z0-9-_./]*$", video_path))


def call_api(
    cv_engine_version,
    bucket_name,
    video_path,
    recalculate_override,
    is_directory,
    selected_environment,
):
    environments = {
        "stage": "https://utyc58lyl6.execute-api.us-west-2.amazonaws.com/api/v0/exercise-definition/create_pose_request",
        "dev": "https://nyn2mck631.execute-api.us-west-2.amazonaws.com/api/v0/exercise-definition/create_pose_request",
        "prod": "https://api.prod.com",
    }

    if selected_environment not in environments:
        st.warning("Invalid environment selected.")
        return

    api_endpoint = f"{environments[selected_environment]}"

    payload = [
        {
            "cv_engine_version": cv_engine_version,
            "input_bucket": bucket_name,
            "videoPath": video_path,
            "recalculateOverride": recalculate_override,
            "isDirectory": is_directory,
        }
    ]

    try:

        response = requests.post(api_endpoint, json=payload)

        if response.status_code == 200:
            result = response.json()
            st.subheader("API Response Output:")
            st.write(result)
            st.success("API call successful!")
            batch_uuidPV = result.get("batch_uuid")
            api2 = f"https://nyn2mck631.execute-api.us-west-2.amazonaws.com/api/v0/exercise-definition/:{batch_uuidPV}/status"
            secondapiResponse = requests.get(api2)

        else:
            st.error(f"API call failed with status code: {response.status_code}")
            st.write("Error details:", response.text)
    except Exception as e:
        st.error(f"An error occurred during the API call: {str(e)}")


def main():
    st.title("API Parameter Streamlit App")

    cv_engine_version: str = st.selectbox("CV Engine Version:", ["2.13", "2.14.2"])
    bucket_name: str = st.text_input("Bucket Name:", "")
    video_path: str = st.text_input("Video Path:", "")
    recalculate_override: bool = st.selectbox("Recalculate Override", [True, False])
    is_directory: bool = st.selectbox("Is Directory:", [True, False])

    selected_environment = st.selectbox("Select Environment:", ["stage", "dev", "prod"])

    # Button to trigger API call
    if st.button("Run API"):
        if not bucket_name.strip():
            st.warning("Bucket Name cannot be empty.")
            return

        if not video_path.strip():
            st.warning("Video Path cannot be empty.")
            return

        call_api(
            cv_engine_version,
            bucket_name,
            video_path,
            recalculate_override,
            is_directory,
            selected_environment,
        )
        your_bucket_name = "cv-engine-service-dev"
        your_folder_name = "pose_results"
        your_aws_profile = "130290943060_Hinge_ML_Engineer_MLInfra"
        your_aws_region = "us-west-2"

        list_json_files_in_folder(
            your_bucket_name, your_folder_name, your_aws_profile, your_aws_region
        )


if __name__ == "__main__":
    main()
