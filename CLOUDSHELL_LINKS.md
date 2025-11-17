# 🔗 Cloud Shell Link Options

This document explains all the ways to create "Open in Cloud Shell" links for auto-execution.

## 📋 Available Approaches

### Option 1: Prompt User (Current Default) ⭐ Recommended

**What happens:**
- User clicks link
- Cloud Shell opens and clones repo
- Welcome message appears with options
- User presses ENTER → `setup.sh` runs automatically
- User types "tutorial" → Tutorial launches
- User types "skip" → Manual mode

**Link:**
```
https://shell.cloud.google.com/cloudshell/editor?cloudshell_git_repo=https://github.com/Arturio93/shell-test&cloudshell_tutorial=tutorial.md
```

**Configuration:** Uses current `cloudshell.yaml`

---

### Option 2: Fully Automatic (No Prompt)

**What happens:**
- User clicks link
- Cloud Shell opens and clones repo
- Waits 3 seconds (can press Ctrl+C to cancel)
- `setup.sh` runs automatically

**How to enable:**
```bash
# In your repository
mv cloudshell.yaml cloudshell-prompt.yaml.backup
mv cloudshell-autorun.yaml cloudshell.yaml
git add cloudshell.yaml
git commit -m "Switch to auto-run mode"
git push
```

**Link:** (same URL, behavior changes based on cloudshell.yaml)
```
https://shell.cloud.google.com/cloudshell/editor?cloudshell_git_repo=https://github.com/Arturio93/shell-test
```

---

### Option 3: Tutorial Auto-Launch

**What happens:**
- User clicks link
- Cloud Shell opens and clones repo
- Tutorial opens in side panel automatically
- User follows tutorial steps manually

**Link:**
```
https://shell.cloud.google.com/cloudshell/editor?cloudshell_git_repo=https://github.com/Arturio93/shell-test&cloudshell_tutorial=tutorial.md
```

**Configuration:** No changes needed, use `cloudshell_tutorial` parameter

---

### Option 4: Custom Launch Command

**What happens:**
- User clicks link
- Cloud Shell opens and clones repo
- Prints a custom message file
- User manually runs commands

**Link with custom message:**
```
https://shell.cloud.google.com/cloudshell/editor?cloudshell_git_repo=https://github.com/Arturio93/shell-test&cloudshell_print=QUICKSTART.md
```

**Link that opens specific file in editor:**
```
https://shell.cloud.google.com/cloudshell/editor?cloudshell_git_repo=https://github.com/Arturio93/shell-test&cloudshell_open_in_editor=setup.sh
```

---

## 🎯 URL Parameters Reference

### All Available Parameters

| Parameter | Description | Example |
|-----------|-------------|---------|
| `cloudshell_git_repo` | Git repository to clone (required) | `https://github.com/Arturio93/shell-test` |
| `cloudshell_tutorial` | Tutorial file to launch | `tutorial.md` |
| `cloudshell_open_in_editor` | File to open in editor | `setup.sh` or `README.md` |
| `cloudshell_print` | File to print to terminal | `QUICKSTART.md` |
| `cloudshell_working_dir` | Working directory after clone | `.` or `subdirectory` |

### Combining Parameters

You can combine multiple parameters:

```
https://shell.cloud.google.com/cloudshell/editor?cloudshell_git_repo=https://github.com/Arturio93/shell-test&cloudshell_tutorial=tutorial.md&cloudshell_open_in_editor=setup.sh
```

This will:
1. Clone the repo
2. Open tutorial in side panel
3. Open setup.sh in the editor

---

## 🚀 Recommended Link Variations

### For Beginners (Learning)
```
https://shell.cloud.google.com/cloudshell/editor?cloudshell_git_repo=https://github.com/Arturio93/shell-test&cloudshell_tutorial=tutorial.md
```
**Why:** Tutorial provides step-by-step guidance

### For Quick Deployment (Experienced Users)
```
https://shell.cloud.google.com/cloudshell/editor?cloudshell_git_repo=https://github.com/Arturio93/shell-test
```
**Why:** Prompts immediately to run setup.sh (with current cloudshell.yaml)

### For Workshops/Demos
```
https://shell.cloud.google.com/cloudshell/editor?cloudshell_git_repo=https://github.com/Arturio93/shell-test&cloudshell_tutorial=tutorial.md&cloudshell_open_in_editor=main.tf
```
**Why:** Tutorial + shows the Terraform code

### For Documentation/Exploration
```
https://shell.cloud.google.com/cloudshell/editor?cloudshell_git_repo=https://github.com/Arturio93/shell-test&cloudshell_print=README.md
```
**Why:** Prints full README for reference

---

## 🛠️ Creating a Wrapper Script

