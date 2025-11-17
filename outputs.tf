output "service_url" {
  description = "URL of the deployed Cloud Run service"
  value       = google_cloud_run_v2_service.nginx.uri
}

output "service_name" {
  description = "Name of the Cloud Run service"
  value       = google_cloud_run_v2_service.nginx.name
}

output "service_location" {
  description = "Location of the Cloud Run service"
  value       = google_cloud_run_v2_service.nginx.location
}

output "project_id" {
  description = "GCP Project ID"
  value       = var.project_id
}

output "public_access" {
  description = "Whether the service allows unauthenticated access"
  value       = var.allow_unauthenticated
}

