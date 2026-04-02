output kube_sa {
  value       = google_service_account.service_account_gke.email
}

output build_sa {
  value       = google_service_account.service_account_build.id
}