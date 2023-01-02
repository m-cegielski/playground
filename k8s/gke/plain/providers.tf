provider "google" {
  project = var.project
  region  = var.region
}

provider "google-beta" {
  project = var.project
  region  = var.region
}

provider "kubernetes" {
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.44.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 4.44.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.16.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.4.3"
    }

  }
}
