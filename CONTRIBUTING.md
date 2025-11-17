# Contributing Guide

Thank you for your interest in contributing to this project! This guide will help you get started.

## 🚀 Quick Start for Contributors

1. **Fork the repository**
2. **Clone your fork**
   ```bash
   git clone https://github.com/YOUR_USERNAME/shell-test.git
   cd shell-test
   ```
3. **Create a branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```
4. **Make your changes**
5. **Test your changes** (see Testing section below)
6. **Commit and push**
   ```bash
   git add .
   git commit -m "Description of your changes"
   git push origin feature/your-feature-name
   ```
7. **Open a Pull Request**

## 🧪 Testing Your Changes

### Test Terraform Configuration

```bash
# Format check
terraform fmt -check -recursive

# Initialize
terraform init

# Validate
terraform validate

# Plan (requires valid GCP project)
terraform plan
```

### Test Setup Script

```bash
# Make executable
chmod +x setup.sh

# Run in dry-run mode (add this feature if needed)
./setup.sh
```

### Test Tutorial

```bash
# In Cloud Shell
cloudshell launch-tutorial tutorial.md

# Review all steps for accuracy
```

## 📝 Contribution Guidelines

### Code Style

**Terraform**
- Follow [HashiCorp's style guide](https://www.terraform.io/docs/language/syntax/style.html)
- Use `terraform fmt` before committing
- Add comments for complex logic
- Use meaningful resource names

**Bash Scripts**
- Follow [Google's Shell Style Guide](https://google.github.io/styleguide/shellguide.html)
- Use shellcheck for validation
- Add error handling (`set -e`)
- Comment non-obvious sections

**Markdown**
- Use proper heading hierarchy
- Include code blocks with syntax highlighting
- Add links to relevant documentation
- Check spelling and grammar

### Commit Messages

Follow [Conventional Commits](https://www.conventionalcommits.org/):

```
feat: add support for custom domains
fix: resolve terraform state locking issue
docs: update README with new examples
style: format terraform files
refactor: simplify setup script logic
test: add validation for setup script
chore: update dependencies
```

### Pull Request Process

1. **Update documentation** if needed
2. **Add/update tests** for new features
3. **Ensure CI passes** (GitHub Actions)
4. **Update CHANGELOG.md** with your changes
5. **Request review** from maintainers
6. **Address feedback** promptly

### What to Contribute

**Ideas for Contributions:**

🎯 **Features**
- Additional Cloud Run configuration options
- Support for other container images
- Custom domain setup
- Cloud SQL integration
- Secret Manager integration
- VPC connector support
- Multiple service deployment

🐛 **Bug Fixes**
- Fix any issues you encounter
- Improve error handling
- Edge case handling

📚 **Documentation**
- Improve README clarity
- Add more examples
- Translate to other languages
- Add diagrams/screenshots
- Video tutorials

🧪 **Testing**
- Add integration tests
- Improve validation
- Test on different environments

🎨 **UI/UX**
- Improve setup script interface
- Better tutorial flow
- More helpful error messages

## 🔍 Code Review Checklist

Before submitting, ensure:

- [ ] Code follows project style guidelines
- [ ] All tests pass
- [ ] Documentation is updated
- [ ] Commit messages are clear
- [ ] No sensitive data (API keys, project IDs) in code
- [ ] Terraform files are formatted (`terraform fmt`)
- [ ] Scripts are shellcheck-clean
- [ ] README examples work
- [ ] Tutorial steps are accurate
- [ ] No breaking changes (or clearly documented)

## 🐛 Reporting Bugs

### Before Reporting

1. Search existing issues
2. Try the latest version
3. Check documentation

### Bug Report Template

```markdown
**Description**
A clear description of the bug.

**To Reproduce**
Steps to reproduce:
1. Run '...'
2. Click on '...'
3. See error

**Expected Behavior**
What you expected to happen.

**Actual Behavior**
What actually happened.

**Environment**
- OS: [e.g., Cloud Shell, macOS, Ubuntu]
- Terraform version: [e.g., 1.6.0]
- GCP region: [e.g., us-central1]

**Logs/Screenshots**
Relevant error messages or screenshots.

**Additional Context**
Any other relevant information.
```

## 💡 Feature Requests

### Feature Request Template

```markdown
**Feature Description**
Clear description of the proposed feature.

**Use Case**
Why is this feature needed? Who will benefit?

**Proposed Implementation**
How should this work?

**Alternatives Considered**
What other solutions did you consider?

**Additional Context**
Any other relevant information.
```

## 🏗️ Development Setup

### Prerequisites

- Git
- Terraform >= 1.0
- Google Cloud SDK (gcloud)
- shellcheck (optional, for bash validation)
- A GCP project for testing

### Local Development

```bash
# Clone the repo
git clone https://github.com/YOUR_USERNAME/shell-test.git
cd shell-test

# Create a test branch
git checkout -b test/my-changes

# Make changes
# ...

# Format Terraform
terraform fmt -recursive

# Validate
terraform init
terraform validate

# Test (requires GCP project)
export TF_VAR_project_id="your-test-project"
terraform plan
```

### Testing in Cloud Shell

The best way to test the complete experience:

1. Push changes to your fork
2. Update the "Open in Cloud Shell" URL to point to your fork
3. Click the button and test the full flow

## 📋 Project Structure

Understanding the project layout:

```
shell-test/
├── .github/
│   └── workflows/        # CI/CD workflows
├── main.tf              # Main Terraform config
├── variables.tf         # Input variables
├── outputs.tf           # Output values
├── setup.sh            # Interactive setup script
├── tutorial.md         # Cloud Shell tutorial
├── README.md           # Main documentation
├── QUICKSTART.md       # Quick start guide
├── CONTRIBUTING.md     # This file
├── example.tfvars      # Example variables
├── .gitignore         # Git ignore rules
├── cloudshell.yaml    # Cloud Shell config
└── LICENSE            # MIT License
```

## 🤝 Community

### Getting Help

- Open a [GitHub Issue](https://github.com/YOUR_USERNAME/shell-test/issues)
- Check existing documentation
- Review closed issues for solutions

### Code of Conduct

Be respectful and inclusive. We follow the [Contributor Covenant](https://www.contributor-covenant.org/).

## 📜 License

By contributing, you agree that your contributions will be licensed under the MIT License.

## 🙏 Thank You!

Every contribution, no matter how small, helps make this project better. We appreciate your time and effort!

---

**Questions?** Feel free to open an issue or reach out to the maintainers.

