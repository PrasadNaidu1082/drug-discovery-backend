# 🚀 Drug Discovery Data API (AWS Lambda, S3, DynamoDB)

This project provides a **RESTful API** built using **AWS Lambda & API Gateway**, designed to **ingest, store, and retrieve drug discovery data** from CSV files. The data is securely stored in **Amazon S3 and DynamoDB**, enabling fast retrieval for further analysis.

## 📌 Features

✅ Upload CSV files via an API (POST request)  
✅ Automatically store CSV data in **S3** (for backup) and **DynamoDB** (for querying)  
✅ Retrieve stored data as a **JSON response** (GET request)  
✅ **Basic data validation** to ensure correct format and required fields  
✅ **Scalable & serverless** using AWS Lambda  

---

## 🏗️ Architecture

1. **User uploads a CSV file** via API (POST request).  
2. The **Lambda function decodes and processes the file**, validating its structure.  
3. The **data is stored in S3 (as JSON) and DynamoDB** (for quick retrieval).  
4. A **GET request fetches stored data** from DynamoDB.  

📌 **Technologies Used:**  
- AWS Lambda (Python)  
- API Gateway  
- Amazon S3  
- Amazon DynamoDB  
- IAM Roles & Policies  

---

## ⚙️ Setup & Deployment

### **1️⃣ Prerequisites**
- AWS Account with access to **Lambda, API Gateway, S3, and DynamoDB**
- AWS CLI configured with necessary IAM permissions
- Python 3.x installed locally (for testing)

### **2️⃣ Deploying the Solution**
#### **Step 1: Create an S3 Bucket**
```sh
aws s3 mb s3://drug-discovery-data-bucket
