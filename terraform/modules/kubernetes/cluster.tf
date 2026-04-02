resource "google_container_cluster" "prod_cluster" {
  name                = "cluster-ecomm-prod"
  location            = "us-central1-a"
  initial_node_count  = 2
  network             = var.network
  subnetwork          = var.subnet_prod
  deletion_protection = false
  
  // Autenticação federada ao cluster
  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  node_config {
    service_account = var.kube_sa
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
    labels = {
      env = "prod"
    }
    tags = ["env", "prod"]
  }
  timeouts {
    create = "30m"
    update = "40m"
  }
}

resource "google_gke_hub_membership" "prod_membership" {
  membership_id = "prod-member"
  location = "us-central1"
  endpoint {
    gke_cluster {
      resource_link = "//container.googleapis.com/${google_container_cluster.prod_cluster.id}"
    }
  }
}

resource "google_container_cluster" "stag_cluster" {
  name                = "cluster-ecomm-stag"
  location            = "us-central1-a"
  initial_node_count  = 2
  network             =  var.network
  subnetwork          = var.subnet_stag
  deletion_protection = false

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  node_config {
    service_account = var.kube_sa
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
    labels = {
      env = "staging"
    }
    tags = ["env", "staging"]
  }
  timeouts {
    create = "30m"
    update = "40m"
  }
}

resource "google_gke_hub_membership" "stag_membership" {
  membership_id = "stag-member"
  location = "us-central1"
  endpoint {
    gke_cluster {
      resource_link = "//container.googleapis.com/${google_container_cluster.stag_cluster.id}"
    }
  }
}