provider "kind" {}

provider "helm" {
  alias = "kind"

  kubernetes {
    host                   = kind_cluster.this.server
    cluster_ca_certificate = base64decode(kind_cluster.this.ca_certificate_data)
    client_certificate     = base64decode(kind_cluster.this.client_certificate_data)
    client_key             = base64decode(kind_cluster.this.client_key_data)
  }
}

provider "kubernetes" {
  alias = "kind"

  host                   = kind_cluster.this.server
  cluster_ca_certificate = base64decode(kind_cluster.this.ca_certificate_data)
  client_certificate     = base64decode(kind_cluster.this.client_certificate_data)
  client_key             = base64decode(kind_cluster.this.client_key_data)
}

provider "kubectl" {
  alias = "kind"

  host                   = kind_cluster.this.server
  cluster_ca_certificate = base64decode(kind_cluster.this.ca_certificate_data)
  client_certificate     = base64decode(kind_cluster.this.client_certificate_data)
  client_key             = base64decode(kind_cluster.this.client_key_data)
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

provider "aws" {
  profile = "p-full"
  region  = var.aws_region
}

variable "gcp_region" {
  type    = string
  default = "us-central1"
}

provider "google" {
  project = "c-mi-eval"
  region  = var.gcp_region
}

terraform {
  required_providers {
    kind = {
      source = "justenwalker/kind"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}
