resource "google_clouddeploy_target" "prod_target" {
  location          = "us-central1"
  name              = "prod-target"
  description       = "cluster de prod"
  project           = var.project_id
  require_approval  = true

  gke {
    cluster = var.prod_cluster_id
  }

  labels = {
    env = "prod"
  }
}

resource "google_clouddeploy_target" "stag_target" {
  location          = "us-central1"
  name              = "stag-target"
  description       = "cluster de staging"
  project           = var.project_id
  require_approval  = false

  gke {
    cluster = var.stag_cluster_id
  }

  labels = {
    env = "stag"
  }
}