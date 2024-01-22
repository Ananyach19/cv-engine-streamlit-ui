import streamlit as st
import re

def is_valid_bucket_name(bucket_name):
    """
    Check if the provided bucket name adheres to S3 naming specifications.
    """
    if not (3 <= len(bucket_name) <= 63):
        return False

    if not bucket_name[0].isalnum() or not bucket_name[-1].isalnum():
        return False

    valid_characters = set("abcdefghijklmnopqrstuvwxyz0123456789-.")
    if not all(char in valid_characters for char in bucket_name):
        return False

    if ".." in bucket_name or "--" in bucket_name or "-." in bucket_name or ".-" in bucket_name:
        return False

    return True


def is_valid_video_path(video_path):
    # Example: Validate alphanumeric characters, hyphens, and underscores
    return bool(re.match("^[a-zA-Z0-9-_./]*$", video_path))


def main():
    st.title("API Parameter Streamlit App")

    # Input parameters
    bucket_name = st.text_input("Bucket Name:", "")
    video_path = st.text_input("Video Path:", "")
    recalculate_override = st.selectbox("Recalculate Override", [True,False])
    is_directory = st.selectbox("Is Directory:", [True, False])
    cv_engine_version = st.selectbox("CV Engine Version:", ["2.13", "2.14.2"])
    url = st.text_input("URL:", "")

    # Validation check for bucket name
    if bucket_name and not is_valid_bucket_name(bucket_name):
        st.warning("Invalid bucket name. Please follow S3 naming specifications.")
        return

    # Button to trigger API call
    if st.button("Run API"):
        # Print or process the API parameters
        print("Bucket Name:", bucket_name)
        print("Video Path:", video_path)
        print("Recalculate Override:", recalculate_override)
        print("Is Directory:", is_directory)
        print("CV Engine Version:", cv_engine_version)
        print("URL:", url)
        
        # Here you can make your API call with these parameters

if __name__ == "__main__":
    main()
