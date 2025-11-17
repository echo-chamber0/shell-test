variable "project_id" {
  description = "GCP Project ID where resources will be created"
  type        = string
}

variable "region" {
  description = "GCP region for Cloud Run service"
  type        = string
  default     = "us-central1"
}

variable "service_name" {
  description = "Name of the Cloud Run service"
  type        = string
  default     = "nginx-demo"
}

variable "container_port" {
  description = "Port on which the container listens"
  type        = number
  default     = 80
}

variable "allow_unauthenticated" {
  description = "Allow unauthenticated access to the service"
  type        = bool
  default     = false
}

variable "min_instances" {
  description = "Minimum number of instances"
  type        = number
  default     = 0
}

variable "max_instances" {
  description = "Maximum number of instances"
  type        = number
  default     = 10
}

variable "memory" {
  description = "Memory allocation for each instance (e.g., 256Mi, 512Mi, 1Gi)"
  type        = string
  default     = "512Mi"
}

variable "cpu" {
  description = "CPU allocation for each instance (e.g., 1, 2)"
  type        = string
  default     = "1"
}

