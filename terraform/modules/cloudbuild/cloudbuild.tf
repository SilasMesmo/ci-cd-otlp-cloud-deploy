resource "google_cloudbuild_trigger" "prod_trigger" {
  location = "us-central1"
  service_account = var.build_sa

  repository_event_config {
    repository = google_cloudbuildv2_repository.repository.id
    push {
      branch = "^main$"
    }
  }

  substitutions = {
    _IMAGE_NAME = var.image_name
    _REPO_NAME  = var.repo_name
  }

  filename = "ci-cd/cloudbuild.yaml"
}