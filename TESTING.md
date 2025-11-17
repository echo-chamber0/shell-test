# Testing Guide

This guide helps you test the repository before publishing to ensure everything works correctly.

## Pre-Flight Checklist

Before testing, ensure:
- [ ] All files are present (see File Checklist below)
- [ ] Scripts are executable (`chmod +x setup.py deploy.sh cleanup.sh`)
- [ ] README.md has correct GitHub URL
- [ ] `.gitignore` is configured
- [ ] No sensitive data in repository

## File Checklist

```
✅ README.md
✅ tutorial.md
✅ QUICKSTART.md
✅ CONTRIBUTING.md
✅ LICENSE
✅ requirements.txt
✅ setup.py (executable)
✅ deploy.sh (executable)
✅ cleanup.sh (executable)
✅ .gitignore
✅ .gcloudignore
✅ terraform/
   ✅ main.tf
   ✅ variables.tf
   ✅ outputs.tf
   ✅ terraform.tfvars.example
```

---

## Test Phase 1: Local Python Script

### 1.1 Test Setup Script Installation

```bash
# Should auto-install dependencies
python setup.py
```

**Expected:**
- Installs `rich`, `questionary`, `python-dotenv`
- Exits with success message
- Prompts to run again

### 1.2 Test Interactive Prompts

```bash
python setup.py
```

**Test Cases:**

| Test | Input | Expected Result |
|------|-------|----------------|
| **Valid Project ID** | `test-project-123` | ✅ Accepts |
| **Invalid Project ID** | `TEST-123` | ❌ Rejects (uppercase) |
| **Invalid Project ID** | `test_project` | ❌ Rejects (underscore) |
| **Invalid Project ID** | `test-` | ❌ Rejects (trailing hyphen) |
| **Valid Service Name** | `nginx-demo` | ✅ Accepts |
| **Invalid Service Name** | `-nginx` | ❌ Rejects (leading hyphen) |
| **Cancel Operation** | Ctrl+C | ✅ Graceful exit |

### 1.3 Test Configuration Generation

After successful setup:

```bash
# Check generated file exists
ls -la terraform/terraform.tfvars

# Verify contents
cat terraform/terraform.tfvars
```

**Expected:**
- File exists at `terraform/terraform.tfvars`
- Contains correct values
- Proper Terraform syntax
- Boolean values lowercase (`true`/`false`)

---

## Test Phase 2: Terraform Validation

### 2.1 Initialize Terraform

```bash
cd terraform
terraform init
```

**Expected:**
- Downloads Google provider (version ~> 5.0)
- Creates `.terraform/` directory
- Creates `.terraform.lock.hcl` file
- Success message displayed

### 2.2 Validate Configuration

```bash
terraform validate
```

**Expected:**
- "Success! The configuration is valid."
- No errors or warnings

### 2.3 Format Check

```bash
terraform fmt -check
```

**Expected:**
- No output (all files formatted)
- Exit code 0

### 2.4 Plan (Dry Run)

```bash
# Create example tfvars first
cp terraform.tfvars.example terraform.tfvars
# Edit with real project ID

terraform plan
```

**Expected:**
- Shows 2 resources to add:
  - `google_cloud_run_service.nginx`
  - `google_cloud_run_service_iam_member.public_access` (if public)
- No errors
- Plan completes successfully

---

## Test Phase 3: Cloud Shell Testing

### 3.1 Push to GitHub

```bash
# Create GitHub repo first, then:
git remote add origin https://github.com/Arturio93/shell-test.git
git add .
git commit -m "Initial commit"
git push -u origin main
```

### 3.2 Update README Link

Edit `README.md` and replace:
```markdown
[![Open in Cloud Shell](https://gstatic.com/cloudssh/images/open-btn.svg)](https://shell.cloud.google.com/cloudshell/editor?cloudshell_git_repo=https://github.com/Arturio93/shell-test.git&cloudshell_tutorial=tutorial.md)
```

With your actual GitHub URL.

### 3.3 Test Cloud Shell Opening

1. Navigate to your GitHub repository
2. Click "Open in Cloud Shell" button
3. Wait for Cloud Shell to initialize

**Expected:**
- Cloud Shell opens in new tab
- Repository automatically clones
- Tutorial panel opens on the right
- Welcome step is visible

### 3.4 Follow Tutorial End-to-End

Go through each tutorial step:

**Step 1: Install Dependencies**
```bash
pip install -r requirements.txt
```
- [ ] Installs successfully
- [ ] No errors

**Step 2: Run Setup**
```bash
python setup.py
```
- [ ] Interactive prompts appear
- [ ] Beautiful UI with colors
- [ ] Validation works
- [ ] Project verification works
- [ ] Config file generated

**Step 3: Review Config**
```bash
cat terraform/terraform.tfvars
```
- [ ] File exists
- [ ] Values correct

**Step 4: Init Terraform**
```bash
cd terraform
terraform init
```
- [ ] Initializes successfully

**Step 5: Plan**
```bash
terraform plan
```
- [ ] Shows resources to create
- [ ] No errors

**Step 6: Apply** (Optional - costs money!)
```bash
terraform apply
```
- [ ] Creates resources
- [ ] Shows service URL
- [ ] No errors

