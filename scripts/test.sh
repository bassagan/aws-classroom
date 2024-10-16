
To delete all Amazon S3 buckets that are older than today using the AWS CLI, you can use the following script. Note that this action is irreversible, so be careful before executing it.

Here's a basic example using a Bash script:

bash
Copiar código
#!/bin/bash

# Get today's date in YYYY-MM-DD format
today=$(date +%Y-%m-%d)

# List all buckets and filter by creation date
aws s3api list-buckets --query "Buckets[?CreationDate<='$today'].Name" --output text | tr '\t' '\n' | while read -r bucket; do
    echo "Deleting bucket: $bucket"
    aws s3 rb "s3://$bucket" --force
done