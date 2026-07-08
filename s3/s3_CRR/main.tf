resource "random_pet" "this" {
  length = 2
}

locals {
  bucket_name             = "origin-s3-bucket-${random_pet.this.id}"
  destination_bucket_name = "replica-s3-bucket-${random_pet.this.id}"
  origin_region           = "us-east-1"
  replica_region          = "sa-east-1"
}

module "iam" {
  source                  = "./iam"
  bucket_name             = local.bucket_name
  destination_bucket_name = local.destination_bucket_name
  origin_region           = local.origin_region
  replica_region          = local.replica_region
  pet_name_id             = random_pet.this.id
}

module "s3" {
  source                  = "./s3"
  bucket_name             = local.bucket_name
  destination_bucket_name = local.destination_bucket_name
  origin_region           = local.origin_region
  replica_region          = local.replica_region
  replication_role_arn    = module.iam.replication_role_arn
}