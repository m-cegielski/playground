module "enable_google_apis" {
  source  = "terraform-google-modules/project-factory/google//modules/project_services"
  version = "~> 14.0"

  project_id                  = var.project
  disable_services_on_destroy = false

  # activate_apis is the set of base_apis and the APIs required by user-configured deployment options
  activate_apis = local.base_apis
}

locals {
  base_apis = [
    #"cloudresourcemanager.googleapis.com",
    "compute.googleapis.com",
  ]
}
