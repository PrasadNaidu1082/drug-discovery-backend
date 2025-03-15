provider "aws" {
  region = var.region
}

module "s3" {
  source      = "./modules/s3"
  bucket_name = var.bucket_name
}

module "dynamodb" {
  source               = "./modules/dynamodb"
  dynamodb_table_name  = var.dynamodb_table_name
}

module "lambda" {
  source                 = "./modules/lambda"
  upload_lambda_name     = var.upload_lambda_name
  retrieve_lambda_name   = var.retrieve_lambda_name
  bucket_name            = module.s3.bucket_name
  dynamodb_table_name    = module.dynamodb.dynamodb_table_name
}

module "api_gateway" {
  source               = "./modules/api_gateway"
  upload_lambda_arn    = module.lambda.upload_lambda_arn
  retrieve_lambda_arn  = module.lambda.retrieve_lambda_arn
}

