resource "google_compute_network" "vpc" {
  name                    = "vpc-ecomm"
  auto_create_subnetworks = false
  project                 = var.project_id
}

resource "google_compute_subnetwork" "subnet_prod" {
  name          = "${google_compute_network.vpc.name}-subnet-pub"
  ip_cidr_range = "10.0.0.0/24"
  region        = "us-central1"
  network       = google_compute_network.vpc.id
  project       = var.project_id
}

resource "google_compute_subnetwork" "subnet_stag" {
  name          = "${google_compute_network.vpc.name}-subnet-priv"
  ip_cidr_range = "10.0.1.0/24"
  region        = "us-central1"
  network       = google_compute_network.vpc.id
  project       = var.project_id
}