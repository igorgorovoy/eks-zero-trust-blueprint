locals {
  # Завантажуємо конфігурації
  region_vars  = read_terragrunt_config("${get_repo_root()}/region.hcl")
  account_vars = read_terragrunt_config("${get_repo_root()}/account.hcl")

  # Витягуємо змінні
  aws_region     = local.region_vars.locals.aws_region
  aws_account_id = local.account_vars.locals.aws_account_id
  account_tags   = local.account_vars.locals.account_tags
  project_name   = "eks-zero-trust"
}

# Генеруємо версії провайдерів
generate "versions" {
  path      = "versions.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.35.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.26.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.12.0"
    }
  }
}
EOF
}

# Генеруємо провайдер AWS
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "${local.aws_region}"
  
  default_tags {
    tags = ${jsonencode(local.account_tags)}
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
    bucket         = "${local.project_name}-${path_relative_to_include()}-terraform-state"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = local.aws_region
    dynamodb_table = "${local.project_name}-${path_relative_to_include()}-terraform-locks"
  }
  
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
} 