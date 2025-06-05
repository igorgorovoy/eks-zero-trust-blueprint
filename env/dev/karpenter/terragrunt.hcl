include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../infrastructure/karpenter"
}

dependency "eks" {
  config_path = "../eks"

  mock_outputs = {
    cluster_name     = "eks-zero-trust-dev"
    cluster_endpoint = "https://example.com"
  }
}

inputs = {
  cluster_name     = dependency.eks.outputs.cluster_name
  cluster_endpoint = dependency.eks.outputs.cluster_endpoint
} 