/**
 * GCP Cloud Run Nginx Deployment
 * 
 * This Terraform configuration deploys an nginx web server
 * on Google Cloud Run with configurable public/private access.
 * 
 * Resources:
 * - Cloud Run Service (serverless container)
 * - IAM Policy (optional public access)
 */

terraform {
  required_version = ">= 1.5.0"
  
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

# Cloud Run Service
resource "google_cloud_run_service" "nginx" {
  name     = var.service_name
  location = var.region

  template {
    spec {
      containers {
        image = var.container_image
        
        # Resource limits
        resources {
          limits = {
            cpu    = var.cpu_limit
            memory = var.memory_limit
          }
        }
        
        # Container port (Cloud Run uses 8080 by default)
        ports {
          container_port = 8080
        }
      }
      
      # Concurrency: Maximum number of requests per container instance
      container_concurrency = 80
      
      # Service account (uses default if not specified)
      # service_account_name = google_service_account.cloudrun_sa.email
    }
  }

  # Traffic routing (100% to latest revision)
  traffic {
    percent         = 100
    latest_revision = true
  }

  # Metadata and annotations
  metadata {
    annotations = {
      # Autoscaling configuration
      "autoscaling.knative.dev/minScale" = "0"
      "autoscaling.knative.dev/maxScale" = "10"
      
      # Ingress: Allow all traffic
      "run.googleapis.com/ingress" = "all"
      
      # Client name for tracking
      "run.googleapis.com/client-name" = "terraform"
    }
    
    labels = {
      managed-by  = "terraform"
      environment = "demo"
      service     = "nginx"
    }
  }
  
  # Prevent accidental deletion during development
  # Set to true for production
  lifecycle {
    prevent_destroy = false
  }
}

# IAM policy for public access (if enabled)
# This allows unauthenticated users to invoke the service
resource "google_cloud_run_service_iam_member" "public_access" {
  count = var.allow_unauthenticated ? 1 : 0

  service  = google_cloud_run_service.nginx.name
  location = google_cloud_run_service.nginx.location
  project  = google_cloud_run_service.nginx.project
  role     = "roles/run.invoker"
  member   = "allUsers"
}

