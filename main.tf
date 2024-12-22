provider "google" {
  project = "norse-case-439506-h4"
  region  = "us-central1"          
}

resource "google_compute_network" "music_app_vpc" {
  name = "music-app-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "ipv6_subnet" {
  name               = "ipv6-subnet"
  region             = "us-central1"
  network            = google_compute_network.music_app_vpc.id
  ip_cidr_range      = "10.0.0.0/16"    # Dải IPv4 CIDR
  stack_type         = "IPV4_IPV6"      # Hỗ trợ IPv4 và IPv6
  ipv6_access_type   = "EXTERNAL"       # IPv6 công khai
  
}

resource "google_compute_firewall" "allow_ipv6" {
  name    = "allow-ipv6"
  network = google_compute_network.music_app_vpc.name

  allow {
    protocol = "tcp"
    ports    = ["80", "443", "22"]
  }

  direction     = "INGRESS"
  source_ranges = ["::/0"] # Cho phép tất cả IPv6
}

resource "google_compute_instance" "music_app_instance" {
  name         = "music-app-backend"
  machine_type = "e2-medium"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "ubuntu-2004-focal-v20201014"
    }
  }

  network_interface {
    network    = google_compute_network.music_app_vpc.id
    subnetwork = google_compute_subnetwork.ipv6_subnet.id
    stack_type = "IPV4_IPV6"

    access_config {
      # External IPv4 Address
    }
    ipv6_access_config {
      network_tier = "PREMIUM"
    }
  }

  metadata_startup_script = <<-EOT
  EOT
}
output "ipv6_address" {
  value = length(google_compute_instance.music_app_instance.network_interface[0].ipv6_access_config) > 0 ? google_compute_instance.music_app_instance.network_interface[0].ipv6_access_config[0].external_ipv6 : "No IPv6 assigned"
}