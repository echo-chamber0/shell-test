#!/bin/bash
set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}  Git Repository Initialization Script${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}\n"

# Check if already a git repo
if [ -d ".git" ]; then
    echo -e "${YELLOW}⚠  This directory is already a git repository.${NC}"
    echo -e "${YELLOW}   If you want to reinitialize, delete .git first: rm -rf .git${NC}\n"
    exit 1
fi

# Initialize git
echo -e "${BLUE}▶${NC} Initializing git repository..."
git init
echo -e "${GREEN}✓${NC} Git repository initialized\n"

# Create initial commit
echo -e "${BLUE}▶${NC} Creating initial commit..."
git add .
git commit -m "Initial commit: Cloud Run Terraform deployment with interactive setup"
echo -e "${GREEN}✓${NC} Initial commit created\n"

# Instructions for GitHub
echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}  Next Steps: Push to GitHub${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}\n"

echo -e "1. Create a new repository on GitHub:"
echo -e "   ${YELLOW}https://github.com/new${NC}\n"

echo -e "2. Name your repository: ${YELLOW}shell-test${NC}\n"

echo -e "3. ${YELLOW}DO NOT${NC} initialize with README, .gitignore, or license\n"

echo -e "4. After creating the repository, run these commands:\n"

echo -e "   ${BLUE}# Set your GitHub username${NC}"
echo -e "   ${YELLOW}GITHUB_USERNAME=\"your-username\"${NC}\n"

echo -e "   ${BLUE}# Add remote${NC}"
echo -e "   ${YELLOW}git remote add origin https://github.com/\$GITHUB_USERNAME/shell-test.git${NC}\n"

echo -e "   ${BLUE}# Set main branch${NC}"
echo -e "   ${YELLOW}git branch -M main${NC}\n"

echo -e "   ${BLUE}# Push to GitHub${NC}"
echo -e "   ${YELLOW}git push -u origin main${NC}\n"

echo -e "5. Update the README.md with your GitHub username:"
echo -e "   ${YELLOW}sed -i 's/YOUR_USERNAME/'"\$GITHUB_USERNAME"'/g' README.md${NC}"
echo -e "   ${YELLOW}git add README.md${NC}"
echo -e "   ${YELLOW}git commit -m 'docs: update GitHub username in README'${NC}"
echo -e "   ${YELLOW}git push${NC}\n"

echo -e "6. Your 'Open in Cloud Shell' button will be at:"
echo -e "   ${GREEN}https://shell.cloud.google.com/cloudshell/editor?cloudshell_git_repo=https://github.com/\$GITHUB_USERNAME/shell-test&cloudshell_tutorial=tutorial.md${NC}\n"

echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}✓${NC} Setup complete! Follow the steps above to push to GitHub.\n"

# Offer to set remote if user provides username
echo -e "${BLUE}Quick Setup:${NC}"
echo -n "Enter your GitHub username (or press Enter to skip): "
read -r github_username

if [ -n "$github_username" ]; then
    echo -e "\n${BLUE}▶${NC} Configuring remote..."
    git remote add origin "https://github.com/$github_username/shell-test.git"
    git branch -M main
    
    echo -e "${GREEN}✓${NC} Remote configured\n"
    
    echo -e "${BLUE}▶${NC} Updating README with your username..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        sed -i '' "s/YOUR_USERNAME/$github_username/g" README.md
    else
        # Linux
        sed -i "s/YOUR_USERNAME/$github_username/g" README.md
    fi
    
    git add README.md
    git commit -m "docs: update GitHub username in README"
    
    echo -e "${GREEN}✓${NC} README updated\n"
    
    echo -e "${GREEN}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}  Ready to Push!${NC}"
    echo -e "${GREEN}═══════════════════════════════════════════════════════════${NC}\n"
    
    echo -e "Run: ${YELLOW}git push -u origin main${NC}\n"
    
    echo -e "Your 'Open in Cloud Shell' URL:"
    echo -e "${GREEN}https://shell.cloud.google.com/cloudshell/editor?cloudshell_git_repo=https://github.com/$github_username/shell-test&cloudshell_tutorial=tutorial.md${NC}\n"
fi

