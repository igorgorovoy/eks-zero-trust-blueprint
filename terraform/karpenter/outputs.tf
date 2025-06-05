output "karpenter_role_arn" {
  description = "IAM Role ARN for Karpenter"
  value       = aws_iam_role.karpenter_controller.arn
}
