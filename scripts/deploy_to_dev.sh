#!/bin/bash

PROJECT_NAME="cv-engine-streamlit-ui-dev"
CFT_MODULES_S3_BUCKET="https://hh-cv-cft-modules.s3.us-west-2.amazonaws.com/dev"
CFT_SERVICES_S3_BUCKET="https://hh-cv-services-deployment-bucket.s3.us-west-2.amazonaws.com/$PROJECT_NAME"
S3_BUCKET_NAME="cv-engine-streamlit-ui-dev"
ECR_URI_SERVICE="130290943060.dkr.ecr.us-west-2.amazonaws.com/cv-engine-service:latest"
TASK_CV_ENGINE_2_13="130290943060.dkr.ecr.us-west-2.amazonaws.com/cv-engine-service:2.13-arm-latest"
TASK_CV_ENGINE_2_14_2_ARM="130290943060.dkr.ecr.us-west-2.amazonaws.com/cv-engine-service:2.14.2-arm-latest"
TASK_CV_ENGINE_2_14_2_AMD="130290943060.dkr.ecr.us-west-2.amazonaws.com/cv-engine-service:2.14.2-amd-latest"
SERVICE_CONTAINER_NAME="service"
CV_ENGINE_2_13_CONTAINER_NAME="v-2-13"
CV_ENGINE_2_14_2_ARM_CONTAINER_NAME="v-2-14-2-arm"
CV_ENGINE_2_14_2_AMD_CONTAINER_NAME="v-2-14-2-amd"
CPU="1024"
MEMORY="5120"
CPU_ARCHITECTURE_ARM="ARM64"
CPU_ARCHITECTURE_AMD="X86_64"
OPERATING_SYSTEM_FAMILY="LINUX"
#ENV_FILE_ARN="arn:aws:s3:::hh-cv-services-deployment-bucket/cv-engine-dev/cv_engine_env_variable.env"
HEALTH_CHECK_PATH="/api/v0/exercise-definition/healthcheck"
LISTENER_PORT="83"

create-stack() {
    aws cloudformation create-stack \
	--stack-name "$PROJECT_NAME" \
	--template-body "file://deploy/cft-services/dev/cv_engine.json" \
	--capabilities CAPABILITY_AUTO_EXPAND CAPABILITY_NAMED_IAM \
	--parameters \
		ParameterKey=projectName,ParameterValue="$PROJECT_NAME" \
		ParameterKey=cftModulesS3Bucket,ParameterValue="$CFT_MODULES_S3_BUCKET" \
		ParameterKey=cftServicesS3Bucket,ParameterValue="$CFT_SERVICES_S3_BUCKET" \
		ParameterKey=s3BucketName,ParameterValue="$S3_BUCKET_NAME" \
		ParameterKey=region,ParameterValue="$AWS_DEFAULT_REGION" \
		ParameterKey=ecrUriService,ParameterValue="$ECR_URI_SERVICE" \
		ParameterKey=taskCvEngine213,ParameterValue="$TASK_CV_ENGINE_2_13" \
		ParameterKey=taskCvEngine2142Arm,ParameterValue="$TASK_CV_ENGINE_2_14_2_ARM" \
		ParameterKey=taskCvEngine2142Amd,ParameterValue="$TASK_CV_ENGINE_2_14_2_AMD" \
		ParameterKey=serviceContainerName,ParameterValue="$SERVICE_CONTAINER_NAME" \
		ParameterKey=taskCvEngine213ContainerName,ParameterValue="$CV_ENGINE_2_13_CONTAINER_NAME" \
		ParameterKey=taskCvEngine2142ArmContainerName,ParameterValue="$CV_ENGINE_2_14_2_ARM_CONTAINER_NAME" \
		ParameterKey=taskCvEngine2142AmdContainerName,ParameterValue="$CV_ENGINE_2_14_2_AMD_CONTAINER_NAME" \
		'ParameterKey=taskCvEngine213Pattern,ParameterValue="{\"detail\":{\"messageAttributes\":{\"operation\":{\"stringValue\":[{\"prefix\":\"2.13\"}]}}}}"' \
		'ParameterKey=taskCvEngine2142ArmPattern,ParameterValue="{\"detail\":{\"messageAttributes\":{\"operation\":{\"stringValue\":[{\"prefix\": \"2.14.2\"}]},\"architecture\":{\"stringValue\":[{\"prefix\":\"ARM\"}]}}}}"' \
		'ParameterKey=taskCvEngine2142AmdPattern,ParameterValue="{\"detail\":{\"messageAttributes\":{\"operation\":{\"stringValue\":[{\"prefix\": \"2.14.2\"}]},\"architecture\":{\"stringValue\":[{\"prefix\":\"AMD\"}]}}}}"' \
		ParameterKey=cpu,ParameterValue="$CPU" \
		ParameterKey=memory,ParameterValue="$MEMORY" \
		ParameterKey=cpuArchitectureArm,ParameterValue="$CPU_ARCHITECTURE_ARM" \
		ParameterKey=cpuArchitectureAmd,ParameterValue="$CPU_ARCHITECTURE_AMD" \
		ParameterKey=operatingSystemFamily,ParameterValue="$OPERATING_SYSTEM_FAMILY" \
		ParameterKey=environmentFilesArn,ParameterValue="$ENV_FILE_ARN" \
		ParameterKey=healthCheckPath,ParameterValue="$HEALTH_CHECK_PATH" \
		ParameterKey=listenerPort,ParameterValue="$LISTENER_PORT"
}

