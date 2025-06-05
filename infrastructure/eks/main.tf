module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.8.5"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  vpc_id          = var.vpc_id
  subnet_ids      = var.private_subnet_ids

  enable_irsa = true

  eks_managed_node_group_defaults = {
    ami_type       = "AL2_ARM_64"
    instance_types = ["t4g.medium", "c7g.large"]
    disk_size      = 50
  }

  eks_managed_node_groups = {
    default = {
      desired_size = 2
      max_size     = 4
      min_size     = 1
      name         = "graviton-ng"
      capacity_type = "ON_DEMAND"
      taints = []
      labels = {
        "arch" = "arm64"
      }
    }
  }

  tags = var.tags
}
