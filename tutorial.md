# Data Commons Cloud Run Deployment Tutorial

## Welcome

This tutorial guides you through deploying a containerized service on Google Cloud Run using Terraform.

**Time to complete:** Approximately 10 minutes  
**Cost:** Free tier eligible (no charges for low traffic)

<walkthrough-tutorial-duration duration="10"></walkthrough-tutorial-duration>

Click **Start** to begin the deployment process.

---
1. simple
[![Open in Cloud Shell](https://gstatic.com/cloudssh/images/open-btn.svg)](https://shell.cloud.google.com/cloudshell/editor?show=project_selector&cloudshell_git_repo=https://github.com/Arturio93/shell-test.git&cloudshell_tutorial=tutorial.md)
2. with hardcoded project 
[![Open in Cloud Shell](https://gstatic.com/cloudssh/images/open-btn.svg)](https://shell.cloud.google.com/cloudshell/editor?cloudshell_project=hl2-gogl-cdsi-t1iylu&cloudshell_git_repo=https://github.com/Arturio93/shell-test.git&cloudshell_tutorial=tutorial.md)

## Overview: Google Cloud Run

Google Cloud Run is a fully managed serverless platform for deploying containerized applications.

**Key Features:**
- Automatic scaling from zero to N instances
- Pay-per-use pricing (billed per 100ms of request time)
- Built-in HTTPS endpoints with automatic SSL
- Global deployment options

This tutorial deploys an nginx web server to demonstrate Cloud Run capabilities.

Click **Next** to proceed.

---

## Step 1: Verify Environment

Your Cloud Shell environment is pre-configured with:
- gcloud CLI (authenticated)
- terraform CLI
- Python 3.9+

Verify your active project:

```bash
gcloud config get-value project
```

If needed, set your project:

```bash
gcloud config set project PROJECT_ID
```

Click **Next** to continue.

---

## Step 2: Install Dependencies

Install Python dependencies required for the interactive configuration tool:

```bash
pip install -r requirements.txt
```

**Installed packages:**
- rich: Terminal UI formatting
- questionary: Interactive prompts
- python-dotenv: Environment management

Wait for installation to complete, then click **Next**.

---

## Step 3: Run Configuration Tool

Launch the interactive configuration tool:

```bash
python setup.py
```

**You will be prompted for:**
1. GCP Project ID (validated)
2. Service name (DNS-compliant format)
3. Deployment region
4. Access control (public or authenticated)

The tool validates all inputs and generates `terraform/terraform.tfvars`.

Follow the prompts, then click **Next**.

---

## Step 4: Review Configuration

Verify the generated configuration:

```bash
cat terraform/terraform.tfvars
```

**Configuration includes:**
- `project_id`: Your GCP project
- `service_name`: Cloud Run service identifier
- `region`: Deployment location
- `allow_unauthenticated`: Access control setting
- `container_image`: Container to deploy

To modify, edit the file or re-run `python setup.py`.

<walkthrough-editor-open-file filePath="terraform/terraform.tfvars">
Open configuration file
</walkthrough-editor-open-file>

Click **Next** when ready to deploy.

---

## Step 5: Initialize Terraform

Initialize Terraform and download the GCP provider:

```bash
cd terraform
terraform init
```

**This process:**
1. Downloads the Google Cloud provider plugin
2. Sets up the Terraform backend (local state)
3. Prepares the working directory

Expected output: "Terraform has been successfully initialized"

Click **Next** to continue.

---

## Step 6: Preview Infrastructure Changes

Review the infrastructure plan before deployment:

```bash
terraform plan
```

**Expected resources:**
- `google_cloud_run_service.nginx`: Cloud Run service
- `google_cloud_run_service_iam_member.public_access`: IAM policy (if public access enabled)

**Plan shows:**
- Resources to be created
- Resource attributes
- Estimated infrastructure changes

Verify the plan output, then click **Next**.

---

## Step 7: Deploy Infrastructure

Deploy the infrastructure:

```bash
terraform apply
```

Type `yes` when prompted to confirm deployment.

**Deployment process:**
1. Creates Cloud Run service
2. Deploys container image
3. Configures networking and IAM
4. Provisions HTTPS endpoint

**Duration:** Approximately 60-90 seconds

Wait for "Apply complete!" message, then click **Next**.

---

## Step 8: Access Deployed Service

Retrieve the service URL:

```bash
terraform output service_url
```

Test the service:

```bash
curl $(terraform output -raw service_url)
```

**Expected response:** HTML content from the nginx container

The service is now accessible via HTTPS with automatic SSL certificate.

Click **Next** to explore additional options.

---

## Step 9: View Service Details (Optional)

View service details in the GCP Console:

<walkthrough-menu-navigation sectionId="CLOUD_RUN_SECTION"></walkthrough-menu-navigation>

Or via command line:

```bash
gcloud run services describe $(terraform output -raw service_name) \
  --region=$(terraform output -raw service_location) \
  --format=yaml
```

**Available information:**
- Service status and configuration
- Revision history
- Traffic routing
- Scaling configuration

Click **Next** when ready to proceed.

---

## Step 10: Monitor Service (Optional)

View service logs:

```bash
gcloud logging read \
  "resource.type=cloud_run_revision AND resource.labels.service_name=$(terraform output -raw service_name)" \
  --limit=50 \
  --format=json
```

Generate test traffic:

```bash
for i in {1..10}; do curl -s $(terraform output -raw service_url) > /dev/null; echo "Request $i completed"; done
```

Metrics are available in the Cloud Console under the service's Metrics tab.

Click **Next** to learn about cleanup.

---

## Step 11: Resource Cleanup

To remove all deployed resources and avoid charges:

**Option 1: Cleanup script**
```bash
cd ..
./cleanup.sh
```

**Option 2: Manual cleanup**
```bash
terraform destroy
```

Type `yes` when prompted.

**Resources removed:**
- Cloud Run service
- IAM policy bindings
- All associated resources

**Duration:** Approximately 10-15 seconds

Click **Next** for summary.

---

## Summary

**Completed tasks:**
- Configured deployment parameters
- Deployed Cloud Run service using Terraform
- Accessed live HTTPS endpoint
- Reviewed service details and logs
- Cleaned up resources (optional)

**Skills practiced:**
- Cloud Run serverless deployment
- Infrastructure as Code with Terraform
- GCP IAM configuration
- Service monitoring and logging

### Next Steps

**Extend this deployment:**
- Deploy custom container images
- Add Cloud SQL database
- Implement Cloud Build CI/CD
- Configure custom domains
- Add Cloud CDN for global distribution

**Resources:**
- [Cloud Run Documentation](https://cloud.google.com/run/docs)
- [Terraform GCP Provider](https://registry.terraform.io/providers/hashicorp/google/latest/docs)
- [Cloud Run Pricing](https://cloud.google.com/run/pricing)

<walkthrough-conclusion-trophy></walkthrough-conclusion-trophy>

Thank you for completing this tutorial.
