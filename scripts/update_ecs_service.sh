#!/bin/bash

PROJECT_NAME="cv-engine-${ENV}"
ECS_CLUSTER_NAME="hh-cv-cluster-${ENV}"
SERVICE_NAME="cv-engine-${ENV}-service"

update-service() {
    local stack_status
    echo "CloudFormation stack $PROJECT_NAME"

    stack_status=$(aws cloudformation describe-stacks --stack-name $PROJECT_NAME --query 'Stacks[0].StackStatus' --output text)

    if [ $? -eq 0 ]; then
        echo "CloudFormation stack $PROJECT_NAME exists with status: $stack_status"

        if [ "$stack_status" = "CREATE_COMPLETE" ] || [ "$stack_status" = "UPDATE_COMPLETE" ]; then
            echo "Updating service $SERVICE_NAME in $ECS_CLUSTER_NAME"
            aws ecs update-service --service "$SERVICE_NAME" --cluster "$ECS_CLUSTER_NAME" --force-new-deployment 
            echo "Service update initiated."
        else
            echo "The stack is not in a stable state for updates. Current status: $stack_status"
        fi
    else
        echo "CloudFormation stack $PROJECT_NAME does not exist."
    fi
}

update-service
