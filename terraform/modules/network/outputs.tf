output network {
  value       = google_compute_network.vpc.name
}

output subnet_prod {
  value       = google_compute_subnetwork.subnet_prod.name
}

output subnet_stag {
  value       = google_compute_subnetwork.subnet_stag.name
}