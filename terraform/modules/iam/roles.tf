// CLOUD BUILD
resource "google_project_iam_member" "cloudbuild_writer" {
  project = var.project_id
  role    = "roles/artifactregistry.writer"
  member  = "serviceAccount:${google_service_account.service_account_build.email}"
}

resource "google_project_iam_member" "cloudbuild_gke_developer" {
  project = var.project_id
  role    = "roles/container.developer"
  member  = "serviceAccount:${google_service_account.service_account_build.email}"
}

resource "google_project_iam_member" "cloudbuild_logs_writer" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.service_account_build.email}"
}

resource "google_project_iam_member" "cloudbuild_deploy_ops" {
  project = var.project_id
  role    = "roles/clouddeploy.operator"
  member  = "serviceAccount:${google_service_account.service_account_build.email}"
}

resource "google_project_iam_member" "cloudbuild_deploy_builder" {
  project = var.project_id
  role    = "roles/cloudbuild.builds.builder"
  member  = "serviceAccount:${google_service_account.service_account_build.email}"
}

resource "google_project_iam_member" "cloudbuild_sa_user" {
  project = var.project_id
  role    = "roles/iam.serviceAccountUser"
  member  = "serviceAccount:${google_service_account.service_account_build.email}"
}


// KUBERNETES
resource "google_project_iam_member" "gke_ar_reader" {
  project = var.project_id
  role    = "roles/artifactregistry.reader"
  member  = "serviceAccount:${google_service_account.service_account_gke.email}"
}

resource "google_project_iam_member" "gke_metric_writer" {
  project = var.project_id
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${google_service_account.service_account_gke.email}"
}

// Recurso para vincular a GSA (google service account) com a KSA (kubernetes service account) 
// KSA assume o papel da GSA para fazer a auteticação federada com a GCP
resource "google_service_account_iam_binding" "ksa_use_gsa" {
  service_account_id = google_service_account.service_account_gke_wif.id
  role               = "roles/iam.workloadIdentityUser"

  members = [
    "serviceAccount:${var.project_id}.svc.id.goog[app/ksa-http-rest]"
  ]
}

// Chama a SA do Agente do CloudBuild para receber a role que permite acesso ao secret
data "google_iam_policy" "secret_accessor" {
  binding {
    role = "roles/secretmanager.secretAccessor"
    members = ["serviceAccount:service-${var.project_number}@gcp-sa-cloudbuild.iam.gserviceaccount.com"]
  }
}

resource "google_secret_manager_secret_iam_policy" "policy" {
  project     = var.project_id
  secret_id   = "github-ecomm-secret-v2"
  policy_data = data.google_iam_policy.secret_accessor.policy_data
}

// SA de Log Writer
resource "google_project_iam_member" "compute_logs" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${var.project_number}-compute@developer.gserviceaccount.com"
}


resource "google_project_iam_member" "compute_storage_get" {
  project = var.project_id
  role    = "roles/cloudbuild.builds.builder"
  member  = "serviceAccount:${var.project_number}-compute@developer.gserviceaccount.com"
}

resource "google_project_iam_member" "compute_kube_deploy" {
  project = var.project_id
  role    = "roles/container.developer"
  member  = "serviceAccount:${var.project_number}-compute@developer.gserviceaccount.com"
}