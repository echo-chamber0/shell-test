# 🚀 Deploy Cloud Run with Nginx - Interactive GCP Cloud Shell Tutorial

This repository provides an **interactive, beautiful experience** to deploy an nginx web server on Google Cloud Run using Terraform—all from your browser!

## ✨ Quick Start - One Click Deploy

Click the button below to open this repository in Google Cloud Shell and launch the interactive tutorial:

[![Open in Cloud Shell](https://gstatic.com/cloudssh/images/open-btn.svg)](https://shell.cloud.google.com/cloudshell/editor?cloudshell_git_repo=https://github.com/Arturio93/shell-test.git&cloudshell_tutorial=tutorial.md)

> **Note:** After clicking, the tutorial will automatically open in the Cloud Shell interface. Just follow the interactive prompts!

---

## 🎯 What This Does

The tutorial will guide you through:

1. **🎨 Interactive Configuration** - Beautiful Python CLI collects your preferences
2. **☁️ Infrastructure Deployment** - Terraform provisions Cloud Run service
3. **🌐 Live Service** - Get a working nginx endpoint in minutes
4. **🧹 Easy Cleanup** - One command to remove all resources

### What Gets Deployed?

- **Google Cloud Run Service** - Serverless container platform
- **Nginx Container** - Simple "Hello World" web server
- **IAM Permissions** - Optional public access configuration
- **HTTPS Endpoint** - Automatic SSL certificate

**💰 Estimated Cost:** $0.00/month (within free tier for low traffic)

---

## 🛠 What's Inside?

```
.
├── README.md                    # This file
├── tutorial.md                  # Cloud Shell interactive tutorial
├── requirements.txt             # Python dependencies
├── setup.py                     # 🌟 Beautiful interactive CLI
├── deploy.sh                    # Orchestration script
├── cleanup.sh                   # Resource cleanup script
└── terraform/
    ├── main.tf                  # Cloud Run infrastructure
    ├── variables.tf             # Input variables
    ├── outputs.tf               # Service URL output
    └── terraform.tfvars.example # Example configuration
```

---

## 🎨 Interactive CLI Features

Our Python setup script (`setup.py`) provides:

- ✅ **Beautiful Terminal UI** - Rich formatting with colors and panels
- ✅ **Smart Validation** - Real-time input validation for GCP resources
- ✅ **Project Verification** - Checks your GCP project access before deploying
- ✅ **Progress Indicators** - Visual feedback for long operations
- ✅ **Configuration Summary** - Review all settings before deployment
- ✅ **Error Handling** - Clear, actionable error messages

### Example Interaction:

```
🚀 GCP Cloud Run Nginx Deployment Setup
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✅ gcloud authentication verified

Step 1: GCP Project Configuration
? Enter your GCP Project ID: my-project-12345
⠋ Verifying project access...
✅ Project access verified: my-project-12345

Step 2: Cloud Run Service Configuration
? Enter service name: nginx-demo
? Select deployment region: us-central1

Step 3: Access Configuration
? Allow unauthenticated (public) access? Yes

📋 Configuration Summary
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Project ID        my-project-12345
  Service Name      nginx-demo
  Region            us-central1
  Public Access     ✅ Yes

? Proceed with this configuration? Yes

✅ Configuration saved to: terraform/terraform.tfvars

🎉 Setup Complete!
```

---

## 📋 Prerequisites

- **Google Cloud Project** with billing enabled
- **Required IAM Roles:**
  - `roles/run.admin` (Cloud Run Admin)
  - `roles/iam.serviceAccountUser` (Service Account User)

If using Cloud Shell (recommended), authentication is automatic! 🎉

---

## 🚦 Manual Usage (Alternative to Cloud Shell)

If you prefer to run locally:

### 1. Clone the Repository

```bash
git clone https://github.com/Arturio93/shell-test.git
cd shell-test
```

### 2. Install Python Dependencies

```bash
pip install -r requirements.txt
```

### 3. Run Interactive Setup

```bash
python setup.py
```

### 4. Deploy Infrastructure

```bash
cd terraform
terraform init
terraform plan
terraform apply
```

### 5. Access Your Service

```bash
terraform output service_url
```

Visit the URL in your browser to see nginx running! 🎉

---

## 🧹 Cleanup

To avoid any charges, delete all created resources:

### Option 1: Automated Cleanup Script

```bash
./cleanup.sh
```

### Option 2: Manual Cleanup

```bash
cd terraform
terraform destroy
```

Type `yes` when prompted. This removes:
- Cloud Run service
- IAM policy bindings
- All associated resources

---

## 🏗 Architecture

```
┌─────────────┐
│   Internet  │
└──────┬──────┘
       │ HTTPS
       ▼
┌─────────────────────────┐
│  Cloud Run Service      │
│  ┌──────────────────┐  │
│  │  Nginx Container │  │
│  │  Port: 8080      │  │
│  └──────────────────┘  │
│                         │
│  Auto-scaling: 0-10    │
│  Memory: 256Mi         │
│  CPU: 1000m            │
└─────────────────────────┘
```

---

## 🎓 Learning Resources

- [Cloud Run Documentation](https://cloud.google.com/run/docs)
- [Terraform GCP Provider](https://registry.terraform.io/providers/hashicorp/google/latest/docs)
- [Python Rich Library](https://rich.readthedocs.io/)
- [Questionary Documentation](https://questionary.readthedocs.io/)

---

## 🔧 Customization Ideas

Extend this project:

- **Custom Container** - Replace nginx with your own Docker image
- **Environment Variables** - Add secrets and config via Secret Manager
- **Custom Domain** - Map your domain to the Cloud Run service
- **Cloud SQL** - Connect a database
- **Cloud Build CI/CD** - Automate deployments on git push
- **Load Testing** - Test auto-scaling with `hey` or `ab`

---

## 🐛 Troubleshooting

### Error: "Permission denied"

**Solution:** Ensure your GCP account has `roles/run.admin` permissions:

```bash
gcloud projects add-iam-policy-binding PROJECT_ID \
  --member="user:YOUR_EMAIL@example.com" \
  --role="roles/run.admin"
```

### Error: "Project not found"

**Solution:** Verify project ID and ensure billing is enabled:

```bash
gcloud projects describe PROJECT_ID
gcloud beta billing projects describe PROJECT_ID
```

### Error: "API not enabled"

**Solution:** Enable required APIs:

```bash
gcloud services enable run.googleapis.com
gcloud services enable artifactregistry.googleapis.com
```

---

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

---

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

---

## ⭐ Show Your Support

If this project helped you, please give it a ⭐️!

---

**Made with ❤️ for Google Cloud Platform**

*Enjoy your Cloud Run journey!* 🚀

