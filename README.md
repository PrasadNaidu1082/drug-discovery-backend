# Drug Discovery Data Ingestion & Retrieval API

This project provides a serverless RESTful API to handle **drug discovery data** using AWS services.  
It allows users to **upload a CSV file**, store it in **Amazon S3 and DynamoDB**, and retrieve the data in JSON format via an API.

---

## Architecture

The architecture follows a **serverless approach** using AWS services:
![Architecture Diagram](/analytics-service-architecture.png)

### Key Components:
- **API Gateway** - Exposes RESTful API endpoints.
- **AWS Lambda** - Handles CSV processing, data storage, and retrieval.
- **Amazon S3** - Stores the uploaded CSV file as a JSON object.
- **Amazon DynamoDB** - Stores structured drug discovery data.
- **IAM Roles** - For secured access.

---

## Features

✅ **Upload a CSV file** via a POST request  
✅ **Store the file in Amazon S3** for backup  
✅ **Save structured data in DynamoDB**  
✅ **Retrieve stored data as JSON** via a GET request  
✅ **Basic data validation** to ensure correct format  

---

## API Endpoints

### **1. Upload CSV File**

Uploads a CSV file containing **drug discovery data**.

**Endpoint:**  
```http
POST https://your-api-gateway-url/prod/upload
```

**Request Example (Using cURL):**
```bash
curl -X POST "https://your-api-gateway-url/prod/upload" \
     -H "Content-Type: text/csv" \
     --data-binary @drug-data.csv
```
**Response:**
```json
{
  "message": "CSV uploaded successfully and stored in DynamoDB",
  "file": "drug_data_xxx.json"
}
```

**Validation Errors:**
```json
{
  "error": "Invalid CSV format. Expected headers: {'drug_name', 'target', 'efficacy'}"
}
```
### **2. Retrieve Stored Data**

Retrieves the stored drug discovery data in JSON format.

**Endpoint:**
```http
GET https://your-api-gateway-url/prod/data
```

**Request Example (Using cURL):**
```bash
curl -X GET "https://your-api-gateway-url/prod/data"
```
**Response:**
```json
[
  {
    "drug_name": "Aspirin",
    "target": "COX-1",
    "efficacy": "0.85"
  },
  {
    "drug_name": "Ibuprofen",
    "target": "COX-2",
    "efficacy": "0.90"
  }
]
```
**Errors:**
```json
{
  "error": "Table not found"
}
```
-----

## Implementation Details
**Upload CSV Function (AWS Lambda)**
**Handles CSV upload, parsing, storage in S3, and saving data in DynamoDB.)**

```python

import boto3
import csv
import json
import base64
import os

s3 = boto3.client("s3")
dynamodb = boto3.resource("dynamodb")

BUCKET_NAME = "drug-discovery-data-bucket"
TABLE_NAME = "DrugDiscoveryData"

# Define required CSV headers
REQUIRED_HEADERS = {"drug_name", "target", "efficacy"}

def validate_csv_data(csv_data):
    """ Validates CSV format and structure """
    rows = csv_data.strip().split("\n")
    csv_reader = csv.reader(rows)
    header = next(csv_reader)

    # Check if all required headers are present
    if set(header) != REQUIRED_HEADERS:
        raise ValueError(f"Invalid CSV format. Expected headers: {REQUIRED_HEADERS}, but got: {header}")

    # Validate each row
    for row in csv_reader:
        if len(row) != len(header):  # Ensure no missing values
            raise ValueError(f"Invalid row: {row}. Missing fields detected.")

    return header  # Return header for further processing

def lambda_handler(event, context):
    try:
        # Decode Base64 CSV data
        csv_data = base64.b64decode(event["body"]).decode("utf-8")

        # Validate CSV
        header = validate_csv_data(csv_data)

        # Convert CSV string to JSON
        rows = csv_data.strip().split("\n")
        csv_reader = csv.reader(rows)
        next(csv_reader)  # Skip header since it's validated

        data = [dict(zip(header, row)) for row in csv_reader if row]

        # Upload JSON file to S3
        file_name = f"drug_data_{context.aws_request_id}.json"
        s3.put_object(Bucket=BUCKET_NAME, Key=file_name, Body=json.dumps(data))

        # Insert data into DynamoDB
        table = dynamodb.Table(TABLE_NAME)

        with table.batch_writer() as batch:
            for item in data:
                batch.put_item(Item=item)  # Writing each row to DynamoDB efficiently

        return {
            "statusCode": 200,
            "body": json.dumps({"message": "CSV uploaded successfully and stored in DynamoDB", "file": file_name})
        }

    except ValueError as ve:
        return {
            "statusCode": 400,
            "body": json.dumps({"error": str(ve)})
        }
    
    except Exception as e:
        return {
            "statusCode": 500,
            "body": json.dumps({"error": str(e)})
        }

```
**Retrieve Data Function (AWS Lambda)**
**Fetches stored data from DynamoDB and returns it in JSON format.**

```python
import boto3
import json

dynamodb = boto3.resource("dynamodb")
TABLE_NAME = "DrugDiscoveryData"

def lambda_handler(event, context):
    try:
        table = dynamodb.Table(TABLE_NAME)
        response = table.scan()
        data = response.get("Items", [])

        return {
            "statusCode": 200,
            "body": json.dumps(data)
        }

    except Exception as e:
        return {
            "statusCode": 500,
            "body": json.dumps({"error": str(e)})
        }
```
## Error Handling

| Scenario                        | Error Message |
|---------------------------------|------------------------------------------------|
| Missing required headers in CSV | `"Invalid CSV format. Expected headers: {'drug_name', 'target', 'efficacy'}"` |
| Missing fields in a row         | `"Invalid row: ['DrugA', 'ProteinX']. Missing fields detected."` |
| S3 upload failure               | `"error": "S3 upload failed"` |
| DynamoDB table not found        | `"error": "Table not found"` |
| AWS service failure             | `"error": "Internal server error"` |

**Deployment Steps**

1️⃣ **Create an S3 Bucket**
Create an S3 bucket:
drug-discovery-data-bucket

2️⃣ **Create a DynamoDB Table**
Table Name: DrugDiscoveryData
Primary Key: drug_name (String)

3️⃣ **Configure IAM Roles**
Ensure the Lambda function has permissions to:
Write to S3 (s3:PutObject)
Write to DynamoDB (dynamodb:PutItem)
Read from DynamoDB (dynamodb:Scan)

4️⃣ **Create Lambda Functions**
Manually create two AWS Lambda functions:
UploadCSVLambda – Handles CSV upload and storage.
RetrieveDataLambda – Retrieves data from DynamoDB.

5️⃣ **Set Up API Gateway**
POST /upload → Calls UploadCSVLambda
GET /data → Calls RetrieveDataLambda


**Testing & Validation**

1️⃣ Upload a CSV file using the API.

2️⃣ Verify the file in S3 (drug-discovery-data-bucket).

3️⃣ Check stored data in DynamoDB (DrugDiscoveryData table).

4️⃣ Retrieve the data using the GET API.





