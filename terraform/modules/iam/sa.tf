resource "google_service_account" "service_account_gke" {
  account_id   = "gke-operator-sa-usa"
  display_name = "Service Account Para o GKE"
}

resource "google_service_account" "service_account_gke_wif" {
  account_id   = "gke-application-sa-usa"
  display_name = "Service Account Para o GKE usar o WIF"
}

resource "google_service_account" "service_account_build" {
  account_id   = "cloudbuild-operator-sa-usa"
  display_name = "Service Account Para o Cloud Build"
}