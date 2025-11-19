# Data Commons Cloud Run Deployment Tutorial

## Welcome

This tutorial guides you through an automated deployment of a containerized service on Google Cloud Run using Terraform.

**Time to complete:** 5-10 minutes  
**Cost:** Free tier eligible (no charges for low traffic)

<walkthrough-tutorial-duration duration="10"></walkthrough-tutorial-duration>

Click **Start** to begin the automated deployment process.

---

## Overview: Automated Deployment

This deployment tool handles everything automatically:

**What happens automatically:**
- Dependency installation
- GCP authentication verification
- Configuration collection and validation
- Terraform initialization
- Infrastructure planning
- Resource deployment
- Service URL retrieval

**Your role:**
- Answer 4 configuration questions
- Confirm deployment
- Access your deployed service

**Technology stack:**
- **Google Cloud Run**: Serverless container platform
- **Terraform**: Infrastructure as Code
- **Python**: Interactive deployment tool

Click **Next** to start.

---

## Step 1: Understanding Cloud Run

Google Cloud Run is a fully managed serverless platform for deploying containerized applications.

**Key Features:**
- **Automatic scaling**: From zero to thousands of instances based on traffic
- **Pay-per-use**: Billed per 100ms of request time, no charges when idle
- **Built-in HTTPS**: Automatic SSL certificates and endpoints
- **Global deployment**: Available in multiple regions worldwide

**What you'll deploy:**
- A containerized service on Cloud Run
- Public HTTPS endpoint (or authenticated-only, your choice)
- Managed by Terraform for easy updates and cleanup

Click **Next** to verify your environment.

---

## Step 2: Verify Environment

Your Cloud Shell environment includes:
- gcloud CLI (pre-authenticated)
- Terraform CLI
- Python 3.9+
- All necessary tools pre-installed

Verify your environment (optional):

```bash
gcloud config get-value project
terraform version
python --version
```

**Note:** If the deployment tool opened automatically in your terminal, you can switch between the terminal and this tutorial panel.

Click **Next** to run the deployment tool.

---

## Step 3: Run Automated Deployment Tool

If the deployment tool hasn't started automatically, run:

```bash
python setup.py
```

**The tool will guide you through 4 configuration questions:**

1. **GCP Project ID**: Your Google Cloud project (may be auto-detected)
2. **Service Name**: Name for your Cloud Run service (e.g., "datacommons-service")
3. **Deployment Region**: Geographic location (e.g., us-central1)
4. **Access Control**: Public access or authenticated-only

**After configuration:**
- Review the summary
- Confirm deployment
- Tool automatically handles:
  - Terraform initialization
  - Infrastructure planning
  - Resource deployment (60-90 seconds)
  - Service URL retrieval

**Important:** Answer all prompts in the terminal. The tool validates inputs automatically.

Click **Next** after deployment completes.

---

## Step 4: Deployment Process Explained

While deployment runs, here's what happens behind the scenes:

**Stage 1: Configuration**
- Validates GCP project access
- Generates Terraform configuration file
- Creates `terraform/terraform.tfvars`

**Stage 2: Terraform Initialization**
- Downloads Google Cloud provider plugin
- Sets up local Terraform state
- Prepares deployment environment

**Stage 3: Infrastructure Planning**
- Plans resource creation
- Validates configuration
- Estimates changes

**Stage 4: Deployment** (60-90 seconds)
- Enables required GCP APIs (Cloud Run, IAM, Artifact Registry)
- Creates Cloud Run service
- Deploys container image
- Configures networking and IAM
- Provisions HTTPS endpoint

**Stage 5: Service Information**
- Retrieves service URL
- Displays deployment summary
- Provides quick commands

Click **Next** once deployment completes.

---

## Step 5: Access Your Deployed Service

After successful deployment, the tool displays your service URL.

**Test your service:**

```bash
# Get service URL
cd terraform
terraform output service_url

# Test the endpoint
curl $(terraform output -raw service_url)
```

**Expected response:** HTML content from the deployed container

**Access via browser:**
- Click the URL in the deployment summary
- Or visit the Cloud Run console:

<walkthrough-menu-navigation sectionId="CLOUD_RUN_SECTION"></walkthrough-menu-navigation>

Your service is now live with automatic HTTPS and SSL certificates.

Click **Next** to explore monitoring options.

---

## Step 6: View Configuration (Optional)

Review the generated Terraform configuration:

```bash
cat terraform/terraform.tfvars
```

**Configuration file contains:**
- `project_id`: Your GCP project
- `service_name`: Cloud Run service identifier
- `region`: Deployment location
- `allow_unauthenticated`: Access control setting
- `container_image`: Container to deploy

