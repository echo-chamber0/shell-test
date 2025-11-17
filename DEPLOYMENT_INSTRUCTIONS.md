# 📋 Deployment Instructions

## Quick Reference Guide

### For Repository Owner (You)

#### Step 1: Initialize Git & Push to GitHub

```bash
cd /home/ubuntu/git/work-dir/work/GOGL-CDSI/intro/idea/shell-test

# Run the initialization script
./init-git.sh

# Follow the prompts to set up GitHub remote
# The script will guide you through:
# 1. Creating a GitHub repo
# 2. Pushing your code
# 3. Updating the README with your username
```

#### Step 2: Verify GitHub Repository

After pushing, verify on GitHub:
- ✅ All files are present
- ✅ README displays correctly
- ✅ "Open in Cloud Shell" button is visible

#### Step 3: Update the Open in Cloud Shell URL

In `README.md`, replace `YOUR_USERNAME` with your actual GitHub username:

```markdown
[![Open in Cloud Shell](https://gstatic.com/cloudssh/images/open-btn.svg)](https://shell.cloud.google.com/cloudshell/editor?cloudshell_git_repo=https://github.com/YOUR_ACTUAL_USERNAME/shell-test&cloudshell_tutorial=tutorial.md)
```

---

## For End Users

### Method 1: One-Click Deployment (Recommended)

1. **Click the "Open in Cloud Shell" button** in the README
2. **Wait for Cloud Shell to open** and the repository to clone
3. **Follow the interactive tutorial** that launches automatically
4. **Deploy your service** in under 5 minutes!

### Method 2: Manual Clone

```bash
# Clone the repository
git clone https://github.com/YOUR_USERNAME/shell-test.git
cd shell-test

# Option A: Run interactive setup
./setup.sh

# Option B: Launch tutorial
cloudshell launch-tutorial tutorial.md

# Option C: Manual Terraform
terraform init
cp example.tfvars terraform.tfvars
# Edit terraform.tfvars with your settings
terraform apply
```

---

## Testing the Deployment

### Before Publishing

Test your setup:

```bash
# Validate Terraform
terraform init
terraform validate
terraform fmt -check

# Check scripts
bash -n setup.sh
bash -n init-git.sh

# Verify executables
ls -la *.sh
```

### After Publishing

1. **Click your own "Open in Cloud Shell" button**
2. **Run through the entire tutorial**
3. **Verify all steps work correctly**
4. **Test the setup script**
5. **Deploy and verify the service works**
6. **Clean up resources**: `terraform destroy`

---

## Sharing with Others

### Share the Repository

Send people the GitHub URL:
```
https://github.com/YOUR_USERNAME/shell-test
```

### Share the Direct Deploy Link

Send the "Open in Cloud Shell" URL:
```
https://shell.cloud.google.com/cloudshell/editor?cloudshell_git_repo=https://github.com/YOUR_USERNAME/shell-test&cloudshell_tutorial=tutorial.md
```

### Embed in Documentation

```markdown
Deploy instantly with Google Cloud Shell:

[![Open in Cloud Shell](https://gstatic.com/cloudssh/images/open-btn.svg)](YOUR_CLOUD_SHELL_URL)
```

---

## Customization Before Publishing

### 1. Branding

Edit `setup.sh` to customize the ASCII art banner.

### 2. Default Values

Edit `variables.tf` to change defaults:
- Default region
- Default instance counts
- Default resource sizes

### 3. Container Image

Edit `main.tf` to use a different container:
```hcl
containers {
  image = "your-custom-image:tag"  # Replace nginx:alpine
  # ...
}
```

### 4. Documentation

Update these files with your specific use case:
- `README.md` - Main documentation
- `tutorial.md` - Step-by-step guide
- `QUICKSTART.md` - Quick reference

---

## Troubleshooting Deployment

### Issue: "Open in Cloud Shell" button doesn't work

**Solution:**
- Verify the repository is public
- Check the URL is correctly formatted
- Ensure `tutorial.md` exists in repo root

### Issue: Tutorial doesn't launch automatically

**Solution:**
- Check the `cloudshell_tutorial` parameter in the URL
- Verify `tutorial.md` is in the repository root
- Try manually: `cloudshell launch-tutorial tutorial.md`

### Issue: Permission errors during deployment

**Solution:**
- Ensure you have the necessary GCP permissions
- Required roles:
  - `roles/run.admin`
  - `roles/iam.serviceAccountUser`
  - `roles/serviceusage.serviceUsageAdmin`

### Issue: APIs not enabled

**Solution:**
The Terraform configuration automatically enables required APIs, but you can manually enable them:
```bash
gcloud services enable run.googleapis.com
gcloud services enable artifactregistry.googleapis.com
```

### Issue: Service not accessible

