module "gke" {
  source = "terraform-google-modules/kubernetes-engine/google//modules/beta-private-cluster"

  project_id = var.project
  name       = "c-mi-eval-gke"

  region     = var.region
  zones      = slice(data.google_compute_zones.available.names, 0, 3)
  network    = module.vpc.network.name
  subnetwork = module.subnets.subnets["${keys(module.subnets.subnets).0}"].name

  kubernetes_version = "1.24.5-gke.600"

  master_authorized_networks = []
  horizontal_pod_autoscaling = true
  gce_pd_csi_driver          = true                            # Enables Google Compute Engine Persistent Disk CSI
  network_policy             = false                           # Cilium preferred over Calico
  http_load_balancing        = true                            # Enables Ingress
  datapath_provider          = "DATAPATH_PROVIDER_UNSPECIFIED"
  ip_range_pods              = "us-central1-gke-pods"
  ip_range_services          = "us-central1-gke-services"
  initial_node_count         = 0
  remove_default_node_pool   = true

  database_encryption = [{
    state    = "ENCRYPTED"
    key_name = google_kms_crypto_key.this.id
  }]

  enable_private_endpoint = false

  node_pools = [
    {
      name               = "default-node-pool"
      machine_type       = "e2-medium"
      node_locations     = join(",", slice(data.google_compute_zones.available.names, 0, 3))
      min_count          = 1
      max_count          = 1
      local_ssd_count    = 0
      disk_size_gb       = 30
      disk_type          = "pd-standard"
      image_type         = "COS_CONTAINERD"
      enable_gcfs        = false
      auto_repair        = true
      auto_upgrade       = true
      preemptible        = false
      initial_node_count = 1
    },
  ]
}


