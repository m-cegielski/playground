resource "helm_release" "sealed_secrets" {
  provider = helm.kind

  name       = "sealed-secrets"
  repository = "https://bitnami-labs.github.io/sealed-secrets"
  chart      = "sealed-secrets"
  version    = "2.7.2"
  namespace  = "kube-system"

  values = [
    <<VALUES
secretName: sealed-secrets-tf-key
keyrenewperiod: 0
VALUES
  ]

  depends_on = [kubernetes_secret.this]
}
# key renewal disabled so that one key is used for encryption,
# this will allow me to destroy clusters without recreating SealedSecrets

resource "tls_self_signed_cert" "encryption_key" {
  private_key_pem       = tls_private_key.this.private_key_pem
  is_ca_certificate     = true
  set_subject_key_id    = true
  validity_period_hours = 87600

  subject {
    common_name = "sealed-secrets"
  }

  allowed_uses = [
    "encipher_only",
  ]
}

resource "tls_private_key" "this" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "kubernetes_secret" "this" {
  provider = kubernetes.kind

  metadata {
    name      = "sealed-secrets-tf-key"
    namespace = "kube-system"
    labels = {
      "sealedsecrets.bitnami.com/sealed-secrets-key" = "active"
    }
  }

  data = {
    "tls.crt" = tls_self_signed_cert.encryption_key.cert_pem
    "tls.key" = tls_private_key.this.private_key_pem
  }

  type = "kubernetes.io/tls"
}

# resource "kubectl_manifest" "test_secret" {
#   yaml_body = <<YAML

# YAML
# }
