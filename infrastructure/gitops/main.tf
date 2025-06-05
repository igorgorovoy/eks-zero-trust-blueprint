locals {
  is_argocd = var.gitops_engine == "argocd"
  is_fluxcd = var.gitops_engine == "fluxcd"
}

resource "helm_release" "argocd" {
  count = local.is_argocd ? 1 : 0

  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  namespace  = "argocd"

  create_namespace = true
  version          = "5.52.0"

  set {
    name  = "server.service.type"
    value = "LoadBalancer"
  }
}

resource "helm_release" "fluxcd" {
  count = local.is_fluxcd ? 1 : 0

  name       = "flux"
  repository = "https://fluxcd-community.github.io/helm-charts"
  chart      = "flux2"
  namespace  = "flux-system"

  create_namespace = true
  version          = "2.12.1"
}
