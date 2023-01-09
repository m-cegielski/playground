resource "random_id" "this" {
  byte_length = 8
}

# resource "aws_kms_key" "helm_secrets" {
#   deletion_window_in_days = 7
#   enable_key_rotation     = true
# }

# resource "google_kms_key_ring" "helm_secrets" {
#   name     = "helm"
#   location = "global"
# }

# resource "google_kms_crypto_key" "helm_secrets" {
#   name            = "helm"
#   key_ring        = google_kms_key_ring.helm_secrets.id
#   rotation_period = "100000s"
#   purpose         = "ENCRYPT"
# }
