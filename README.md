# EKS Zero Trust Blueprint 

A production-ready template for building a secure, scalable, and observable Amazon EKS infrastructure.

![w](diagrams/zero-trust-eks.png)  

## What is Zero Trust and Why This Name?

This project is called "EKS Zero Trust Blueprint" because it implements a Zero Trust architecture for Kubernetes clusters in Amazon EKS.

Zero Trust is a security approach based on the principle "trust no one, verify everything". In the traditional security model, if you're inside the network - you're trusted. In the Zero Trust model - there is no trust by default, even if you're inside the network.

In this project, Zero Trust is implemented through the following components:

1. Network Policies - security rules that control who can communicate with whom inside the cluster
2. IAM roles and IRSA (IAM Roles for Service Accounts) - precise access rights configuration for each service
3. TLS with cert-manager or Istio - encryption of all traffic between services
4. Integration with AWS Secrets Manager for secure secrets storage

The project provides a ready-to-use template for deploying secure EKS infrastructure with modules for VPC, cluster security, autoscaling, GitOps, and monitoring - all built with Zero Trust principles in mind, meaning no default trust and explicit configuration of all permissions and communications.

## Features

- Zero Trust security: Network Policies, IAM roles, IRSA, TLS with cert-manager or Istio
- Karpenter autoscaling with ARM/Graviton node support
- GitOps with ArgoCD or FluxCD (selectable)
- Monitoring with Prometheus, Grafana, and Loki
- External Secrets integration with AWS Secrets Manager

## Modules

| Module        | Description                                             |
|---------------|---------------------------------------------------------|
| `vpc`         | AWS VPC with public/private subnets                    |
| `eks`         | EKS cluster, node groups, and IRSA setup               |
| `karpenter`   | Karpenter controller and provisioners                  |
| `gitops`      | ArgoCD or FluxCD installation and apps                 |
| `security`    | cert-manager or Istio, NetworkPolicies                 |
| `workloads`   | Example secure workload with NetworkPolicy + IRSA      |
| `monitoring`  | Prometheus, Grafana, Loki with Helm                    |

##  Getting Started

### Prerequisites
- Terraform >= 1.5
- AWS CLI configured
- kubectl & helm

### Usage

You can deploy the infrastructure using either the Makefile (recommended) or manual steps.

#### Using Makefile (Recommended)

```bash
# Show available commands
make help

# Initialize all modules
make init

# Deploy everything
make apply GITOPS_ENGINE=argocd

# Check cluster status
make status

# Clean up everything
make destroy
```

#### Manual Deployment

Set the GitOps engine you want to install (`argocd` or `fluxcd`) in your Terraform variables:

```hcl
variable "gitops_engine" {
  description = "GitOps tool to install (argocd or fluxcd)"
  type        = string
  default     = "argocd"
}
```

Then deploy:

```bash
cd terraform/vpc && terraform apply
cd ../eks && terraform apply
cd ../karpenter && terraform apply
cd ../gitops && terraform apply -var="gitops_engine=argocd"
cd ../security && terraform apply
cd ../monitoring && terraform apply
cd ../workloads && terraform apply
kubectl apply -f app.yaml
kubectl apply -f external-secret.yaml
```

## Architecture

![Architecture](diagrams/architecture.png)

## Roadmap

- [x] Secure VPC & EKS baseline
- [x] IRSA & Karpenter
- [x] ArgoCD & FluxCD toggle
- [ ] Add IAM Permissions Boundary
- [x] Examples: Secure workloads + GitOps delivery
- [x] Monitoring stack (Prometheus + Grafana)

##  License

MIT License

---