For even more control, create a wrapper script:

**Create `auto-deploy.sh`:**
```bash
#!/bin/bash
# Auto-deployment wrapper

echo "🚀 Starting automated deployment..."
echo ""
echo "This will:"
echo "  1. Configure your GCP project"
echo "  2. Set up Cloud Run with nginx"
echo "  3. Deploy automatically"
echo ""
echo "Press Ctrl+C within 5 seconds to cancel..."
echo ""

# Countdown
for i in 5 4 3 2 1; do
  echo "Starting in $i..."
  sleep 1
done

echo ""
echo "🎯 Launching setup..."
echo ""

# Run the actual setup
./setup.sh
```

**Use in cloudshell.yaml:**
```yaml
startup_script: |
  #!/bin/bash
  chmod +x auto-deploy.sh setup.sh
  ./auto-deploy.sh
```

---

## 📊 Comparison Table

| Approach | Auto-Run | User Control | Best For |
|----------|----------|--------------|----------|
| Option 1 (Prompt) | Semi-auto | High | General use |
| Option 2 (Auto) | Fully auto | Low | Demos, workshops |
| Option 3 (Tutorial) | Manual | Highest | Learning |
| Option 4 (Custom) | Manual | High | Documentation |

---

## 🎨 Markdown Button Examples

### Standard Button
```markdown
[![Open in Cloud Shell](https://gstatic.com/cloudssh/images/open-btn.svg)](https://shell.cloud.google.com/cloudshell/editor?cloudshell_git_repo=https://github.com/Arturio93/shell-test&cloudshell_tutorial=tutorial.md)
```

### With Custom Text
```markdown
[🚀 Deploy Now in Cloud Shell](https://shell.cloud.google.com/cloudshell/editor?cloudshell_git_repo=https://github.com/Arturio93/shell-test)
```

### Multiple Options
```markdown
## Quick Deploy

Choose your deployment method:

| Method | Link |
|--------|------|
| 🎓 **Tutorial** (Recommended) | [![Tutorial](https://gstatic.com/cloudssh/images/open-btn.svg)](URL_WITH_TUTORIAL) |
| ⚡ **Quick Setup** | [![Quick](https://gstatic.com/cloudssh/images/open-btn.svg)](URL_AUTO_RUN) |
| 📖 **Manual** | [![Manual](https://gstatic.com/cloudssh/images/open-btn.svg)](URL_BASIC) |
```

---

## 🔒 Security Considerations

### Why Scripts Don't Auto-Run by Default

Google Cloud Shell intentionally doesn't allow arbitrary script execution via URL parameters for security:
- Prevents malicious scripts from running
- User must explicitly trigger execution
- Gives users control over what runs

### Best Practices

1. ✅ **Use cloudshell.yaml startup_script** - This is the official way
2. ✅ **Give users a prompt** - Let them choose to proceed
3. ✅ **Add countdown/delay** - Give time to cancel
4. ✅ **Show what will run** - Be transparent
5. ❌ **Don't hide commands** - Always visible to user

---

## 💡 Tips & Tricks

### Tip 1: Test Locally First
```bash
# Test your cloudshell.yaml locally
bash -c "$(cat cloudshell.yaml | grep -A 100 'startup_script:' | tail -n +2)"
```

### Tip 2: Different Links for Different Audiences
- Beginners → Tutorial link
- Developers → Auto-run link
- Documentation → Print README

### Tip 3: URL Encoding
If your repository name or parameters have special characters:
```javascript
// JavaScript example
const encodedUrl = encodeURIComponent(repoUrl);
const link = `https://shell.cloud.google.com/cloudshell/editor?cloudshell_git_repo=${encodedUrl}`;
```

### Tip 4: Short URLs
Use a URL shortener for cleaner links:
```
bit.ly/deploy-cloudrun
```

---

## 📚 Additional Resources

- [Cloud Shell Documentation](https://cloud.google.com/shell/docs)
- [Cloud Shell Tutorial Authoring](https://cloud.google.com/shell/docs/tutorial-authoring)
- [Cloud Shell Open in Cloud Shell](https://cloud.google.com/shell/docs/open-in-cloud-shell)

---

## 🎉 Current Setup

Your repository is currently configured with **Option 1 (Prompt User)**.

**Your working link:**
```
https://shell.cloud.google.com/cloudshell/editor?cloudshell_git_repo=https://github.com/Arturio93/shell-test&cloudshell_tutorial=tutorial.md
```

When users click:
1. ✅ Repository clones
2. ✅ Welcome message appears
3. ✅ User presses ENTER → setup.sh runs
4. ✅ Tutorial is also available in side panel

This provides the best balance of automation and user control! 🚀

