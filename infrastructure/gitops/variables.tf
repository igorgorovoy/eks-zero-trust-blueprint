variable "gitops_engine" {
  description = "GitOps tool to install (argocd or fluxcd)"
  type        = string
  default     = "argocd"
}
