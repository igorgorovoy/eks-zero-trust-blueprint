resource "aws_iam_role" "karpenter_controller" {
  name = "karpenter-controller-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "eks.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "karpenter_controller_attach" {
  role       = aws_iam_role.karpenter_controller.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "helm_release" "karpenter" {
  name       = "karpenter"
  repository = "https://charts.karpenter.sh"
  chart      = "karpenter"
  namespace  = "karpenter"

  create_namespace = true
  version          = "v0.36.0"

  set {
    name  = "controller.clusterName"
    value = var.cluster_name
  }

  set {
    name  = "controller.clusterEndpoint"
    value = var.cluster_endpoint
  }

  set {
    name  = "serviceAccount.annotations.eks\.amazonaws\.com/role-arn"
    value = aws_iam_role.karpenter_controller.arn
  }
}

resource "kubectl_manifest" "karpenter_provisioner" {
  depends_on = [helm_release.karpenter]
  yaml_body  = file("${path.module}/provisioner.yaml")
}
