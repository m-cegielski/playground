resource "kubernetes_namespace" "argo" {
  provider = kubernetes.kind

  metadata {
    annotations = {
      "app.kubernetes.io/part-of" = "argocd"
    }

    labels = {
      name = "argocd"
    }

    name = "argocd"
  }
}

# resource "helm_release" "argo" {
#   provider = helm.kind

#   name       = "argo"
#   repository = "https://argoproj.github.io/argo-helm"
#   chart      = "argo-cd"
#   version    = "5.16.1"
#   namespace  = "argocd"

#   lifecycle {
#     ignore_changes = all
#   }
#   depends_on = [kubernetes_namespace.argo, helm_release.cilium]
# }