update-stack() {
    aws cloudformation update-stack \
	--stack-name "$PROJECT_NAME" \
	--template-body "file://deploy/cft-services/dev/cv_engine.json" \
	--capabilities CAPABILITY_AUTO_EXPAND CAPABILITY_NAMED_IAM \
	--parameters \
		ParameterKey=projectName,ParameterValue="$PROJECT_NAME" \
		ParameterKey=cftModulesS3Bucket,ParameterValue="$CFT_MODULES_S3_BUCKET" \
		ParameterKey=cftServicesS3Bucket,ParameterValue="$CFT_SERVICES_S3_BUCKET" \
		ParameterKey=s3BucketName,ParameterValue="$S3_BUCKET_NAME" \
		ParameterKey=region,ParameterValue="$AWS_DEFAULT_REGION" \
		ParameterKey=ecrUriService,ParameterValue="$ECR_URI_SERVICE" \
		ParameterKey=taskCvEngine213,ParameterValue="$TASK_CV_ENGINE_2_13" \
		ParameterKey=taskCvEngine2142Arm,ParameterValue="$TASK_CV_ENGINE_2_14_2_ARM" \
		ParameterKey=taskCvEngine2142Amd,ParameterValue="$TASK_CV_ENGINE_2_14_2_AMD" \
		ParameterKey=serviceContainerName,ParameterValue="$SERVICE_CONTAINER_NAME" \
		ParameterKey=taskCvEngine213ContainerName,ParameterValue="$CV_ENGINE_2_13_CONTAINER_NAME" \
		ParameterKey=taskCvEngine2142ArmContainerName,ParameterValue="$CV_ENGINE_2_14_2_ARM_CONTAINER_NAME" \
		ParameterKey=taskCvEngine2142AmdContainerName,ParameterValue="$CV_ENGINE_2_14_2_AMD_CONTAINER_NAME" \
		'ParameterKey=taskCvEngine213Pattern,ParameterValue="{\"detail\":{\"messageAttributes\":{\"operation\":{\"stringValue\":[{\"prefix\":\"2.13\"}]}}}}"' \
		'ParameterKey=taskCvEngine2142ArmPattern,ParameterValue="{\"detail\":{\"messageAttributes\":{\"operation\":{\"stringValue\":[{\"prefix\": \"2.14.2\"}]},\"architecture\":{\"stringValue\":[{\"prefix\":\"ARM\"}]}}}}"' \
		'ParameterKey=taskCvEngine2142AmdPattern,ParameterValue="{\"detail\":{\"messageAttributes\":{\"operation\":{\"stringValue\":[{\"prefix\": \"2.14.2\"}]},\"architecture\":{\"stringValue\":[{\"prefix\":\"AMD\"}]}}}}"' \
		ParameterKey=cpu,ParameterValue="$CPU" \
		ParameterKey=memory,ParameterValue="$MEMORY" \
		ParameterKey=cpuArchitectureArm,ParameterValue="$CPU_ARCHITECTURE_ARM" \
		ParameterKey=cpuArchitectureAmd,ParameterValue="$CPU_ARCHITECTURE_AMD" \
		ParameterKey=operatingSystemFamily,ParameterValue="$OPERATING_SYSTEM_FAMILY" \
		ParameterKey=environmentFilesArn,ParameterValue="$ENV_FILE_ARN" \
		ParameterKey=healthCheckPath,ParameterValue="$HEALTH_CHECK_PATH" \
		ParameterKey=listenerPort,ParameterValue="$LISTENER_PORT"
}

