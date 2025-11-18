#!/bin/bash
# Data Commons Cloud Run Deployment Script
# Orchestrates the complete deployment workflow

set -e

echo "================================================================================"
echo " Data Commons Cloud Run Deployment"
echo "================================================================================"
echo ""

# Check for configuration
if [ ! -f "terraform/terraform.tfvars" ]; then
    echo "Configuration file not found. Running setup..."
    echo ""
    python3 setup.py
    
    if [ $? -ne 0 ]; then
        echo "ERROR: Setup failed. Exiting."
        exit 1
    fi
    echo ""
fi

echo "Configuration verified."
echo ""

# Initialize Terraform
cd terraform

if [ ! -d ".terraform" ]; then
    echo "Initializing Terraform..."
    terraform init
    
    if [ $? -ne 0 ]; then
        echo "ERROR: Terraform initialization failed."
        exit 1
    fi
    
    echo "Terraform initialized successfully."
    echo ""
else
    echo "Terraform already initialized."
    echo ""
fi

# Show infrastructure plan
echo "Previewing infrastructure changes..."
echo ""
terraform plan

if [ $? -ne 0 ]; then
    echo "ERROR: Terraform plan failed."
    exit 1
fi

# Confirm deployment
echo ""
echo "================================================================================"
echo " Ready to deploy infrastructure"
echo "================================================================================"
echo ""
read -p "Continue with deployment? (yes/no): " confirm

if [ "$confirm" != "yes" ]; then
    echo "Deployment cancelled."
    exit 0
fi

# Deploy infrastructure
echo ""
echo "Deploying infrastructure..."
echo ""
terraform apply -auto-approve

if [ $? -eq 0 ]; then
    echo ""
    echo "================================================================================"
    echo " Deployment Complete"
    echo "================================================================================"
    echo ""
    echo "Deployment summary:"
    terraform output
    echo ""
    echo "Test your service:"
    echo "  curl \$(terraform output -raw service_url)"
    echo ""
else
    echo ""
    echo "ERROR: Deployment failed. Check errors above."
    exit 1
fi
