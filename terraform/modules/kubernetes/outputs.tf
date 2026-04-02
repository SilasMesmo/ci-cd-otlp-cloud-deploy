output prod_cluster_id {
  value       = google_container_cluster.prod_cluster.id
}

output stag_cluster_id {
  value       = google_container_cluster.stag_cluster.id
}