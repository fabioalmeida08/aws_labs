provider "aws" {
  region = var.origin_region

  # Make it faster by skipping something
  skip_metadata_api_check     = true
  skip_region_validation      = true
  skip_credentials_validation = true
}

provider "aws" {
  region = var.replica_region

  alias = "replica"

  # Make it faster by skipping something
  skip_metadata_api_check     = true
  skip_region_validation      = true
  skip_credentials_validation = true
}

data "aws_caller_identity" "current" {}

module "replica_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "4.5.0"

  providers = {
    aws = aws.replica
  }

  bucket = var.destination_bucket_name

  versioning = {
    enabled = true
  }
}

module "s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "4.5.0"

  bucket = var.bucket_name

  versioning = {
    enabled = true
  }

  replication_configuration = {
    role = var.replication_role_arn

    rules = [
      {
        id     = "everything-without-filters"
        status = "Enabled"

        delete_marker_replication = true

        destination = {
          bucket        = "arn:aws:s3:::${var.destination_bucket_name}"
          storage_class = "STANDARD"
        }
      },
    ]
  }
  depends_on = [ module.replica_bucket ]
}