resource "aws_iam_role" "lambda_role" {
  name = var.lambda_role_name
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Principal": { "Service": "lambda.amazonaws.com" },
    "Action": "sts:AssumeRole"
  }]
}
EOF
}

resource "aws_iam_policy" "lambda_policy" {
  name = "${var.lambda_role_name}_policy"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["s3:PutObject", "s3:GetObject"],
      "Resource": "arn:aws:s3:::${var.bucket_name}/*"
    },
    {
      "Effect": "Allow",
      "Action": ["dynamodb:PutItem", "dynamodb:Scan"],
      "Resource": "arn:aws:dynamodb:${var.region}:*:table/${var.dynamodb_table_name}"
    }
  ]
}
EOF
}

resource "aws_lambda_function" "upload_lambda" {
  function_name = var.upload_lambda_name
  role          = aws_iam_role.lambda_role.arn
  runtime       = "python3.8"
  handler       = "upload_csv_lambda.lambda_handler"
  filename      = "lambdas/upload_csv_lambda.zip"
}

resource "aws_lambda_function" "retrieve_lambda" {
  function_name = var.retrieve_lambda_name
  role          = aws_iam_role.lambda_role.arn
  runtime       = "python3.8"
  handler       = "retrieve_data_lambda.lambda_handler"
  filename      = "lambdas/retrieve_data_lambda.zip"
}

variable "upload_lambda_name" {}
variable "retrieve_lambda_name" {}
variable "lambda_role_name" {}
variable "bucket_name" {}
variable "dynamodb_table_name" {}

output "upload_lambda_arn" {
  value = aws_lambda_function.upload_lambda.arn
}

output "retrieve_lambda_arn" {
  value = aws_lambda_function.retrieve_lambda.arn
}

