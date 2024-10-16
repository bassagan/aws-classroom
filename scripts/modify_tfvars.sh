#!/bin/bash

# Check if the correct number of arguments are provided
if [ "$#" -ne 5 ]; then
    echo "Usage: $0 <owner> <github_token> <codepipeline_name> <s3_bucket_name> <dynamodb_table_name>"
    exit 1
fi

# Assign input arguments to variables
OWNER="$1"
GITHUB_TOKEN="$2"
CODEPIPELINE_NAME="$3"
S3_BUCKET_NAME="$4"
DYNAMODB_TABLE_NAME="$5"

# Define paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MANAGEMENT_TEMPLATE_FILE="${SCRIPT_DIR}/../iac/management/terraform.tfvars.template"
MANAGEMENT_TFVARS_FILE="${SCRIPT_DIR}/../iac/management/terraform.tfvars"

# Predefined values for some parameters
REGION="eu-west-1"
ENV="dev"

# Function to generate tfvars file
generate_tfvars() {
    local template_file=$1
    local output_file=$2

    # Check if the template file exists
    if [ ! -f "$template_file" ]; then
        echo "Error: Template file '${template_file}' not found."
        exit 1
    fi

    # Replace placeholders with values
    sed -e "s/{owner}/$OWNER/" \
        -e "s/{region}/$REGION/" \
        -e "s/{env}/$ENV/" \
        -e "s/{github_token}/$GITHUB_TOKEN/" \
        -e "s/{codepipeline_name}/$CODEPIPELINE_NAME/" \
        -e "s/{s3_bucket_name}/$S3_BUCKET_NAME/" \
        -e "s/{dynamodb_table_name}/$DYNAMODB_TABLE_NAME/" \
        "$template_file" > "$output_file"

    echo "Terraform variable file has been generated at $output_file."
}

# Generate tfvars for both MANAGEMENT
generate_tfvars "$MANAGEMENT_TEMPLATE_FILE" "$MANAGEMENT_TFVARS_FILE"
