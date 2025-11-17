/**
 * Terraform Outputs
 * 
 * These values are displayed after successful deployment
 * and can be queried with: terraform output <output_name>
 */

output "service_url" {
  description = "URL of the deployed Cloud Run service"
  value       = google_cloud_run_service.nginx.status[0].url
}

output "service_name" {
  description = "Name of the Cloud Run service"
  value       = google_cloud_run_service.nginx.name
}

output "service_location" {
  description = "Location where service is deployed"
  value       = google_cloud_run_service.nginx.location
}

output "service_id" {
  description = "Fully qualified service ID"
  value       = google_cloud_run_service.nginx.id
}

output "is_public" {
  description = "Whether the service allows unauthenticated access"
  value       = var.allow_unauthenticated
}

output "container_image" {
  description = "Container image deployed"
  value       = var.container_image
}

output "resource_limits" {
  description = "Configured resource limits"
  value = {
    cpu    = var.cpu_limit
    memory = var.memory_limit
  }
}

# Helpful commands displayed after apply
output "next_steps" {
  description = "Helpful commands to interact with your service"
  value = <<-EOT
  
  🎉 Deployment Successful!
  
  Service URL: ${google_cloud_run_service.nginx.status[0].url}
  
  Quick Commands:
  ---------------
  
  # Test your service
  curl ${google_cloud_run_service.nginx.status[0].url}
  
  # View service details
  gcloud run services describe ${google_cloud_run_service.nginx.name} --region=${google_cloud_run_service.nginx.location}
  
  # View logs
  gcloud logging read "resource.type=cloud_run_revision AND resource.labels.service_name=${google_cloud_run_service.nginx.name}" --limit=50
  
  # Update service (after making changes)
  terraform apply
  
  # Delete all resources
  terraform destroy
  
  EOT
}

