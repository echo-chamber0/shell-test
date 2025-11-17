# 🚀 Cloud Run Deployment with Terraform

[![Open in Cloud Shell](https://gstatic.com/cloudssh/images/open-btn.svg)](https://shell.cloud.google.com/cloudshell/editor?cloudshell_git_repo=https://github.com/YOUR_USERNAME/shell-test&cloudshell_tutorial=tutorial.md)

Deploy a Cloud Run service with nginx using Terraform through an interactive experience in Google Cloud Shell!

## ✨ Features

- 🎯 **Interactive Tutorial** - Step-by-step guidance in Cloud Shell
- 🖥️ **User-Friendly CLI** - Beautiful terminal UI with color-coded prompts
- ⚡ **Quick Deployment** - Deploy in under 5 minutes
- 🔧 **Fully Configurable** - Customize all Cloud Run settings
- 🏗️ **Infrastructure as Code** - Clean Terraform configuration
- 🔒 **Secure** - Optional authentication for your service
- 📊 **Resource Management** - Configure CPU, memory, and scaling

## 🎬 Quick Start

### Option 1: Open in Cloud Shell (Recommended)

Click the "Open in Cloud Shell" button above! It will:
1. Clone this repository
2. Open an interactive tutorial
3. Guide you through the entire deployment

### Option 2: Manual Setup

If you prefer to work locally or in your own environment:

```bash
# Clone the repository
git clone https://github.com/YOUR_USERNAME/shell-test.git
cd shell-test

# Run the interactive setup
./setup.sh
```

### Option 3: Direct Terraform

For experienced users who want to skip the interactive setup:

```bash
# Initialize Terraform
terraform init

# Create terraform.tfvars with your settings
cat > terraform.tfvars <<EOF
project_id              = "your-project-id"
region                  = "us-central1"
service_name            = "nginx-demo"
cpu                     = "1"
memory                  = "512Mi"
min_instances           = 0
max_instances           = 10
allow_unauthenticated   = true
EOF

# Plan and apply
terraform plan
terraform apply
```

## 📋 What Gets Deployed

This Terraform configuration creates:

- ✅ **Cloud Run Service** - Containerized nginx server
- ✅ **API Enablement** - Automatically enables Cloud Run and Artifact Registry APIs
- ✅ **IAM Configuration** - Optional public access configuration
- ✅ **Auto-scaling** - Configurable min/max instances
- ✅ **Resource Limits** - CPU and memory allocation

## 🛠️ Configuration Options

### Variables

| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| `project_id` | GCP Project ID | - | Yes |
| `region` | GCP region for deployment | `us-central1` | No |
| `service_name` | Name of the Cloud Run service | `nginx-demo` | No |
| `cpu` | CPU allocation (1, 2, or 4) | `1` | No |
| `memory` | Memory allocation | `512Mi` | No |
| `min_instances` | Minimum number of instances | `0` | No |
| `max_instances` | Maximum number of instances | `10` | No |
| `allow_unauthenticated` | Allow public access | `true` | No |
| `container_port` | Container port | `80` | No |

### Example Configurations

**Development (Cost-optimized)**
```hcl
cpu                     = "1"
memory                  = "256Mi"
min_instances           = 0
max_instances           = 3
allow_unauthenticated   = true
```

**Production (Performance-optimized)**
```hcl
cpu                     = "2"
memory                  = "1Gi"
min_instances           = 1
max_instances           = 100
allow_unauthenticated   = false
```

## 📖 Interactive Setup Script

The `setup.sh` script provides a beautiful, user-friendly interface:

### Features:
- 🎨 **Color-coded output** - Easy to read and understand
- ✅ **Input validation** - Ensures your configuration is valid
- 🔍 **Project verification** - Checks project exists and is accessible
- 📝 **Configuration summary** - Review before deployment
- 🎯 **Step-by-step process** - Clear progress indicators
- 💾 **Configuration saving** - Saves settings to `terraform.tfvars`
- 🚀 **Automatic deployment** - Handles Terraform init, plan, and apply
- 🌐 **Browser integration** - Opens service URL in Cloud Shell preview

### Screenshots

The setup script includes:
- ASCII art welcome banner
- Interactive menus for region selection
- Resource configuration prompts
- Real-time validation
- Deployment progress indicators
- Success confirmation with service URL

## 🎓 Interactive Tutorial

The `tutorial.md` file provides a Cloud Shell tutorial experience:

### Tutorial Sections:
1. **Introduction** - Overview and objectives
2. **Environment Setup** - Verify tools and directory
3. **Project Configuration** - Set GCP project
4. **Region Selection** - Choose deployment region
5. **Service Customization** - Configure Cloud Run settings
6. **Configuration Review** - Verify settings
7. **Terraform Init** - Initialize providers
8. **Deployment Plan** - Review infrastructure changes
9. **Apply Changes** - Deploy infrastructure
10. **Service Testing** - Test the deployed service
11. **Cleanup** - Optional resource deletion

### Tutorial Features:
- Embedded Cloud Shell commands
- Interactive project selector
- Step-by-step code blocks
- Tips and best practices
- Links to relevant documentation
- Success trophy at completion 🏆

## 🔗 Creating the "Open in Cloud Shell" Link

To create your own "Open in Cloud Shell" button:

### Basic Format:
```
https://shell.cloud.google.com/cloudshell/editor?cloudshell_git_repo=REPO_URL
```

### With Tutorial:
```
https://shell.cloud.google.com/cloudshell/editor?cloudshell_git_repo=REPO_URL&cloudshell_tutorial=tutorial.md
```

### With Custom Working Directory:
```
https://shell.cloud.google.com/cloudshell/editor?cloudshell_git_repo=REPO_URL&cloudshell_working_dir=SUBDIRECTORY&cloudshell_tutorial=tutorial.md
```

### Complete Example:
```markdown
[![Open in Cloud Shell](https://gstatic.com/cloudssh/images/open-btn.svg)](https://shell.cloud.google.com/cloudshell/editor?cloudshell_git_repo=https://github.com/YOUR_USERNAME/shell-test&cloudshell_tutorial=tutorial.md)
```

### Parameters Explained:
- `cloudshell_git_repo` - URL of your git repository
- `cloudshell_tutorial` - Path to tutorial file (relative to repo root)
- `cloudshell_working_dir` - Set working directory after clone
- `cloudshell_open_in_editor` - File to open in editor
- `cloudshell_print` - Message to print on startup

## 📁 Project Structure

```
shell-test/
├── README.md                 # This file
├── tutorial.md               # Interactive Cloud Shell tutorial
├── setup.sh                  # Interactive deployment script
├── main.tf                   # Main Terraform configuration
├── variables.tf              # Input variable definitions
├── outputs.tf                # Output value definitions
├── .gitignore               # Git ignore rules
└── terraform.tfvars         # Variable values (generated by setup.sh)
```

## 🔧 Terraform Details

### Provider Requirements

```hcl
terraform {
  required_version = ">= 1.0"
  
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}
```

### Resources Created

1. **`google_project_service.run_api`** - Enables Cloud Run API
2. **`google_project_service.artifact_registry_api`** - Enables Artifact Registry API
3. **`google_cloud_run_v2_service.nginx`** - Cloud Run service with nginx
4. **`google_cloud_run_v2_service_iam_member.public_access`** - IAM for public access (optional)

### Outputs

After deployment, you'll get:
- `service_url` - Public URL of your service
- `service_name` - Name of the deployed service
- `service_location` - Region where service is deployed
- `project_id` - Your GCP project ID
- `public_access` - Whether public access is enabled

## 🧪 Testing Your Deployment

### Using curl:
```bash
SERVICE_URL=$(terraform output -raw service_url)
curl $SERVICE_URL
```

### Using your browser:
```bash
# Get the URL
terraform output service_url

# Open it in Cloud Shell preview (if in Cloud Shell)
cloudshell open-workspace-url $(terraform output -raw service_url)
```

### View logs:
```bash
gcloud run services logs read nginx-demo --region=us-central1 --limit=50
```

## 🎯 Use Cases

This template is perfect for:

- 🎓 **Learning** - Understand Cloud Run and Terraform
- 🧪 **Prototyping** - Quick service deployments
- 📚 **Workshops** - Teaching infrastructure as code
- 🏗️ **Foundation** - Base for more complex services
- 🔄 **CI/CD** - Template for automated deployments

## 🔄 Making Changes

### Update Configuration:
1. Edit `terraform.tfvars`
2. Run `terraform apply`
3. Terraform will show what changed
4. Confirm to apply changes

### Example - Scale Up:
```bash
# Edit terraform.tfvars
echo 'max_instances = 20' >> terraform.tfvars

# Apply changes
terraform apply
```

## 🧹 Cleanup

### Using Terraform:
```bash
terraform destroy
```

### Using gcloud:
```bash
gcloud run services delete nginx-demo --region=us-central1
```

### Cost Considerations:
- Cloud Run has a generous free tier
- You're only charged when your service is running
- Scale to zero (`min_instances = 0`) to minimize costs
- Delete resources when done testing

## 📚 Learn More

### Documentation:
- [Cloud Run Documentation](https://cloud.google.com/run/docs)
- [Terraform Google Provider](https://registry.terraform.io/providers/hashicorp/google/latest/docs)
- [Cloud Shell Documentation](https://cloud.google.com/shell/docs)
- [Cloud Shell Tutorials](https://cloud.google.com/shell/docs/tutorial-authoring)

### Related Resources:
- [Cloud Run Samples](https://github.com/GoogleCloudPlatform/cloud-run-samples)
- [Terraform Examples](https://github.com/terraform-google-modules)
- [GCP Best Practices](https://cloud.google.com/docs/enterprise/best-practices-for-enterprise-organizations)

## 🤝 Contributing

Feel free to:
- Report issues
- Submit pull requests
- Suggest improvements
- Share your customizations

## 📝 License

This project is provided as-is for educational and demonstration purposes.

## 🆘 Troubleshooting

### Common Issues:

**"APIs not enabled"**
```bash
# The script handles this automatically, but you can manually enable:
gcloud services enable run.googleapis.com
gcloud services enable artifactregistry.googleapis.com
```

**"Permission denied"**
```bash
# Ensure you have necessary permissions:
gcloud projects add-iam-policy-binding PROJECT_ID \
  --member=user:YOUR_EMAIL \
  --role=roles/run.admin
```

**"Service not responding"**
- Wait 30-60 seconds for service to fully start
- Check logs: `gcloud run services logs read SERVICE_NAME --region=REGION`
- Verify the service is running: `gcloud run services list`

**"Terraform state issues"**
```bash
# Refresh state
terraform refresh

# Or import existing resources
terraform import google_cloud_run_v2_service.nginx projects/PROJECT_ID/locations/REGION/services/SERVICE_NAME
```

## 💡 Tips & Best Practices

1. **Start Small** - Use the default configuration first
2. **Scale Gradually** - Increase resources as needed
3. **Monitor Costs** - Use billing alerts
4. **Use Variables** - Don't hardcode values
5. **Version Control** - Commit your `terraform.tfvars` to private repos only
6. **Test Locally** - Validate Terraform before applying
7. **Read Logs** - They're your friend for debugging
8. **Clean Up** - Destroy test resources when done

## 🎉 Success!

If you've made it this far, you're ready to deploy! Click the "Open in Cloud Shell" button at the top and let's get started! 🚀

---

**Made with ❤️ for the GCP community**

*Questions? Open an issue or check the documentation links above.*

