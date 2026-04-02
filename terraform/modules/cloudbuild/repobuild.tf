resource "google_cloudbuildv2_connection" "connection" {
     project  = var.project_id
     location = "us-central1"
     name     = "conect-pipe-git"

     github_config {
    app_installation_id = var.git_install_id

    authorizer_credential {
      oauth_token_secret_version = google_secret_manager_secret_version.github_token_secret_version.id
    }
  }
}

resource "google_cloudbuildv2_repository" "repository" {
      project = var.project_id
      location = "us-central1"
      name = "pipe-repo"
      parent_connection = google_cloudbuildv2_connection.connection.name
      remote_uri = var.git_uri
}