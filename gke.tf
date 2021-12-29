resource "google_container_cluster" "cluster" {
  name = "cluster"
  location = var.zone
  network = google_compute_network.vpc.self_link
  subnetwork = google_compute_subnetwork.subnet.self_link

  remove_default_node_pool = true
  initial_node_count = 1
}

resource "google_container_node_pool" "nodes" {
  name = "nodes"
  location = var.zone
  cluster = google_container_cluster.cluster.name
  node_count = 3

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/devstorage.read_only",
    ]
    preemptible = true
    machine_type = "e2-small"
    disk_size_gb = 10
    tags = ["node"]
  }
}
