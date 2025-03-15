
variable "region" {
  default = "ap-south-1"
}

variable "bucket_name" {
  default = "drug-discovery-tf-bucket"
}

variable "dynamodb_table_name" {
  default = "DrugDiscoveryTFTable"
}

variable "lambda_role_name" {
  default = "DrugDiscoveryLambdaRole"
}

variable "upload_lambda_name" {
  default = "UploadCSVLambdaTF"
}

variable "retrieve_lambda_name" {
  default = "RetrieveDataLambdaTF"
}

variable "api_gateway_name" {
  default = "DrugDiscoveryAPITF"
}
