locals {
  # Автоматично завантажуємо account.hcl якщо він існує для AWS акаунта
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))

  # Автоматично завантажуємо region.hcl якщо він існує для регіону
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  # Витягуємо загальні змінні
  aws_region   = local.region_vars.locals.aws_region
  environment  = path_relative_to_include()
  project_name = "eks-zero-trust"
}

# Генеруємо провайдер AWS
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "${local.aws_region}"
  
  default_tags {
    tags = {
      Environment = "${local.environment}"
      Project     = "${local.project_name}"
      ManagedBy   = "terragrunt"
    }
  }
}
EOF
}

# Віддалений стейт в S3
remote_state {
  backend = "s3"
  
  # Пропускаємо створення бекенду для модуля state-storage
  disable_init = tobool(get_env("DISABLE_INIT", "false"))
  
  config = {
    encrypt        = true
    bucket         = "${local.project_name}-${local.environment}-terraform-state"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = local.aws_region
    dynamodb_table = "${local.project_name}-${local.environment}-terraform-locks"
  }
  
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
} 