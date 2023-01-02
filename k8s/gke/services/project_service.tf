resource "google_project_service" "project" {
  for_each = toset([
    "cloudresourcemanager.googleapis.com",
    "container.googleapis.com",
    "compute.googleapis.com",
    "cloudkms.googleapis.com"
  ])

  project = var.project
  service = each.key
}

# # Enable Google Cloud APIs
# module "enable_google_apis" {
#   source  = "terraform-google-modules/project-factory/google//modules/project_services"
#   version = "~> 14.0"

#   project_id                  = var.gcp_project_id
#   disable_services_on_destroy = false

#   # activate_apis is the set of base_apis and the APIs required by user-configured deployment options
#   activate_apis = var.required_apis
# }
