#!/bin/bash
set -e

# ========================================
# Cloud Run Deployment Orchestrator
# ========================================
# This script orchestrates the full deployment:
# 1. Runs interactive setup (if config missing)
# 2. Initializes Terraform
# 3. Plans infrastructure changes
# 4. Deploys with confirmation
# ========================================

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${CYAN}🚀 Cloud Run Deployment Orchestrator${NC}\n"

# ========================================
# Step 1: Check Configuration
# ========================================

if [ ! -f "terraform/terraform.tfvars" ]; then
    echo -e "${YELLOW}⚠️  Configuration not found. Running interactive setup...${NC}\n"
    python3 setup.py
    
    if [ $? -ne 0 ]; then
        echo -e "${RED}❌ Setup failed. Exiting.${NC}"
        exit 1
    fi
    echo ""
fi

echo -e "${GREEN}✅ Configuration found${NC}\n"

# ========================================
# Step 2: Initialize Terraform
# ========================================

cd terraform

if [ ! -d ".terraform" ]; then
    echo -e "${BLUE}📦 Initializing Terraform...${NC}"
    terraform init
    
    if [ $? -ne 0 ]; then
        echo -e "${RED}❌ Terraform initialization failed.${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}✅ Terraform initialized${NC}\n"
else
    echo -e "${GREEN}✅ Terraform already initialized${NC}\n"
fi

# ========================================
# Step 3: Show Plan
# ========================================

echo -e "${BLUE}📋 Previewing infrastructure changes...${NC}\n"
terraform plan

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Terraform plan failed.${NC}"
    exit 1
fi

# ========================================
# Step 4: Confirm Deployment
# ========================================

echo -e "\n${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}⚠️  Ready to deploy infrastructure to GCP${NC}"
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e ""
read -p "Continue with deployment? (yes/no): " confirm

if [ "$confirm" != "yes" ]; then
    echo -e "${RED}❌ Deployment cancelled.${NC}"
    exit 0
fi

# ========================================
# Step 5: Apply Configuration
# ========================================

echo -e "\n${GREEN}🏗️  Deploying infrastructure...${NC}\n"
terraform apply -auto-approve

if [ $? -eq 0 ]; then
    echo -e "\n${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}🎉 Deployment successful!${NC}"
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
    
    echo -e "${CYAN}📊 Deployment Summary:${NC}\n"
    terraform output
    
    echo -e "\n${CYAN}💡 Quick Test:${NC}"
    echo -e "curl \$(terraform output -raw service_url)\n"
else
    echo -e "\n${RED}❌ Deployment failed. Check errors above.${NC}"
    exit 1
fi

