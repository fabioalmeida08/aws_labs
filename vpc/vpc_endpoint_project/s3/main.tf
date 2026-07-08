resource "aws_s3_bucket" "s3_project_bucket" {
  bucket = "project-bucket-${random_string.bucket_suffix.result}"

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}


resource "random_string" "bucket_suffix" {
  length  = 8
  special = false
  upper   = false
}