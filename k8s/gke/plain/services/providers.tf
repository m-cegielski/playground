provider "google" {
  project = var.project
}

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.44.0"
    }
  }
}

variable "project" {
  type    = string
  default = "c-mi-eval"
}
