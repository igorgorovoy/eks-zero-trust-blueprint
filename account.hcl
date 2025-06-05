locals {
  # ID AWS акаунту
  aws_account_id = "503473403687"  # Замініть на ваш AWS Account ID
  
  # Загальні теги для всіх ресурсів в акаунті
  account_tags = {
    Owner       = "platform-team"
    Terraform   = "true"
    Repository  = "eks-zero-trust-blueprint"
  }
} 