include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../infrastructure/state-storage"
}

# Цей модуль має використовувати локальний бекенд, оскільки він створює S3 бакет
prevent_destroy = true

inputs = {
  state_bucket_name    = "eks-zero-trust-dev-terraform-state"
  dynamodb_table_name  = "eks-zero-trust-dev-terraform-locks"
  
  tags = {
    Environment = "dev"
    Project     = "eks-zero-trust"
    ManagedBy   = "terragrunt"
  }
} 