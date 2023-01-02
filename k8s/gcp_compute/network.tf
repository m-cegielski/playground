module "vpc" {
  source  = "terraform-google-modules/network/google//modules/vpc"
  version = "6.0.0"

  project_id   = var.project
  network_name = "vpc"
}

module "subnets" {
  source  = "terraform-google-modules/network/google//modules/subnets"
  version = "6.0.0"

  project_id   = var.project
  network_name = module.vpc.network.name

  subnets = [
    {
      subnet_name           = "subnet-${var.region}"
      subnet_ip             = "10.0.0.0/24"
      subnet_region         = var.region
      subnet_private_access = "true"
    }
  ]
}

module "firewall_rules" {
  source  = "terraform-google-modules/network/google//modules/firewall-rules"
  version = "6.0.0"

  project_id   = var.project
  network_name = module.vpc.network.name

  rules = [
    {
      name                    = "allow-ingress"
      ranges                  = ["0.0.0.0/0"]
      direction               = "INGRESS"
      priority                = null
      description             = null
      source_tags             = null
      source_service_accounts = null
      target_tags             = null
      target_service_accounts = null
      allow = [{
        protocol = "tcp"
        ports    = ["22", "443", "30000-40000"]
      }]
      deny = []
      log_config = {
        metadata = "INCLUDE_ALL_METADATA"
      }
    },
    # {
    #   name                    = "allow-local"
    #   direction               = "INGRESS"
    #   ranges                  = ["10.0.0.0/8"]
    #   priority                = null
    #   description             = null
    #   source_tags             = null
    #   source_service_accounts = null
    #   target_tags             = null
    #   target_service_accounts = null
    #   allow = [{
    #     protocol = "all"
    #     ports    = ["0-65535"]
    #   }]
    #   deny = []
    #   log_config = {
    #     metadata = "INCLUDE_ALL_METADATA"
    #   }
    # }
  ]
}


resource "google_compute_firewall" "rules" {
  direction = "INGRESS"
  name      = "allow-local"
  network   = "vpc"
  priority  = 1000
  project   = "cks-prep-c-mi"
  source_ranges = [
    "10.0.0.0/8",
  ]
  allow {
    protocol = "all"
  }
  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }
}
# resource "google_compute_router" "router" {
#   name    = "gke-router"
#   project = var.project
#   region  = var.region
#   network = module.vpc.network.name
# }

# resource "google_compute_router_nat" "nat" {
#   name                               = "gke-nat"
#   project                            = var.project
#   region                             = var.region
#   router                             = google_compute_router.router.name
#   source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
#   nat_ip_allocate_option             = "AUTO_ONLY"
# }
