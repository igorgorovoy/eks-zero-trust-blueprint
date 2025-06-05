variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-1"
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "eks-zero-trust"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
} 