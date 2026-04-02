resource "google_artifact_registry_repository" "app_repo" {
  project       = var.project_id
  location      = "us-central1"
  repository_id = "repositorio-ecomm-app"
  format        = "DOCKER"
}