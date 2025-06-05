provider "aws" {
  region = var.region
}

module "vpc" {
  source = "./terraform/vpc"
  
  # Передаємо теги та інші змінні
  tags = {
    Environment = var.environment
    Project     = var.cluster_name
  }
}

module "eks" {
  source = "./terraform/eks"
  
  cluster_name       = var.cluster_name
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  
  tags = {
    Environment = var.environment
    Project     = var.cluster_name
  }
  
  depends_on = [module.vpc]
}

module "karpenter" {
  source = "./terraform/karpenter"
  
  cluster_name     = var.cluster_name
  cluster_endpoint = module.eks.cluster_endpoint
  
  tags = {
    Environment = var.environment
    Project     = var.cluster_name
  }
  
  depends_on = [module.eks]
} 