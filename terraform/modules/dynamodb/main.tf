resource "aws_dynamodb_table" "drug_discovery" {
  name           = var.dynamodb_table_name
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "DrugID"

  attribute {
    name = "DrugID"
    type = "S"
  }
}

variable "dynamodb_table_name" {}
output "dynamodb_table_name" {
  value = aws_dynamodb_table.drug_discovery.name
}

