### Master encryption key
resource "google_kms_crypto_key" "this" {
  name     = "etcd-${random_id.this.id}"
  key_ring = google_kms_key_ring.this.id
  purpose  = "ENCRYPT_DECRYPT"

}

resource "google_kms_key_ring" "this" {
  name     = "etcd-${random_id.this.id}"
  location = var.region
  project  = var.project
}

# Allow GKE to use the KMS key to encrypt/decrypt
resource "google_kms_crypto_key_iam_member" "this" {
  crypto_key_id = google_kms_crypto_key.this.id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member        = "serviceAccount:service-${data.google_project.this.number}@container-engine-robot.iam.gserviceaccount.com"
}

resource "random_id" "this" {
  byte_length = 8
}
