/**
 * Terraform Outputs
 * Displays deployed service information after successful apply
 */

output "service_url" {
  description = "HTTPS URL of the deployed Cloud Run service"
  value       = google_cloud_run_service.nginx.status[0].url
}

output "service_name" {
  description = "Name of the Cloud Run service"
  value       = google_cloud_run_service.nginx.name
}

output "service_location" {
  description = "Region where service is deployed"
  value       = google_cloud_run_service.nginx.location
}

output "service_id" {
  description = "Fully qualified service identifier"
  value       = google_cloud_run_service.nginx.id
}

output "is_public" {
  description = "Whether the service allows unauthenticated access"
  value       = var.allow_unauthenticated
}

output "container_image" {
  description = "Container image deployed to the service"
  value       = var.container_image
}

output "resource_limits" {
  description = "Configured CPU and memory limits"
  value = {
    cpu    = var.cpu_limit
    memory = var.memory_limit
  }
}
