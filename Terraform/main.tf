terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.16.0"
    }
  }
}

provider "google" {
  project     = "lexical-aquifer-445708-u1"
  region      = "asia-southeast1"
  credentials = "key.json"
}

resource "google_container_cluster" "autopilot_cluster_1" {
  name               = "autopilot-cluster-1"
  location           = "asia-southeast1-a" # Change to single zone
  initial_node_count = 1 

  deletion_protection = false
  
  release_channel {
    channel = "REGULAR"
  }

  network    = "projects/lexical-aquifer-445708-u1/global/networks/firstvpc"
  subnetwork = "projects/lexical-aquifer-445708-u1/regions/asia-southeast1/subnetworks/public-subnet"

  ip_allocation_policy {   
    stack_type      = "IPV4_IPV6"     
  }
  
  datapath_provider = "ADVANCED_DATAPATH"

  addons_config {
    horizontal_pod_autoscaling {
      disabled = false
    }
    http_load_balancing {
      disabled = false
    }
  }

  monitoring_service = "monitoring.googleapis.com/kubernetes"
  logging_service    = "logging.googleapis.com/kubernetes"
}

resource "google_container_node_pool" "public_node_pool" {
  name       = "public-node-pool"
  cluster    = google_container_cluster.autopilot_cluster_1.name
  location   = "asia-southeast1-a" # Match single zone
  node_count = 1

  node_config {
    machine_type = "e2-medium"
    image_type   = "COS_CONTAINERD"
    disk_type    = "pd-balanced"
    disk_size_gb = 15

    metadata = {
      disable-legacy-endpoints = "true"
    }

    labels = {
      role = "frontend" # Node role label
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/trace.append",
    ]

    service_account = "terraform-svc@lexical-aquifer-445708-u1.iam.gserviceaccount.com"
  }

  upgrade_settings {
    max_surge       = 1
    max_unavailable = 0
  }
}

resource "google_container_node_pool" "private_node_pool" {
  name       = "private-node-pool"
  cluster    = google_container_cluster.autopilot_cluster_1.name
  location   = "asia-southeast1-a" # Match single zone
  node_count = 1

  node_config {
    machine_type = "e2-medium"
    image_type   = "COS_CONTAINERD"
    disk_type    = "pd-balanced"
    disk_size_gb = 15

    metadata = {
      disable-legacy-endpoints = "true"
    }
    labels = {
      role = "backend" # Node role label
    }
    oauth_scopes = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/trace.append",
    ]

    service_account = "terraform-svc@lexical-aquifer-445708-u1.iam.gserviceaccount.com"
  }

  upgrade_settings {
    max_surge       = 1
    max_unavailable = 0
  }
}
