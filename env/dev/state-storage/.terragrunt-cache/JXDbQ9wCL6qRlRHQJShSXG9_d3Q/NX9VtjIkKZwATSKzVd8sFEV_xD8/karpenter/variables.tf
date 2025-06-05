variable "cluster_name" {
  description = "EKS Cluster Name"
  type        = string
}

variable "cluster_endpoint" {
  description = "EKS Cluster Endpoint"
  type        = string
}

variable "tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default = {
    Project = "eks-zero-trust"
  }
}
