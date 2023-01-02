data "google_client_config" "default" {}

data "google_project" "this" {}

data "google_compute_zones" "available" {
  project = var.project
  region  = var.region
}

data "google_container_engine_versions" "available" {
  location       = var.region
  version_prefix = "1.2"
}
