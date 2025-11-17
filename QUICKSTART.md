# Quick Start Guide

## 🚀 Three Ways to Deploy

### 1. Interactive Tutorial (Recommended for Beginners)

Launch the step-by-step tutorial in Cloud Shell:

```bash
cloudshell launch-tutorial tutorial.md
```

This provides:
- ✅ Guided walkthrough
- ✅ Embedded commands
- ✅ Visual progress tracking
- ✅ Best for learning

### 2. Interactive Script (Fastest)

Run the automated setup script:

```bash
./setup.sh
```

This provides:
- ✅ Beautiful terminal UI
- ✅ Input validation
- ✅ Configuration summary
- ✅ One-command deployment
- ✅ Best for quick deployments

### 3. Manual Terraform (For Experts)

Direct Terraform commands:

```bash
# 1. Initialize
terraform init

# 2. Configure
cat > terraform.tfvars <<EOF
project_id              = "your-gcp-project"
region                  = "us-central1"
service_name            = "nginx-demo"
allow_unauthenticated   = true
EOF

# 3. Deploy
terraform plan
terraform apply
```

This provides:
- ✅ Full control
- ✅ No interactive prompts
- ✅ Best for automation

## 📋 Prerequisites

- Google Cloud Project
- Required APIs (enabled automatically):
  - Cloud Run API
  - Artifact Registry API
- Sufficient permissions:
  - `roles/run.admin`
  - `roles/iam.serviceAccountUser`

## 🎯 What You'll Get

After deployment:
- ✅ Cloud Run service running nginx
- ✅ Public URL (if enabled)
- ✅ Auto-scaling configuration
- ✅ Resource limits (CPU/Memory)

## ⏱️ Estimated Time

- Interactive Tutorial: ~5 minutes
- Interactive Script: ~3 minutes
- Manual Terraform: ~2 minutes

## 🆘 Need Help?

Check these resources:
- Full documentation: `cat README.md`
- Tutorial: `cloudshell launch-tutorial tutorial.md`
- Terraform docs: `terraform -help`

## 📞 Troubleshooting

**Issue: Permission denied on setup.sh**
```bash
chmod +x setup.sh
```

**Issue: APIs not enabled**
```bash
gcloud services enable run.googleapis.com artifactregistry.googleapis.com
```

**Issue: Wrong project selected**
```bash
gcloud config set project YOUR_PROJECT_ID
```

## 🧹 Cleanup

When finished:
```bash
terraform destroy
```

Or interactively:
```bash
./setup.sh  # Will offer cleanup option
```

---

**Ready?** Choose your preferred method above and start deploying! 🚀

