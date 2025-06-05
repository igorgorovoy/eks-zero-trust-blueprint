provider "helm" {
  kubernetes {
    config_path = var.kubeconfig_path
  }
}

resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  namespace  = "cert-manager"

  create_namespace = true
  version          = "v1.14.4"

  set {
    name  = "installCRDs"
    value = "true"
  }
}
