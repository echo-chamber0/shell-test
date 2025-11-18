# Deployment Guide

## Quick Deployment

Use the "Open in Cloud Shell" button in README.md for automated deployment.

The process is fully automated:
1. Repository clones
2. Dependencies install
3. Interactive configuration launches
4. Follow prompts to deploy

## Manual Deployment

For local development:

```bash
# Clone and setup
git clone https://github.com/Arturio93/shell-test.git
cd shell-test
pip install -r requirements.txt

# Configure
python setup.py

# Deploy
cd terraform
terraform init
terraform apply

# Cleanup
terraform destroy
```

## Configuration Parameters

- **project_id**: GCP project identifier (required)
- **service_name**: Cloud Run service name (required)
- **region**: Deployment region (default: us-central1)
- **allow_unauthenticated**: Public access (default: true)

## Troubleshooting

### Permission Errors
Ensure your account has `roles/run.admin` permissions:
```bash
gcloud projects add-iam-policy-binding PROJECT_ID \
  --member="user:EMAIL@example.com" \
  --role="roles/run.admin"
```

### API Not Enabled
Enable required APIs:
```bash
gcloud services enable run.googleapis.com
```

### Terraform State Issues
If state becomes corrupted:
```bash
cd terraform
rm -rf .terraform terraform.tfstate*
terraform init
```

## Support

Consult official documentation:
- Cloud Run: https://cloud.google.com/run/docs
- Terraform: https://www.terraform.io/docs

