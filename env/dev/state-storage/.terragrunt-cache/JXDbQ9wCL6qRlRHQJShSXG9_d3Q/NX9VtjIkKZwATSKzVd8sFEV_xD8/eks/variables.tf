variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "eks-zero-trust"

}

variable "cluster_version" {
  description = "EKS Kubernetes version"
  type        = string
  default     = "1.32"
}

variable "vpc_id" {
  description = "VPC ID to deploy EKS into"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for EKS"
  type        = list(string)
}

variable "tags" {
  description = "Tags to apply to EKS resources"
  type        = map(string)
  default = {
    Project = "eks-zero-trust"
  }
}
