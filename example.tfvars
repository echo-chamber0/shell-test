# Example Terraform Variables File
# Copy this to terraform.tfvars and customize for your deployment

# REQUIRED: Your GCP Project ID
project_id = "your-gcp-project-id"

# OPTIONAL: Deployment Configuration

# Region for Cloud Run service
region = "us-central1"

# Name of the Cloud Run service
service_name = "nginx-demo"

# CPU allocation (1, 2, or 4)
cpu = "1"

# Memory allocation (256Mi, 512Mi, 1Gi, 2Gi, etc.)
memory = "512Mi"

# Minimum number of instances (0 for scale-to-zero)
min_instances = 0

# Maximum number of instances
max_instances = 10

# Allow public access without authentication
allow_unauthenticated = true

# Container port (nginx default is 80)
container_port = 80

# ==============================================================================
# Example Configurations
# ==============================================================================

# Development / Cost-Optimized
# ------------------------------------------------------------------------------
# cpu                   = "1"
# memory                = "256Mi"
# min_instances         = 0
# max_instances         = 3
# allow_unauthenticated = true

# Production / Performance-Optimized
# ------------------------------------------------------------------------------
# cpu                   = "2"
# memory                = "1Gi"
# min_instances         = 1
# max_instances         = 100
# allow_unauthenticated = false

# High-Traffic / Enterprise
# ------------------------------------------------------------------------------
# cpu                   = "4"
# memory                = "2Gi"
# min_instances         = 5
# max_instances         = 1000
# allow_unauthenticated = false

