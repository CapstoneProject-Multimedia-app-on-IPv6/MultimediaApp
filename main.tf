provider "google" {
  project = "norse-case-439506-h4"
  region  = "us-central1"          
}

resource "google_compute_network" "app_vpc" {
  name = "music-app-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "app_subnet" {
  name               = "ipv6-subnet"
  region             = "us-central1"
  network            = google_compute_network.app_vpc.id
  ip_cidr_range      = "10.0.0.0/16"    # Dải IPv4 CIDR
  stack_type         = "IPV4_IPV6"      # Hỗ trợ IPv4 và IPv6
  ipv6_access_type   = "EXTERNAL"       # IPv6 công khai
  
}

resource "google_compute_firewall" "allow_ipv6" {
  name    = "allow-ipv6"
  network = google_compute_network.app_vpc.name

  allow {
    protocol = "tcp"
    ports    = ["80", "443", "22"]
  }

  direction     = "INGRESS"
  source_ranges = ["::/0"] # Cho phép tất cả IPv6
}

resource "google_compute_instance" "app_instance" {
  name         = "app-backend"
  machine_type = "e2-medium"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "ubuntu-2004-focal-v20201014"
    }
  }

  network_interface {
    network    = google_compute_network.app_vpc.id
    subnetwork = google_compute_subnetwork.app_subnet.id
    stack_type = "IPV4_IPV6"

    access_config {
      # External IPv4 Address
    }
    ipv6_access_config {
      network_tier = "PREMIUM"
    }
  }

  metadata_startup_script = <<-EOT
  #!/bin/bash
  sudo su
  # Cập nhật hệ thống
  apt update -y
  apt upgrade -y
  apt install -y nodejs npm git nginx curl

  # Gỡ cài đặt Node.js cũ (nếu có)
  apt remove -y nodejs

  # Cài đặt Node.js phiên bản 18
  curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
  apt install -y nodejs

  # Tải resource
  cd /home/ubuntu
  git clone https://github.com/HuyQuahM/Test.git
  cd /home/ubuntu/Test/backend
  npm install
  screen -dmS app npm start

  # Cấu hình Nginx
  cat << 'NGINX' > /etc/nginx/sites-available/music-app
  server {
    listen [::]:80;
    server_name _;

    location / {
        proxy_pass http://[::]:5000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
  }
  NGINX

  # Kích hoạt Nginx
  ln -s /etc/nginx/sites-available/music-app /etc/nginx/sites-enabled/
  rm /etc/nginx/sites-enabled/default
  systemctl enable nginx
  systemctl restart nginx

  EOT
}
output "ipv6_address" {
  value = length(google_compute_instance.app_instance.network_interface[0].ipv6_access_config) > 0 ? google_compute_instance.app_instance.network_interface[0].ipv6_access_config[0].external_ipv6 : "No IPv6 assigned"
}

