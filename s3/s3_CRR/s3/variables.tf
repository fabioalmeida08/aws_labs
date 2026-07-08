variable "bucket_name" {
  description = "Nome do bucket de origem"
  type        = string
}

variable "destination_bucket_name" {
  description = "Nome do bucket de réplica"
  type        = string
}

variable "origin_region" {
  description = "Região do bucket de origem"
  type        = string
}

variable "replica_region" {
  description = "Região do bucket de réplica"
  type        = string
}

variable "replication_role_arn" {
  type = string
}