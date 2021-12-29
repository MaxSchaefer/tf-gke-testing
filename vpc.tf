resource "google_compute_network" "vpc" {
  name = "vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name = "subnet"
  region = var.region
  network = google_compute_network.vpc.self_link
  ip_cidr_range = "10.10.10.0/24"
}

resource "google_compute_firewall" "load-balancer" {
  name = "load-balancer"
  network = google_compute_network.vpc.self_link

  direction = "INGRESS"
  source_ranges = [
    "130.211.0.0/22",
    "35.191.0.0/16"
  ]

  target_tags = ["node"]

  allow {
    protocol = "all"
  }
}

resource "google_compute_firewall" "public-http" {
  name = "public-http"
  network = google_compute_network.vpc.self_link

  direction = "INGRESS"
  source_ranges = ["0.0.0.0/0"]

  target_tags = ["public-http", "node"]

  allow {
    protocol = "tcp"
    ports = ["30080"]
  }
}

resource "google_compute_firewall" "public-https" {
  name = "public-https"
  network = google_compute_network.vpc.self_link

  direction = "INGRESS"
  source_ranges = ["0.0.0.0/0"]

  target_tags = ["public-https"]

  allow {
    protocol = "tcp"
    ports = ["30443"]
  }
}

resource "google_compute_global_address" "static-ip" {
  name = "static-ip"
}
