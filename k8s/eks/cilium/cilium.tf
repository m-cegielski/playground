resource "null_resource" "aws-node" {

  triggers = {
    cluster = module.eks.cluster_id
  }

  provisioner "local-exec" {
    on_failure  = fail
    when        = create
    interpreter = ["/bin/bash", "-c"]
    command     = <<-EOF
      set -e
      aws eks update-kubeconfig --name ${local.name} --region ${var.region} --kubeconfig ./config
      KUBECONFIG='./config' kubectl delete ds -n kube-system aws-node kube-proxy
      rm ./config
    EOF
  }

  depends_on = [module.eks]
}

resource "helm_release" "cilium" {
  name       = "cilium"
  repository = "https://helm.cilium.io"
  chart      = "cilium"
  version    = "1.12.4"
  namespace  = "kube-system"

  values = [
    <<-VALUES
    eni:
      enabled: true
      iamRole: "${module.vpc_cni_irsa_role.iam_role_arn}"
    hubble:
      enabled: true
      listenAddress: :4244
      metrics:
        enabled:
        - dns
        - drop
        - tcp
        - flow
        - port-distribution
        - icmp
        - http
      relay:
        enabled: true
      ui:
        enabled: true
    ipam:
      mode: eni
    k8sServiceHost: "${replace(module.eks.cluster_endpoint, "https://", "")}"
    k8sServicePort: 443
    kubeProxyReplacement: strict
    loadBalancer:
      algorithm: maglev
    VALUES
  ]

  depends_on = [null_resource.aws-node]
}
