# Deploy Cloud Run Service with Terraform

## Introduction

Welcome! This interactive tutorial will guide you through deploying an nginx-based Cloud Run service using Terraform.

**Time to complete**: About 5 minutes

**What you'll do**:
- Configure your GCP project settings
- Customize your Cloud Run deployment
- Deploy infrastructure with Terraform
- Access your running service

Click **Start** below to begin!

## Set up your environment

First, let's make sure you're working in the correct directory and have the necessary tools.

```bash
cd ~/cloudshell_open/shell-test
ls -la
```

You should see the Terraform configuration files:
- `main.tf` - Main infrastructure definition
- `variables.tf` - Input variables
- `outputs.tf` - Output values
- `setup.sh` - Deployment script

## Configure your GCP Project

Let's set your GCP project ID. This is where your Cloud Run service will be deployed.

Run the following command to see your current project:

```bash
gcloud config get-value project
```

<walkthrough-project-setup></walkthrough-project-setup>

Now, let's save your project ID for use in the deployment:

```bash
export TF_VAR_project_id={{project-id}}
echo "Project ID: $TF_VAR_project_id"
```

## Choose your region

Select a region for your Cloud Run service. The default is `us-central1`.

Common regions:
- `us-central1` (Iowa)
- `us-east1` (South Carolina)
- `europe-west1` (Belgium)
- `asia-northeast1` (Tokyo)

Set your preferred region:

```bash
export TF_VAR_region="us-central1"
echo "Region: $TF_VAR_region"
```

**Tip**: You can change `us-central1` to any region you prefer!

## Customize your service

Let's configure the Cloud Run service settings.

### Service Name

Choose a name for your Cloud Run service:

```bash
export TF_VAR_service_name="nginx-demo"
echo "Service name: $TF_VAR_service_name"
```

### Resource Allocation

Configure CPU and memory:

```bash
export TF_VAR_cpu="1"
export TF_VAR_memory="512Mi"
export TF_VAR_max_instances="10"
echo "Resources: ${TF_VAR_cpu} CPU, ${TF_VAR_memory} memory, max ${TF_VAR_max_instances} instances"
```

**Options**:
- CPU: `1`, `2`, `4`
- Memory: `256Mi`, `512Mi`, `1Gi`, `2Gi`

### Public Access

Enable public access (no authentication required):

```bash
export TF_VAR_allow_unauthenticated="true"
echo "Public access: $TF_VAR_allow_unauthenticated"
```

## Review your configuration

Let's review all the settings before deployment:

```bash
echo "==================================="
echo "Deployment Configuration"
echo "==================================="
echo "Project ID: $TF_VAR_project_id"
echo "Region: $TF_VAR_region"
echo "Service Name: $TF_VAR_service_name"
echo "CPU: $TF_VAR_cpu"
echo "Memory: $TF_VAR_memory"
echo "Max Instances: $TF_VAR_max_instances"
echo "Public Access: $TF_VAR_allow_unauthenticated"
echo "==================================="
```

Look good? Let's proceed to deployment!

## Initialize Terraform

Initialize the Terraform working directory:

```bash
terraform init
```

This will download the necessary provider plugins (Google Cloud provider).

## Plan your deployment

Review what Terraform will create:

```bash
terraform plan
```

This shows you:
- ✅ Resources that will be created
- 📋 Configuration details
- 🔍 Any potential issues

**Review the output** to ensure everything looks correct!

## Deploy your infrastructure

Ready to deploy? Run:

```bash
terraform apply -auto-approve
```

This will:
1. Enable required GCP APIs (Cloud Run, Artifact Registry)
2. Create the Cloud Run service with nginx
3. Configure IAM for public access (if enabled)

**Wait for completion** - this typically takes 2-3 minutes.

## View your service

Once deployment completes, Terraform will output your service URL.

Get the service URL:

```bash
terraform output service_url
```

Click the URL or copy it to your browser to see your nginx service running!

You can also view it in the Cloud Console:

```bash
echo "https://console.cloud.google.com/run/detail/$TF_VAR_region/$TF_VAR_service_name/metrics?project=$TF_VAR_project_id"
```

## Test your service

Let's test the service with curl:

```bash
SERVICE_URL=$(terraform output -raw service_url)
curl -s $SERVICE_URL | head -20
```

You should see the nginx welcome page HTML!

## Make changes (Optional)

Want to modify your deployment? Edit the variables and re-apply:

```bash
export TF_VAR_max_instances="5"
terraform apply -auto-approve
```

Terraform will update only what changed!

## Clean up resources

When you're done, you can destroy the resources to avoid charges:

```bash
terraform destroy -auto-approve
```

This will:
- ❌ Delete the Cloud Run service
- ❌ Remove IAM bindings
- ✅ Keep API enablement (no disruption to other services)

**Note**: Only run this if you want to remove everything!

## Congratulations!

<walkthrough-conclusion-trophy></walkthrough-conclusion-trophy>

You've successfully:
- ✅ Configured a GCP project for Cloud Run
- ✅ Deployed infrastructure with Terraform
- ✅ Launched a containerized nginx service
- ✅ Made it publicly accessible

### What's next?

- Customize the nginx configuration
- Add your own container images
- Implement CI/CD pipelines
- Explore Cloud Run features (traffic splitting, authentication)

### Useful commands

```bash
# View all resources
terraform state list

# Show specific resource details
terraform show

# Format Terraform files
terraform fmt

# Validate configuration
terraform validate
```

### Learn more

- [Cloud Run documentation](https://cloud.google.com/run/docs)
- [Terraform Google Provider](https://registry.terraform.io/providers/hashicorp/google/latest/docs)
- [Cloud Shell documentation](https://cloud.google.com/shell/docs)

Thank you for using this tutorial! 🎉

