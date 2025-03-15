import boto3
import json
import os

dynamodb = boto3.resource("dynamodb")

# Environment variables
TABLE_NAME = os.environ["TABLE_NAME"]

def lambda_handler(event, context):
    try:
        # Query DynamoDB for all data
        table = dynamodb.Table(TABLE_NAME)
        response = table.scan()

        return {
            "statusCode": 200,
            "body": json.dumps(response.get("Items", []))
        }

    except Exception as e:
        return {
            "statusCode": 500,
            "body": json.dumps({"error": str(e)})
        }