<walkthrough-editor-open-file filePath="terraform/terraform.tfvars">
Open configuration file
</walkthrough-editor-open-file>

**To modify configuration:**
1. Re-run `python setup.py` from the project root
2. Or manually edit `terraform/terraform.tfvars` and run:
   ```bash
   cd terraform && terraform apply
   ```

Click **Next** to learn about monitoring.

---

## Step 7: Monitor Your Service (Optional)

**View service details:**

```bash
cd terraform
gcloud run services describe $(terraform output -raw service_name) \
  --region=$(terraform output -raw service_location) \
  --format=yaml
```

**View service logs:**

```bash
gcloud logging read \
  "resource.type=cloud_run_revision AND resource.labels.service_name=$(terraform output -raw service_name)" \
  --limit=20 \
  --format=json
```

**Generate test traffic:**

```bash
# Send 10 test requests
for i in {1..10}; do 
  curl -s $(terraform output -raw service_url) > /dev/null
  echo "Request $i completed"
done
```

**View metrics in Console:**

<walkthrough-menu-navigation sectionId="CLOUD_RUN_SECTION"></walkthrough-menu-navigation>

Select your service and click the **Metrics** tab to see:
- Request count
- Request latency
- Container instance count
- Memory and CPU utilization

Click **Next** to learn about cleanup.

---

## Step 8: Update Your Service (Optional)

To update your deployment with different settings:

**Method 1: Re-run setup tool**
```bash
cd ..  # Return to project root
python setup.py
```

The tool will detect existing configuration and prompt for updates.

**Method 2: Manual Terraform update**
```bash
cd terraform
# Edit terraform.tfvars
terraform apply
```

Type `yes` to confirm changes.

**Common updates:**
- Change region
- Modify access control (public/private)
- Update container image
- Adjust resource limits

Click **Next** to learn about cleanup.

---

## Step 9: Resource Cleanup

To remove all deployed resources and avoid charges:

**Method 1: Automated cleanup script**
```bash
cd ..  # Return to project root if in terraform/
./cleanup.sh
```

**Method 2: Manual Terraform cleanup**
```bash
cd terraform
terraform destroy
```

Type `yes` when prompted.

**Resources removed:**
- Cloud Run service and all revisions
- IAM policy bindings
- Service configurations
- All associated resources

**Duration:** 10-15 seconds

**Note:** This does NOT delete:
- Your GCP project
- Terraform state files (local only)
- Cloud Shell environment

**Cost after cleanup:** $0.00 (all resources deleted)

Click **Next** for summary and next steps.

---

## Summary

**What you accomplished:**
- Deployed a containerized service to Google Cloud Run
- Used Infrastructure as Code (Terraform) for repeatable deployments
- Configured automated scaling and HTTPS endpoints
- Learned monitoring and logging for Cloud Run services
- Managed resource lifecycle (create, update, destroy)

**Time saved with automation:**
- Manual deployment: 20-30 minutes
- Automated deployment: 5-10 minutes
- Commands required: 1 instead of 10+

**Skills practiced:**
- Cloud Run serverless deployment
- Terraform Infrastructure as Code
- GCP IAM and access control
- Service monitoring and logging
- Interactive CLI tool usage

### Next Steps

**Customize this deployment:**
- Deploy your own container image (update `container_image` in variables)
- Add environment variables and secrets
- Connect Cloud SQL database
- Configure custom domains with Cloud DNS
- Implement Cloud Build for CI/CD
- Add Cloud CDN for global distribution
- Set up Cloud Armor for DDoS protection

**Extend the infrastructure:**
- Add multiple services (microservices)
- Implement Cloud Load Balancing
- Add Cloud Monitoring alerts
- Create staging and production environments
- Implement blue-green deployments

**Learn more:**
- [Cloud Run Documentation](https://cloud.google.com/run/docs)
- [Terraform GCP Provider](https://registry.terraform.io/providers/hashicorp/google/latest/docs)
- [Cloud Run Pricing Calculator](https://cloud.google.com/run/pricing)
- [Cloud Run Best Practices](https://cloud.google.com/run/docs/best-practices)

**Share this tool:**
- Fork the repository on GitHub
- Customize for your team's use cases
- Add to your organization's deployment toolkit

<walkthrough-conclusion-trophy></walkthrough-conclusion-trophy>

Thank you for completing this automated deployment tutorial.

**Repository:** [github.com/echo-chamber0/shell-test](https://github.com/echo-chamber0/shell-test)
