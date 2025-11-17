# Contributing to Cloud Run Interactive Tutorial

Thank you for your interest in contributing! 🎉

## How to Contribute

### 1. Report Issues

Found a bug or have a feature request?
- Check if the issue already exists
- Open a new issue with clear description
- Include steps to reproduce (for bugs)

### 2. Suggest Improvements

Have ideas to make this better?
- Open an issue with the "enhancement" label
- Describe your proposal clearly
- Explain the use case

### 3. Submit Pull Requests

Want to contribute code?

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Make your changes
4. Test thoroughly (see Testing section)
5. Commit with clear messages: `git commit -m 'Add amazing feature'`
6. Push to your fork: `git push origin feature/amazing-feature`
7. Open a Pull Request

## Development Guidelines

### Code Style

**Python:**
- Follow PEP 8
- Use type hints where appropriate
- Add docstrings for functions/classes
- Keep functions focused and small

**Terraform:**
- Use consistent formatting (`terraform fmt`)
- Add comments for complex logic
- Include validation rules for variables
- Document resources with descriptions

**Shell Scripts:**
- Use `set -e` for error handling
- Add comments for clarity
- Use colors for user feedback
- Test on bash and zsh

### Testing

Before submitting:

1. **Test Python Script:**
   ```bash
   python setup.py
   ```
   - Try valid and invalid inputs
   - Test cancellation (Ctrl+C)
   - Verify generated tfvars file

2. **Test Terraform:**
   ```bash
   cd terraform
   terraform init
   terraform validate
   terraform fmt -check
   terraform plan
   ```

3. **Test in Cloud Shell:**
   - Push to your fork
   - Test the "Open in Cloud Shell" link
   - Follow tutorial end-to-end

### Documentation

- Update README.md for new features
- Update tutorial.md for user-facing changes
- Add comments in code for complex logic
- Include examples for new functionality

## Project Structure

```
.
├── README.md              # Main documentation
├── tutorial.md            # Cloud Shell tutorial
├── setup.py               # Interactive CLI
├── requirements.txt       # Python dependencies
├── deploy.sh              # Deployment orchestration
├── cleanup.sh             # Resource cleanup
├── terraform/
│   ├── main.tf            # Main infrastructure
│   ├── variables.tf       # Input variables
│   ├── outputs.tf         # Output values
│   └── terraform.tfvars.example
└── .gcloudignore          # Cloud Shell ignore patterns
```

## Feature Ideas

Looking for contribution ideas? Consider:

- [ ] Add support for custom Docker images
- [ ] Implement Cloud SQL integration
- [ ] Add monitoring/alerting setup
- [ ] Support for custom domains
- [ ] Cloud Build CI/CD integration
- [ ] Multiple environment support (dev/staging/prod)
- [ ] Cost estimation before deployment
- [ ] Health check configuration
- [ ] Environment variable management
- [ ] Secret Manager integration

## Questions?

- Open an issue for questions
- Tag with "question" label
- Be specific about what you need help with

## Code of Conduct

Be respectful and constructive in all interactions. We're all here to learn and improve!

---

Thank you for contributing! 🚀

