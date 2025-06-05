include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_parent_terragrunt_dir()}/infrastructure//state-storage"
}

# Перевизначаємо бекенд для state-storage модуля
remote_state {
  backend = "local"
  config = {
    path = "${path_relative_to_include()}/terraform.tfstate"
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

# # Цей модуль має використовувати локальний бекенд, оскільки він створює S3 бакет
 prevent_destroy = true

locals {
  # Імпортуємо змінні з root.hcl
  root_vars = read_terragrunt_config(find_in_parent_folders("root.hcl"))
  
  # Витягуємо потрібні змінні
  environment    = "dev"
  aws_account_id = local.root_vars.locals.aws_account_id
  common_tags    = {
    Environment = local.environment
    Team        = "platform"
    CostCenter  = "platform-${local.environment}"
    ManagedBy   = "terragrunt"
  }
}

inputs = {
  # Налаштування S3 бакету
  state_bucket_name = "${local.aws_account_id}-eks-zero-trust-${local.environment}-terraform-state"
  
  # Налаштування DynamoDB таблиці
  dynamodb_table_name = "${local.aws_account_id}-eks-zero-trust-${local.environment}-terraform-locks"
  
  # Додаткові теги
  tags = local.common_tags
} 