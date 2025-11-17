# Quick Start Guide

## For Cloud Shell Users (Recommended) ☁️

1. Click the "Open in Cloud Shell" button in README.md
2. Wait for Cloud Shell to load
3. The tutorial will open automatically
4. Follow the interactive guide!

## For Local Development 💻

### Prerequisites

- GCP Project with billing enabled
- `gcloud` CLI installed and authenticated
- `terraform` >= 1.5.0 installed
- `python` >= 3.9 installed
- Required IAM roles: `roles/run.admin`, `roles/iam.serviceAccountUser`

### Quick Commands

```bash
# 1. Clone repository
git clone <your-repo-url>
cd <repo-name>

# 2. Run interactive setup
python setup.py

# 3. Deploy infrastructure
cd terraform
terraform init
terraform apply

# 4. Get service URL
terraform output service_url

# 5. Test service
curl $(terraform output -raw service_url)

# 6. Cleanup (when done)
cd ..
./cleanup.sh
```

## Alternative: One-Command Deploy

```bash
./deploy.sh
```

This script:
- Runs interactive setup (if needed)
- Initializes Terraform
- Shows plan
- Deploys infrastructure
- Displays service URL

## Troubleshooting

### Error: "gcloud not authenticated"

```bash
gcloud auth login
gcloud config set project YOUR_PROJECT_ID
```

### Error: "API not enabled"

```bash
gcloud services enable run.googleapis.com
```

### Error: "Permission denied"

```bash
# Grant yourself Cloud Run Admin role
gcloud projects add-iam-policy-binding PROJECT_ID \
  --member="user:YOUR_EMAIL@example.com" \
  --role="roles/run.admin"
```

### Error: "Terraform not found"

**macOS:**
```bash
brew install terraform
```

**Linux:**
```bash
wget https://releases.hashicorp.com/terraform/1.5.0/terraform_1.5.0_linux_amd64.zip
unzip terraform_1.5.0_linux_amd64.zip
sudo mv terraform /usr/local/bin/
```

## What Gets Deployed?

- **1x Cloud Run Service** - Serverless nginx container
- **1x IAM Binding** - Public access (if enabled)
- **Total Cost:** ~$0.00/month (free tier eligible)

## Configuration Options

Edit `terraform/terraform.tfvars` after running setup:

```hcl
# Change region
region = "europe-west1"

# Change CPU/Memory
cpu_limit = "2000m"
memory_limit = "512Mi"

# Use custom image
container_image = "your-registry/your-image:tag"
```

Then run `terraform apply` to update.

## Project Structure

```
.
├── README.md              # Full documentation
├── QUICKSTART.md          # This file
├── tutorial.md            # Cloud Shell tutorial
├── setup.py               # Interactive configuration
├── deploy.sh              # One-command deploy
├── cleanup.sh             # Resource cleanup
├── requirements.txt       # Python deps
└── terraform/
    ├── main.tf            # Infrastructure code
    ├── variables.tf       # Input variables
    ├── outputs.tf         # Output values
    └── terraform.tfvars   # Your config (gitignored)
```

## Next Steps

After successful deployment:

1. **View in Console:** https://console.cloud.google.com/run
2. **Check Logs:** `gcloud logging read "resource.type=cloud_run_revision" --limit=50`
3. **Update Service:** Modify terraform files, run `terraform apply`
4. **Add Domain:** Follow [Cloud Run domain mapping](https://cloud.google.com/run/docs/mapping-custom-domains)
5. **Setup CI/CD:** Integrate with Cloud Build

## Resources

- [Cloud Run Docs](https://cloud.google.com/run/docs)
- [Terraform GCP Provider](https://registry.terraform.io/providers/hashicorp/google/latest/docs)
- [Rich Library](https://rich.readthedocs.io/)
- [Questionary Docs](https://questionary.readthedocs.io/)

---

**Need Help?** Open an issue on GitHub!

