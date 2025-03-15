import boto3
import csv
import json
import base64
import os
import uuid

s3 = boto3.client("s3")
dynamodb = boto3.resource("dynamodb")

# Environment variables (set in Terraform)
BUCKET_NAME = os.environ["BUCKET_NAME"]
TABLE_NAME = os.environ["TABLE_NAME"]

def lambda_handler(event, context):
    try:
        # Decode Base64 CSV data from request body
        csv_data = base64.b64decode(event["body"]).decode("utf-8")

        # Convert CSV to JSON
        rows = csv_data.strip().split("\n")
        csv_reader = csv.reader(rows)
        header = next(csv_reader)  # Read headers

        data = []
        for row in csv_reader:
            if row:
                item = dict(zip(header, row))
                item["DrugID"] = str(uuid.uuid4())  # Unique identifier
                data.append(item)

        # Upload JSON file to S3
        file_name = f"drug_data_{context.aws_request_id}.json"
        s3.put_object(Bucket=BUCKET_NAME, Key=file_name, Body=json.dumps(data))

        # Insert into DynamoDB
        table = dynamodb.Table(TABLE_NAME)
        for item in data:
            table.put_item(Item=item)

        return {
            "statusCode": 200,
            "body": json.dumps({"message": "CSV uploaded successfully", "file": file_name})
        }

    except Exception as e:
        return {
            "statusCode": 500,
            "body": json.dumps({"error": str(e)})
        }

