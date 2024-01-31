#!/bin/bash

BUCKET_NAME="hh-cv-services-deployment-bucket"

# Check if the S3 bucket exists
bucket_exists=$(aws s3api head-bucket --bucket "$BUCKET_NAME" 2>&1)

if [[ $bucket_exists == *"Not Found"* ]]; then
  # S3 bucket does not exist, create it
  echo "S3 bucket '$BUCKET_NAME' does not exist. Creating..."
  aws s3api create-bucket --bucket "$BUCKET_NAME" --region "$AWS_REGION" --create-bucket-configuration LocationConstraint="$AWS_REGION"
  echo "S3 bucket '$BUCKET_NAME' created successfully."
else
  # S3 bucket already exists
  echo "S3 bucket '$BUCKET_NAME' already exists."
fi