**Step 7: Test Service** (if deployed)
```bash
curl $(terraform output -raw service_url)
```
- [ ] Returns 200 OK
- [ ] Shows HTML response

**Step 8: Cleanup** (if deployed)
```bash
cd ..
./cleanup.sh
```
- [ ] Confirms before destroying
- [ ] Destroys all resources
- [ ] Success message shown

---

## Test Phase 4: Shell Scripts

### 4.1 Test Deploy Script

```bash
./deploy.sh
```

**Expected:**
- Checks for config
- Runs setup if needed
- Initializes Terraform
- Shows plan
- Asks for confirmation
- Applies infrastructure (if confirmed)
- Shows output with service URL

### 4.2 Test Cleanup Script

```bash
./cleanup.sh
```

**Expected:**
- Shows current resources
- Warns about deletion
- Asks for confirmation
- Destroys resources (if confirmed)
- Success message

---

## Test Phase 5: Edge Cases

### 5.1 Run Setup Twice

```bash
python setup.py
python setup.py
```

**Expected:**
- Overwrites previous config
- No errors

### 5.2 Cancel During Setup

```bash
python setup.py
# Press Ctrl+C during prompts
```

**Expected:**
- Graceful exit
- "Setup cancelled" message
- No partial config file

### 5.3 Missing Config

```bash
rm terraform/terraform.tfvars
./deploy.sh
```

**Expected:**
- Detects missing config
- Runs setup automatically
- Continues with deployment

### 5.4 Invalid Project ID

```bash
# Edit terraform/terraform.tfvars
# Set project_id to invalid value
terraform plan
```

**Expected:**
- Terraform validates and rejects
- Clear error message

---

## Test Phase 6: Documentation

### 6.1 README Rendering

View `README.md` on GitHub:
- [ ] Markdown renders correctly
- [ ] "Open in Cloud Shell" button appears
- [ ] Code blocks are formatted
- [ ] Links work
- [ ] Images/icons display (if any)

### 6.2 Tutorial Rendering

In Cloud Shell:
- [ ] Tutorial opens automatically
- [ ] Navigation (Next/Previous) works
- [ ] Code blocks have copy buttons
- [ ] Special tags render correctly
- [ ] Links are clickable

### 6.3 All Documentation Links

Check that all links work:
- [ ] README links to external docs
- [ ] Tutorial links
- [ ] CONTRIBUTING links
- [ ] LICENSE readable

---

## Common Issues & Solutions

### Issue: "gcloud: command not found"

**Solution:** Not in Cloud Shell. Use Cloud Shell or install gcloud CLI.

### Issue: "Permission denied" when running scripts

**Solution:**
```bash
chmod +x setup.py deploy.sh cleanup.sh
```

### Issue: "ModuleNotFoundError: No module named 'rich'"

**Solution:**
```bash
pip install -r requirements.txt
```

### Issue: "Project not found" during setup

**Solution:**
- Verify project ID is correct
- Check billing is enabled
- Ensure gcloud is authenticated
- Run `gcloud projects list`

### Issue: Terraform provider download fails

**Solution:**
```bash
terraform init -upgrade
```

### Issue: Tutorial doesn't open in Cloud Shell

**Solution:**
- Check `cloudshell_tutorial` parameter in URL
- Verify `tutorial.md` exists in repo
- Check file name is exact match (case-sensitive)

---

## Performance Testing

### Script Execution Time

| Task | Expected Duration |
|------|------------------|
| `pip install -r requirements.txt` | 10-20 seconds |
| `python setup.py` | 30-60 seconds (user input) |
| `terraform init` | 10-15 seconds |
| `terraform plan` | 5-10 seconds |
| `terraform apply` | 60-90 seconds |
| `terraform destroy` | 10-15 seconds |

### Cloud Shell Load Time

| Task | Expected Duration |
|------|------------------|
| Open Cloud Shell | 15-30 seconds |
| Clone repository | 2-5 seconds |
| Open tutorial | Instant |

---

## Automated Testing (Future)

Consider adding:

```bash
#!/bin/bash
# tests/test_all.sh

echo "Running validation tests..."

# Test 1: Python syntax
python -m py_compile setup.py
echo "✅ Python syntax valid"

# Test 2: Terraform validation
cd terraform
terraform init -backend=false
terraform validate
terraform fmt -check
echo "✅ Terraform valid"

# Test 3: Shell script syntax
bash -n ../deploy.sh
bash -n ../cleanup.sh
echo "✅ Shell scripts valid"

echo "All tests passed!"
```

---

## Final Checklist Before Publishing

- [ ] All tests passing
- [ ] Documentation complete
- [ ] GitHub URL updated in README
- [ ] No sensitive data committed
- [ ] `.gitignore` configured
- [ ] Scripts executable
- [ ] Tutorial tested in Cloud Shell
- [ ] End-to-end deployment tested
- [ ] Cleanup script tested
- [ ] README renders correctly on GitHub
- [ ] License included
- [ ] Contributing guide present

---

## Reporting Issues

Found a bug during testing?

1. Note the exact steps to reproduce
2. Capture error messages
3. Check if issue already reported
4. Open new issue with details

---

**Happy Testing!** 🧪

