# Data Commons Cloud Run Deployment

Production-ready automated deployment of Data Commons service on Google Cloud Run using Terraform.

## Quick Start

[![Open in Cloud Shell](https://gstatic.com/cloudssh/images/open-btn.svg)](https://shell.cloud.google.com/cloudshell/editor?cloudshell_git_repo=https://github.com/Arturio93/shell-test.git&cloudshell_tutorial=tutorial.md)

Click the button above to deploy in Google Cloud Shell. The deployment process is fully automated with an interactive configuration interface.

## What Gets Deployed

- **Cloud Run Service**: Serverless container platform with auto-scaling
- **Container Image**: nginx web server (configurable)
- **IAM Configuration**: Public or authenticated access
- **HTTPS Endpoint**: Automatic SSL certificate provisioning

**Estimated Cost**: $0.00/month (within GCP free tier for low traffic)

## Prerequisites

- Google Cloud Project with billing enabled
- Required IAM permissions: `roles/run.admin`, `roles/iam.serviceAccountUser`

Cloud Shell provides automatic authentication. No additional setup required.

## Manual Deployment (Local)

If deploying from local environment:

```bash
# Clone repository
git clone https://github.com/Arturio93/shell-test.git
cd shell-test

# Install dependencies
pip install -r requirements.txt

# Run configuration
python setup.py

# Deploy infrastructure
cd terraform
terraform init
terraform apply

# Get service URL
terraform output service_url
```

## Configuration

The interactive setup collects:

- **Project ID**: GCP project for resource deployment
- **Service Name**: Cloud Run service identifier
- **Region**: Deployment region (us-central1, europe-west1, etc.)
- **Access Control**: Public or authenticated access

Configuration is validated and stored in `terraform/terraform.tfvars`.

## Architecture

```
Internet (HTTPS)
     |
Cloud Run Service
     |
Container (nginx)
     |
Auto-scaling: 0-10 instances
CPU: 1 vCPU (1000m)
Memory: 256 MiB
```

## Resource Cleanup

To remove all deployed resources:

```bash
./cleanup.sh
```

Or manually:

```bash
cd terraform
terraform destroy
```

## Customization

### Container Image

Edit `terraform/variables.tf`:

```hcl
variable "container_image" {
  default = "your-registry/your-image:tag"
}
```

### Resource Limits

Edit `terraform/variables.tf`:

```hcl
variable "cpu_limit" {
  default = "2000m"  # 2 vCPU
}

variable "memory_limit" {
  default = "512Mi"  # 512 MiB
}
```

## Support

For issues or questions, consult the [Cloud Run Documentation](https://cloud.google.com/run/docs) or [Terraform GCP Provider Documentation](https://registry.terraform.io/providers/hashicorp/google/latest/docs).

## License

MIT License - see LICENSE file for details.
