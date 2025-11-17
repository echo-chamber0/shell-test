# Google Cloud Shell Link Configuration

This document explains how the "Open in Cloud Shell" button works and how to customize it for your repository.

## The Button

```markdown
[![Open in Cloud Shell](https://gstatic.com/cloudssh/images/open-btn.svg)](https://shell.cloud.google.com/cloudshell/editor?cloudshell_git_repo=https://github.com/YOUR_USERNAME/YOUR_REPO.git&cloudshell_tutorial=tutorial.md)
```

## URL Parameters

The Cloud Shell link supports several parameters:

### 1. `cloudshell_git_repo` (Required)

The GitHub repository URL to clone.

```
cloudshell_git_repo=https://github.com/YOUR_USERNAME/YOUR_REPO.git
```

**Important:** Replace `YOUR_USERNAME` and `YOUR_REPO` with actual values before publishing.

### 2. `cloudshell_tutorial` (Optional, Recommended)

Path to the tutorial markdown file that will automatically open in the tutorial panel.

```
cloudshell_tutorial=tutorial.md
```

Without this parameter, users would need to manually open the tutorial.

### 3. `cloudshell_open_in_editor` (Optional)

Comma-separated list of files to open in the Cloud Shell editor.

```
cloudshell_open_in_editor=setup.py,terraform/main.tf
```

### 4. `cloudshell_workspace` (Optional)

The directory to use as the workspace root.

```
cloudshell_workspace=.
```

### 5. `cloudshell_print` (Optional)

Path to a file whose contents will be printed to the terminal when Cloud Shell opens.

```
cloudshell_print=WELCOME.txt
```

## Complete Example

```markdown
[![Open in Cloud Shell](https://gstatic.com/cloudssh/images/open-btn.svg)](https://shell.cloud.google.com/cloudshell/editor?cloudshell_git_repo=https://github.com/myuser/cloud-run-demo.git&cloudshell_tutorial=tutorial.md&cloudshell_open_in_editor=setup.py&cloudshell_workspace=.)
```

## Tutorial Markdown Format

The `tutorial.md` file uses special Cloud Shell tutorial markup:

### Special Tags

#### Navigation Duration
```markdown
<walkthrough-tutorial-duration duration="10"></walkthrough-tutorial-duration>
```

#### Open File in Editor
```markdown
<walkthrough-editor-open-file filePath="terraform/main.tf">
Click to open file
</walkthrough-editor-open-file>
```

#### Navigate to Console Section
```markdown
<walkthrough-menu-navigation sectionId="CLOUD_RUN_SECTION">
</walkthrough-menu-navigation>
```

Available section IDs:
- `CLOUD_RUN_SECTION` - Cloud Run
- `COMPUTE_SECTION` - Compute Engine
- `STORAGE_SECTION` - Cloud Storage
- `SQL_SECTION` - Cloud SQL
- `KUBERNETES_SECTION` - GKE
- `APIs_SECTION` - APIs & Services

#### Conclusion Trophy
```markdown
<walkthrough-conclusion-trophy></walkthrough-conclusion-trophy>
```

Shows a trophy icon at the end of the tutorial.

### Tutorial Structure

Each step should be a level 2 heading (`##`):

```markdown
## Step 1: Setup Environment

Instructions for step 1...

---

## Step 2: Deploy Infrastructure

Instructions for step 2...
```

Use `---` (horizontal rule) to separate steps visually.

## Testing Your Link

1. **Update the README.md:**
   - Replace `YOUR_USERNAME` with your GitHub username
   - Replace `YOUR_REPO` with your repository name

2. **Push to GitHub:**
   ```bash
   git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO.git
   git branch -M main
   git push -u origin main
   ```

3. **Test the Button:**
   - View your README on GitHub
   - Click the "Open in Cloud Shell" button
   - Verify that:
     - Repository clones successfully
     - Tutorial opens automatically
     - All files are present

## Troubleshooting

### Button doesn't appear
- Check markdown syntax
- Ensure button is not inside code blocks
- View raw README to verify

### Tutorial doesn't open
- Verify `cloudshell_tutorial` parameter is correct
- Check that `tutorial.md` exists in repository
- Ensure file name matches exactly (case-sensitive)

### Repository doesn't clone
- Verify repository is public
- Check URL format is correct
- Ensure `.git` extension is included

### Files missing
- Check `.gcloudignore` file
- Verify files are committed to git
- Ensure no `.gitignore` conflicts

## Advanced: Auto-run Script on Open

The repository includes a `.cloudshellrc` file that runs automatically when Cloud Shell opens.

### Current Behavior

By default, it displays a welcome message and quick start instructions:

```bash
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Welcome to Cloud Run Interactive Deployment!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✨ Repository cloned successfully!

📚 The tutorial has opened in the right panel.
   Follow the steps to deploy your Cloud Run service.

Quick Start:
  1. Install dependencies: pip install -r requirements.txt
  2. Run interactive setup: python setup.py
  3. Deploy infrastructure: ./deploy.sh
```

### Optional: Auto-Install Dependencies

To automatically install Python dependencies when Cloud Shell opens, edit `.cloudshellrc` and uncomment:

```bash
# Uncomment these lines in .cloudshellrc:
echo "Installing Python dependencies..."
pip install -r requirements.txt --quiet
echo "✅ Dependencies installed"
```

### Optional: Auto-Run setup.py

To automatically run the interactive setup script, edit `.cloudshellrc` and uncomment:

```bash
# Uncomment this line in .cloudshellrc:
echo "Starting interactive setup..."
python setup.py
```

**⚠️ Warning:** Auto-running interactive scripts can be intrusive since it immediately prompts for input. Most users prefer to follow the tutorial at their own pace.

**Recommendation:** Keep the default behavior (welcome message only) for better user experience.

## Best Practices

1. **Keep tutorial concise** - 10-15 minutes ideal
2. **Use clear step titles** - Users should know what each step does
3. **Include code blocks** - With copy buttons for easy execution
4. **Add validation steps** - Help users verify success
5. **Provide cleanup instructions** - Avoid unexpected charges
6. **Test thoroughly** - In actual Cloud Shell environment
7. **Update regularly** - As GCP APIs and best practices evolve

## Resources

- [Cloud Shell Documentation](https://cloud.google.com/shell/docs)
- [Tutorial Markdown Guide](https://cloud.google.com/shell/docs/cloud-shell-tutorials/tutorials)
- [Cloud Shell Editor](https://cloud.google.com/code/docs/shell/using-cloud-shell-editor)

---

**Ready to Publish?**

1. Update README.md with your GitHub URL
2. Commit all changes
3. Push to GitHub
4. Test the button!

```bash
# Quick publish commands
git add .
git commit -m "Initial commit: Cloud Run interactive tutorial"
git push origin main
```

