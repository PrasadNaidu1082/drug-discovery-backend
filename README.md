🚀 Drug Discovery Data Ingestion API
📌 Overview
This project provides a RESTful API for handling drug discovery data. It allows users to:
✅ Upload CSV files via an API request.
✅ Store the data in Amazon S3 and DynamoDB.
✅ Retrieve the stored data in JSON format via an API request.
✅ Ensure data validation before ingestion.

Built using AWS Lambda, API Gateway, S3, DynamoDB, and Python (Boto3).

🏗️ Architecture
AWS Services Used
AWS Lambda → Backend processing of CSV files.
API Gateway → Exposes REST API endpoints.
Amazon S3 → Stores CSV data in JSON format.
Amazon DynamoDB → Stores structured drug discovery data.
IAM Roles → Secure API access.
System Flow
1️⃣ User uploads a CSV file via a POST request.
2️⃣ Lambda processes the CSV and:

Uploads the data to S3 in JSON format.
Stores structured data in DynamoDB for quick retrieval.
3️⃣ User retrieves stored data via a GET request.
🛠️ Setup Instructions
1️⃣ Prerequisites
✅ AWS Account
✅ IAM Role with permissions for S3, DynamoDB, Lambda, API Gateway
✅ AWS CLI installed & configured
✅ Python 3.x

2️⃣ Deployment Steps
Step 1: Clone the Repository
sh
Copy
Edit
git clone https://github.com/yourusername/drug-discovery-api.git
cd drug-discovery-api
Step 2: Install Dependencies
sh
Copy
Edit
pip install boto3
Step 3: Set Up AWS Resources
Create an S3 Bucket

sh
Copy
Edit
aws s3 mb s3://drug-discovery-data-bucket
Create a DynamoDB Table

sh
Copy
Edit
aws dynamodb create-table \
    --table-name DrugDiscoveryData \
    --attribute-definitions AttributeName=drug_name,AttributeType=S \
    --key-schema AttributeName=drug_name,KeyType=HASH \
    --billing-mode PAY_PER_REQUEST
Deploy Lambda Functions

Upload upload_csv_lambda.py & retrieve_data_lambda.py
Assign IAM Roles with S3 & DynamoDB permissions
🔥 API Endpoints & Usage
1️⃣ Upload CSV File
POST /upload
Uploads a CSV file and stores it in S3 & DynamoDB.

📌 Request Example (cURL)

sh
Copy
Edit
curl -X POST "https://your-api-gateway-url/prod/upload" \
     -H "Content-Type: text/csv" \
     --data-binary @drug-data.csv
📌 Response Example

json
Copy
Edit
{
  "message": "CSV uploaded successfully and stored in DynamoDB",
  "file": "drug_data_1234abcd.json"
}
2️⃣ Retrieve Stored Data
GET /data
Fetches drug discovery data from DynamoDB.

📌 Request Example (cURL)

sh
Copy
Edit
curl -X GET "https://your-api-gateway-url/prod/data"
📌 Response Example

json
Copy
Edit
[
  {
    "drug_name": "Aspirin",
    "target": "Blood Thinner",
    "efficacy": "High"
  },
  {
    "drug_name": "Paracetamol",
    "target": "Pain Relief",
    "efficacy": "Medium"
  }
]
🔐 Security & IAM Roles
Make sure your Lambda functions have the following policies:
✅ S3 PutObject → To store CSV data in S3.
✅ DynamoDB PutItem & Scan → To store and retrieve data.
✅ API Gateway Invoke → To handle API requests.

🛠 Possible Enhancements
🔹 Add AWS Cognito authentication for secure access.
🔹 Use Amazon Athena for advanced querying.
🔹 Integrate AWS Step Functions for complex workflows.

📜 License
MIT License

👨‍💻 Contributors
🔹 Your Name

🎯 Final Thoughts
This project automates drug discovery data ingestion and makes it easily retrievable via APIs. It’s a scalable, serverless solution that can be expanded for AI-driven drug research! 🚀
