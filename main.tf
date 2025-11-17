terraform {
  required_version = ">= 1.0"
  
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

# Enable required APIs
resource "google_project_service" "run_api" {
  service            = "run.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "artifact_registry_api" {
  service            = "artifactregistry.googleapis.com"
  disable_on_destroy = false
}

# Cloud Run service with nginx
resource "google_cloud_run_v2_service" "nginx" {
  name     = var.service_name
  location = var.region
  
  depends_on = [
    google_project_service.run_api
  ]

  template {
    scaling {
      min_instance_count = var.min_instances
      max_instance_count = var.max_instances
    }

    containers {
      image = "nginx:alpine"
      
      ports {
        container_port = var.container_port
      }
      
      resources {
        limits = {
          cpu    = var.cpu
          memory = var.memory
        }
      }

      # Simple custom nginx configuration
      volume_mounts {
        name       = "custom-html"
        mount_path = "/usr/share/nginx/html"
      }
    }

    volumes {
      name = "custom-html"
      empty_dir {
        medium     = "Memory"
        size_limit = "10Mi"
      }
    }
  }

  traffic {
    type    = "TRAFFIC_TARGET_ALLOCATION_TYPE_LATEST"
    percent = 100
  }

  lifecycle {
    ignore_changes = [
      client,
      client_version,
    ]
  }
}

# IAM policy to allow public access (if enabled)
resource "google_cloud_run_v2_service_iam_member" "public_access" {
  count    = var.allow_unauthenticated ? 1 : 0
  project  = google_cloud_run_v2_service.nginx.project
  location = google_cloud_run_v2_service.nginx.location
  name     = google_cloud_run_v2_service.nginx.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}

