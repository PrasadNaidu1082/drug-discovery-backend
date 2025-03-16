resource "aws_s3_bucket" "data_bucket" {
  bucket = var.bucket_name
}

variable "bucket_name" {}
output "bucket_name" {
  value = aws_s3_bucket.data_bucket.id
}
