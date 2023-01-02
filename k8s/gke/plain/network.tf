module "vpc" {
  source  = "terraform-google-modules/network/google//modules/vpc"
  version = "6.0.0"

  project_id   = var.project
  network_name = "gke-vpc"
}

module "subnets" {
  source  = "terraform-google-modules/network/google//modules/subnets"
  version = "6.0.0"

  project_id   = var.project
  network_name = module.vpc.network.name

  subnets = [
    {
      subnet_name           = "gke-subnet-${var.region}"
      subnet_ip             = "10.0.0.0/24"
      subnet_region         = var.region
      subnet_private_access = "true"
    }
  ]

  secondary_ranges = {
    "gke-subnet-${var.region}" = [
      {
        range_name    = "us-central1-gke-pods"
        ip_cidr_range = "192.168.0.0/18"
      },
      {
        range_name    = "us-central1-gke-services"
        ip_cidr_range = "192.168.64.0/18"
      },
    ]
  }

}

module "firewall_rules" {
  source  = "terraform-google-modules/network/google//modules/firewall-rules"
  version = "6.0.0"

  project_id   = var.project
  network_name = module.vpc.network.name

  rules = [{
    name                    = "allow-ssh-ingress"
    description             = null
    direction               = "INGRESS"
    priority                = null
    ranges                  = ["0.0.0.0/0"]
    source_tags             = null
    source_service_accounts = null
    target_tags             = null
    target_service_accounts = null
    allow = [{
      protocol = "tcp"
      ports    = ["22"]
    }]
    deny = []
    log_config = {
      metadata = "INCLUDE_ALL_METADATA"
    }
  }]
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
