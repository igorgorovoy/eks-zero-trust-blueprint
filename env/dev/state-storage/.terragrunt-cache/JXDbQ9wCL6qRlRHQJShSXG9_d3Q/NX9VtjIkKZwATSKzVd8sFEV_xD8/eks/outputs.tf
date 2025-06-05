output "cluster_name" {
  description = "Name of the EKS cluster"
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "Endpoint for the EKS control plane"
  value       = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "Security Group ID attached to the cluster"
  value       = module.eks.cluster_security_group_id
}

output "node_group_role_arn" {
  description = "IAM role ARN for the default node group"
  value       = module.eks.eks_managed_node_groups["default"].iam_role_arn
}
