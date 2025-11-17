# Getting Started - Repository Setup Guide

This guide will help you publish this repository to GitHub and make it available via the "Open in Cloud Shell" button.

---

## 📋 Prerequisites

Before starting, ensure you have:

- [ ] GitHub account
- [ ] Git installed locally (or use GitHub web interface)
- [ ] GCP account with billing enabled (for testing)
- [ ] Basic familiarity with git commands

---

## 🚀 Quick Setup (5 Minutes)

### Step 1: Create GitHub Repository

**Option A: GitHub Web Interface**

1. Go to [GitHub](https://github.com) and sign in
2. Click the **+** icon → **New repository**
3. Fill in details:
   - **Repository name:** `gcp-cloudrun-interactive` (or your choice)
   - **Description:** "Interactive Cloud Run deployment with Terraform and Python CLI"
   - **Visibility:** Public (required for Cloud Shell button)
   - **Initialize:** Do NOT initialize with README (we have files already)
4. Click **Create repository**

**Option B: GitHub CLI**

```bash
# Install GitHub CLI first: https://cli.github.com/
gh repo create gcp-cloudrun-interactive --public --description "Interactive Cloud Run deployment"
```

### Step 2: Update README with Your GitHub URL

Edit `README.md` and replace these placeholders:

```markdown
# Find this line:
[![Open in Cloud Shell](https://gstatic.com/cloudssh/images/open-btn.svg)](https://shell.cloud.google.com/cloudshell/editor?cloudshell_git_repo=https://github.com/YOUR_USERNAME/YOUR_REPO.git&cloudshell_tutorial=tutorial.md)

# Replace with:
[![Open in Cloud Shell](https://gstatic.com/cloudssh/images/open-btn.svg)](https://shell.cloud.google.com/cloudshell/editor?cloudshell_git_repo=https://github.com/YOUR_USERNAME/gcp-cloudrun-interactive.git&cloudshell_tutorial=tutorial.md)
```

Replace:
- `YOUR_USERNAME` with your GitHub username
- `YOUR_REPO` (or use the name you chose in Step 1)

### Step 3: Push to GitHub

From the repository directory:

```bash
# Initialize git (if not already done)
git init

# Add all files
git add .

# Commit
git commit -m "Initial commit: Interactive Cloud Run deployment tutorial"

# Add remote (replace with your repository URL)
git remote add origin https://github.com/YOUR_USERNAME/gcp-cloudrun-interactive.git

# Push to GitHub
git branch -M main
git push -u origin main
```

**Alternative: Using SSH**

```bash
git remote add origin git@github.com:YOUR_USERNAME/gcp-cloudrun-interactive.git
git push -u origin main
```

### Step 4: Verify on GitHub

1. Navigate to your repository on GitHub
2. Check that all files are present:
   - ✅ README.md
   - ✅ tutorial.md
   - ✅ setup.py
   - ✅ terraform/ directory
   - ✅ All other files

3. Verify README renders correctly:
   - "Open in Cloud Shell" button should be visible
   - Markdown formatting should look good
   - Code blocks should be formatted

### Step 5: Test the Cloud Shell Button

1. On your GitHub repository page, find the "Open in Cloud Shell" button in README
2. Click it
3. Wait for Cloud Shell to open (15-30 seconds)
4. Verify:
   - Repository clones successfully
   - Tutorial opens in right panel
   - All files are present

---

## 🧪 Testing Your Deployment

### Test Phase 1: Cloud Shell Environment

In Cloud Shell, test the interactive setup:

```bash
# Install dependencies
pip install -r requirements.txt

# Run setup
python setup.py

# Follow prompts and enter:
# - Your GCP project ID
# - Service name (e.g., nginx-demo)
# - Region (e.g., us-central1)
# - Allow public access: Yes
```

### Test Phase 2: Terraform Validation

```bash
cd terraform
terraform init
terraform validate
terraform fmt -check
```

**Expected:** All commands succeed with no errors.

### Test Phase 3: Full Deployment (Optional)

⚠️ **Warning:** This will deploy actual GCP resources (minimal cost, free tier eligible).

```bash
terraform plan
terraform apply
# Type 'yes' to confirm

# Test service
curl $(terraform output -raw service_url)

# Cleanup
terraform destroy
# Type 'yes' to confirm
```

---

## 📝 Customization Options

### Change Project Name/Description

Edit these files:
- `README.md` - Update title and description
- `tutorial.md` - Update welcome message
- `setup.py` - Update banner text

### Add Custom Container Image

Edit `terraform/variables.tf`:

```hcl
variable "container_image" {
  description = "Container image to deploy"
  type        = string
  default     = "your-registry/your-image:tag"
}
```

### Change Resource Limits

Edit `terraform/variables.tf`:

```hcl
variable "cpu_limit" {
  default = "2000m"  # 2 vCPU
}

variable "memory_limit" {
  default = "512Mi"  # 512 MiB
}
```

### Add More Regions

Edit `setup.py`, find `get_available_regions()` function:

```python
def get_available_regions():
    return [
        "us-central1 (Iowa)",
        "us-east1 (South Carolina)",
        # Add more regions here
        "southamerica-east1 (São Paulo)",
    ]
```

Also update `terraform/variables.tf` validation:

```hcl
validation {
  condition = contains([
    "us-central1", "us-east1",
    # Add matching region codes
    "southamerica-east1",
  ], var.region)
}
```

---

## 🎨 Branding & Styling

### Add Your Logo

1. Create `assets/` directory
2. Add logo image (PNG, 200x200px recommended)
3. Update README.md:

```markdown
<p align="center">
  <img src="assets/logo.png" alt="Project Logo" width="200"/>
</p>

# Your Project Name
```

### Change Color Scheme

Edit `setup.py`, modify the console output colors:

```python
# Current colors
console.print("[bold cyan]🚀 GCP Cloud Run Setup[/bold cyan]")
console.print("✅ [green]Success[/green]")
console.print("❌ [red]Error[/red]")
console.print("[yellow]Warning[/yellow]")

# Change to your brand colors
console.print("[bold blue]🚀 Your Brand[/bold blue]")
console.print("✅ [bright_green]Success[/bright_green]")
# etc.
```

---

## 🔒 Security Checklist

Before making repository public:

- [ ] No hardcoded secrets or API keys
- [ ] No sensitive data in commit history
- [ ] `.gitignore` configured properly
- [ ] `terraform/terraform.tfvars` is gitignored
- [ ] No personal project IDs in example files
- [ ] LICENSE file included
- [ ] CONTRIBUTING guidelines clear

### Scan for Secrets

```bash
# Install gitleaks: https://github.com/zricethezav/gitleaks
gitleaks detect --source . --verbose
```

---

## 📊 Repository Statistics

After following this guide, your repository will have:

- **16 files** across 2 directories
- **~3000 lines** of code and documentation
- **5 main components:**
  1. Interactive Python CLI (250 lines)
  2. Terraform infrastructure (150 lines)
  3. Shell orchestration (100 lines)
  4. Comprehensive documentation (2500 lines)
  5. CI/CD validation (50 lines)

---

## 🎯 Next Steps

After publishing:

1. **Share it!**
   - Tweet about it
   - Post on LinkedIn
   - Share in GCP communities
   - Add to awesome-gcp lists

2. **Monitor usage:**
   - Star count on GitHub
   - Clone statistics
   - Issue reports
   - Community feedback

3. **Improve based on feedback:**
   - Fix reported bugs
   - Add requested features
   - Update documentation
   - Respond to issues

4. **Extend functionality:**
   - Add more GCP services
   - Create additional templates
   - Build companion tutorials
   - Integrate monitoring

---

## 🐛 Troubleshooting

### Issue: "Failed to push to GitHub"

**Solutions:**

```bash
# If authentication fails
gh auth login

# If using SSH and it fails
ssh-keygen -t ed25519 -C "your_email@example.com"
# Add SSH key to GitHub: Settings → SSH keys

# If branch doesn't exist
git branch -M main
```

### Issue: "Cloud Shell button not working"

**Check:**
- Repository is public (not private)
- URL is correct (no typos)
- Markdown syntax is correct
- `tutorial.md` exists in repository

### Issue: "Tutorial doesn't open"

**Solutions:**
- Verify `cloudshell_tutorial=tutorial.md` in URL
- Check file name is exact (case-sensitive)
- Ensure file is in repository root

---

## 📚 Additional Resources

- [GitHub Docs: Creating a Repository](https://docs.github.com/en/get-started/quickstart/create-a-repo)
- [Cloud Shell Tutorial Format](https://cloud.google.com/shell/docs/cloud-shell-tutorials/tutorials)
- [Markdown Guide](https://www.markdownguide.org/)
- [Terraform GCP Provider](https://registry.terraform.io/providers/hashicorp/google/latest/docs)

---

## ✅ Completion Checklist

Mark these off as you complete each step:

- [ ] GitHub repository created
- [ ] README.md updated with correct URL
- [ ] Files committed to git
- [ ] Pushed to GitHub
- [ ] Verified on GitHub (files present)
- [ ] Tested "Open in Cloud Shell" button
- [ ] Ran interactive setup in Cloud Shell
- [ ] Terraform validation passed
- [ ] (Optional) Full deployment tested
- [ ] (Optional) Cleanup tested
- [ ] Repository shared publicly
- [ ] Documentation reviewed

---

## 🎉 Congratulations!

You've successfully published your interactive Cloud Run deployment tutorial!

**What you've built:**
- ✅ Beautiful interactive CLI
- ✅ Production-ready Terraform code
- ✅ Comprehensive documentation
- ✅ One-click Cloud Shell deployment
- ✅ Educational tutorial experience

**Share it with the world!** 🌍

---

**Questions or Issues?**

- Check [TESTING.md](TESTING.md) for detailed testing guide
- See [QUICKSTART.md](QUICKSTART.md) for quick reference
- Review [PROJECT_OVERVIEW.md](PROJECT_OVERVIEW.md) for technical details
- Open an issue on GitHub for help

---

**Happy Cloud Computing!** ☁️🚀