**Solution:**
- Wait 30-60 seconds for service to fully start
- Check logs: `gcloud run services logs read SERVICE_NAME --region=REGION`
- Verify IAM policy for public access

---

## Production Deployment Considerations

### Before Using in Production

1. **Remove Default Values**
   - Don't use `allow_unauthenticated = true` for sensitive services
   - Require explicit configuration of critical settings

2. **Add Backend Configuration**
   ```hcl
   terraform {
     backend "gcs" {
       bucket = "your-terraform-state-bucket"
       prefix = "cloud-run"
     }
   }
   ```

3. **Implement Secrets Management**
   - Use Google Secret Manager
   - Don't store secrets in tfvars

4. **Add Monitoring**
   - Cloud Monitoring dashboards
   - Alerting policies
   - Log-based metrics

5. **Implement CI/CD**
   - Use Cloud Build
   - Automated testing
   - Staged deployments

6. **Cost Controls**
   - Set budget alerts
   - Implement resource quotas
   - Use appropriate instance sizes

### Security Hardening

```hcl
# In variables.tf or terraform.tfvars
allow_unauthenticated = false  # Require authentication

# Add VPC connector for private networking
# Implement IAM conditions
# Use service accounts with minimal permissions
# Enable Cloud Armor for DDoS protection
```

---

## Cost Optimization

### Free Tier Usage

Cloud Run includes:
- 2 million requests per month
- 360,000 GB-seconds of memory
- 180,000 vCPU-seconds

### Cost-Saving Tips

1. **Scale to Zero**
   ```hcl
   min_instances = 0
   ```

2. **Right-Size Resources**
   ```hcl
   cpu    = "1"      # Start small
   memory = "256Mi"  # Increase if needed
   ```

3. **Set Max Instances**
   ```hcl
   max_instances = 10  # Prevent runaway costs
   ```

4. **Clean Up When Done**
   ```bash
   terraform destroy
   ```

---

## Monitoring Deployment

### Check Service Status

```bash
# List services
gcloud run services list

# Describe specific service
gcloud run services describe SERVICE_NAME --region=REGION

# View logs
gcloud run services logs read SERVICE_NAME --region=REGION --limit=50

# Follow logs in real-time
gcloud run services logs tail SERVICE_NAME --region=REGION
```

### Access Service URL

```bash
# Get URL from Terraform
terraform output service_url

# Get URL from gcloud
gcloud run services describe SERVICE_NAME \
  --region=REGION \
  --format='value(status.url)'
```

### Test Service

```bash
# Simple test
curl $(terraform output -raw service_url)

# With headers
curl -H "Authorization: Bearer $(gcloud auth print-identity-token)" \
  $(terraform output -raw service_url)
```

---

## Cleanup

### Option 1: Terraform Destroy

```bash
terraform destroy
```

This will:
- ✅ Delete the Cloud Run service
- ✅ Remove IAM bindings
- ✅ Clean up all managed resources
- ⚠️  Keep API enablements (safe)

### Option 2: Manual Cleanup

```bash
gcloud run services delete SERVICE_NAME --region=REGION
```

### Verify Cleanup

```bash
# Check for remaining resources
gcloud run services list
terraform state list
```

---

## Support & Maintenance

### Getting Help

- 📖 Check the [README.md](README.md)
- 🎓 Review the [tutorial.md](tutorial.md)
- 🚀 See [QUICKSTART.md](QUICKSTART.md)
- 🐛 Report issues on GitHub
- 💬 Ask in GCP community forums

### Keeping Updated

```bash
# Pull latest changes
git pull origin main

# Reinitialize Terraform if needed
terraform init -upgrade
```

### Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines on:
- Reporting bugs
- Suggesting features
- Submitting pull requests

---

## Success Checklist

### For Repository Owner

- [ ] Git repository initialized
- [ ] Pushed to GitHub
- [ ] README updated with GitHub username
- [ ] "Open in Cloud Shell" button tested
- [ ] Tutorial tested end-to-end
- [ ] Setup script tested
- [ ] Manual Terraform tested
- [ ] Documentation reviewed
- [ ] Repository is public (for Cloud Shell access)

### For End Users

- [ ] Clicked "Open in Cloud Shell" button
- [ ] Repository cloned successfully
- [ ] Tutorial launched
- [ ] Completed all tutorial steps
- [ ] Service deployed successfully
- [ ] Service URL accessible
- [ ] Service responds correctly
- [ ] Resources cleaned up (if testing)

---

## Quick Commands Reference

```bash
# Initialize and deploy
terraform init
terraform apply

# View outputs
terraform output
terraform output service_url

# Update deployment
terraform apply

# View resources
terraform state list
terraform show

# Cleanup
terraform destroy

# Validate configuration
terraform validate
terraform fmt -check

# Plan without applying
terraform plan
```

---

**Ready to deploy?** Start with `./init-git.sh` to push to GitHub! 🚀

