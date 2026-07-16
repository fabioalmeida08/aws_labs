resource "aws_s3_bucket" "terraform_bucket_test" {
  bucket = var.bucket_name

  tags = {
    Name        = "terraform_bucket"
    Environment = "Sandbox"
  }
}
