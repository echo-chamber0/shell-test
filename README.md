# Data Commons Cloud Run Deployment

Fully automated deployment tool for Data Commons service on Google Cloud Run. No terminal commands needed - just answer a few questions and everything is deployed automatically.

## Quick Start

[![Open in Cloud Shell](https://gstatic.com/cloudssh/images/open-btn.svg)](https://shell.cloud.google.com/cloudshell/editor?cloudshell_git_repo=https://github.com/Arturio93/shell-test.git&cloudshell_tutorial=tutorial.md)

Click the button above. The deployment tool will start automatically and guide you through:

1. Project and service configuration (4 questions)
2. Automated infrastructure deployment
3. Service URL retrieval

**Total time:** 3-5 minutes. No commands to type.

## What Gets Deployed

- **Cloud Run Service**: Serverless container platform with auto-scaling (0-10 instances)
- **Container Image**: nginx web server (configurable)
- **IAM Configuration**: Public or authenticated access
- **HTTPS Endpoint**: Automatic SSL certificate provisioning

**Estimated Cost**: $0.00/month (within GCP free tier for low traffic)

## How It Works

The deployment tool automatically:

1. Validates your configuration inputs
2. Generates Terraform configuration files
3. Initializes Terraform
4. Plans infrastructure changes
5. Deploys to Google Cloud Run
6. Retrieves and displays the service URL

No manual terminal commands required.

## Prerequisites

- Google Cloud Project with billing enabled
- Required IAM permissions: `roles/run.admin`, `roles/iam.serviceAccountUser`

Cloud Shell provides automatic authentication.

## Manual Deployment (Optional)

If you prefer to run manually:

```bash
git clone https://github.com/Arturio93/shell-test.git
cd shell-test
pip install -r requirements.txt
python setup.py
```

The tool handles everything - no need to run terraform commands manually.

## Configuration Options

During setup, you'll be asked for:

- **Project ID**: GCP project identifier (validated format)
- **Service Name**: Cloud Run service name (DNS-compliant)
- **Region**: Deployment region (select from list)
- **Access Control**: Public or authenticated access

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

## Customization

To customize the deployment, edit `terraform/variables.tf`:

### Container Image

```hcl
variable "container_image" {
  default = "your-registry/your-image:tag"
}
```

### Resource Limits

```hcl
variable "cpu_limit" {
  default = "2000m"  # 2 vCPU
}

variable "memory_limit" {
  default = "512Mi"  # 512 MiB
}
```

## Resource Cleanup

To remove all deployed resources, run:

```bash
./cleanup.sh
```

The cleanup script automatically handles authentication and removes all resources. Manual cleanup is also possible but requires authentication setup:

```bash
export GOOGLE_OAUTH_ACCESS_TOKEN=$(gcloud auth print-access-token)
cd terraform && terraform destroy
```

## Troubleshooting

### Authentication Issues

If you see OAuth errors, the deployment tool will automatically refresh authentication tokens.

### Permission Errors

Ensure your account has required permissions:

```bash
gcloud projects add-iam-policy-binding PROJECT_ID \
  --member="user:YOUR_EMAIL@example.com" \
  --role="roles/run.admin"
```

### API Not Enabled

Enable required APIs:

```bash
gcloud services enable run.googleapis.com
```

## Features

- **Zero Command Line**: No terminal commands needed
- **Input Validation**: All inputs validated before deployment
- **Progress Indicators**: Visual feedback during deployment
- **Error Handling**: Clear error messages with solutions
- **Automatic Retry**: Authentication refresh on OAuth errors
- **Professional UI**: 3D ASCII art banner and formatted output

## Support

For issues or questions:
- [Cloud Run Documentation](https://cloud.google.com/run/docs)
- [Terraform GCP Provider](https://registry.terraform.io/providers/hashicorp/google/latest/docs)

## License

MIT License - see LICENSE file for details.
