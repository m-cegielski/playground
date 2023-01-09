resource "kind_cluster" "this" {
  name          = "kind"
  image_version = "1.25"
  config        = <<KIND
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
- role: worker
- role: worker
networking:
  disableDefaultCNI: true
KIND
}

resource "helm_release" "cilium" {
  provider = helm.kind

  name       = "cilium"
  repository = "https://helm.cilium.io"
  chart      = "cilium"
  version    = "1.12.4"
  namespace  = "kube-system"

  values = [
    <<VALUES
hostServices:
  enabled: false
externalIPs:
  enabled: true
nodePort:
  enabled: true
hostPort:
  enabled: true
image:
  pullPolicy: IfNotPresent
ipam:
  mode: kubernetes
hubble:
  enabled: true
  relay:
    enabled: true
  ui:
    enabled: true
VALUES
  ]
}
