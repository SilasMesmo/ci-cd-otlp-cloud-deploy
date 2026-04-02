resource "google_clouddeploy_delivery_pipeline" "primary" {
  location    = "us-central1"
  name        = "pipeline-app"
  description = "basic description"
  project     = var.project_id

  serial_pipeline {
    stages {
      deploy_parameters {
        values = {
          deployParameterKey = "deployParameterValue"
        }
      }

      profiles  = ["stag"]
      target_id = google_clouddeploy_target.stag_target.name
    }

    stages {
      profiles  = ["prod"]
      target_id = google_clouddeploy_target.prod_target.name
    }
  }
}