delete-stack() {
    aws cloudformation delete-stack --stack-name $PROJECT_NAME
}

rollback-stack() {
    aws cloudformation rollback-stack --stack-name $PROJECT_NAME
}

continue-update-rollback() {
	aws cloudformation continue-update-rollback --stack-name $PROJECT_NAME
}

get_stack_status() {
    aws cloudformation describe-stacks --stack-name "$PROJECT_NAME" --query 'Stacks[0].StackStatus' --output text
}

# Function to wait for stack completion
wait_for_stack() {
    local status
    status=$(get_stack_status)
    
    case "$status" in
        "CREATE_IN_PROGRESS")
            aws cloudformation wait stack-create-complete --stack-name "$PROJECT_NAME"
            ;;
        "UPDATE_IN_PROGRESS")
            aws cloudformation wait stack-update-complete --stack-name "$PROJECT_NAME"
            ;;
        "DELETE_IN_PROGRESS")
            aws cloudformation wait stack-delete-complete --stack-name "$PROJECT_NAME"
            ;;
    esac
}

# Function to handle stack creation
create_or_update_stack() {
    if aws cloudformation describe-stacks --stack-name "$PROJECT_NAME" ; then
        local status=$(get_stack_status)
        
        case "$status" in
            "UPDATE_FAILED")
                echo "Stack $PROJECT_NAME is in UPDATE_FAILED state. Rolling back changes."
                rollback-stack
                wait_for_stack
                ;;
			"UPDATE_ROLLBACK_FAILED")
                echo "Stack update failed. Continuing update rollback."
                continue-update-rollback
                wait_for_stack
                update-stack
                wait_for_stack
            	;;
            "UPDATE_ROLLBACK_COMPLETE" | "CREATE_COMPLETE" | "UPDATE_COMPLETE" | "UPDATE_IN_PROGRESS" | "UPDATE_ROLLBACK_IN_PROGRESS")
                echo "Stack $PROJECT_NAME exists and is in progress. Started updating resources."
                update-stack
                wait_for_stack
				;;
            "ROLLBACK_COMPLETE" | "ROLLBACK_FAILED")
                echo "Stack $PROJECT_NAME is in ROLLBACK_COMPLETE or ROLLBACK_FAILED state. Deleting the stack and creating it again."
                delete-stack
                aws cloudformation wait stack-delete-complete --stack-name "$PROJECT_NAME"
                create-stack
                wait_for_stack
                exit 1
                ;;
            *)
                echo "Stack $PROJECT_NAME exists and is not in progress. Skipping update."
                ;;
        esac
    else
        echo "Stack $PROJECT_NAME does not exist. Started creation."
        create-stack
        wait_for_stack
    fi
}

# Main function
main() {
    create_or_update_stack

    # Handle ExpiredToken error by exiting script
    if [ $? -ne 0 ]; then
        echo "Error: ExpiredToken. Exiting."
        exit 1
    fi
}

# Call the main function
main