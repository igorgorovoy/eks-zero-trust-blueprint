include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  environment = "dev"
  
  # Загальні теги для всіх ресурсів
  common_tags = {
    Environment = local.environment
    Team        = "platform"
    CostCenter  = "platform-${local.environment}"
  }

  # VPC налаштування
  vpc_cidr = "10.0.0.0/16"
  private_subnets = [
    "10.0.0.0/19",
    "10.0.32.0/19",
    "10.0.64.0/19"
  ]
  public_subnets = [
    "10.0.96.0/19",
    "10.0.128.0/19",
    "10.0.160.0/19"
  ]

  # EKS налаштування
  cluster_version = "1.32"
  
  # Налаштування нод
  node_groups = {
    default = {
      desired_size = 2
      min_size     = 1
      max_size     = 4
      instance_types = ["t4g.medium", "c7g.large"]
    }
  }

  tags = {
    Environment = local.environment
    Project     = "eks-zero-trust"
    ManagedBy   = "terragrunt"
  }
} 