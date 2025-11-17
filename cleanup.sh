#!/bin/bash
set -e

# ========================================
# Cloud Run Cleanup Script
# ========================================
# This script destroys all Terraform-managed
# resources to avoid unexpected GCP charges.
# ========================================

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}🧹 Cloud Run Cleanup Script${NC}\n"

# ========================================
# Step 1: Check if Terraform is initialized
# ========================================

if [ ! -d "terraform/.terraform" ]; then
    echo -e "${RED}❌ Terraform not initialized. Nothing to clean up.${NC}"
    echo -e "   If you want to clean up manually:"
    echo -e "   ${YELLOW}gcloud run services delete SERVICE_NAME --region=REGION${NC}"
    exit 0
fi

# ========================================
# Step 2: Show what will be destroyed
# ========================================

cd terraform

echo -e "${YELLOW}📋 Resources that will be destroyed:${NC}\n"
terraform show

echo -e "\n${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${RED}⚠️  WARNING: This will DELETE all deployed resources!${NC}"
echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${RED}This action CANNOT be undone.${NC}\n"

read -p "Are you sure you want to destroy all resources? (yes/no): " confirm

if [ "$confirm" != "yes" ]; then
    echo -e "${GREEN}✅ Cleanup cancelled. Resources preserved.${NC}"
    exit 0
fi

# ========================================
# Step 3: Destroy Infrastructure
# ========================================

echo -e "\n${YELLOW}🗑️  Destroying infrastructure...${NC}\n"
terraform destroy -auto-approve

if [ $? -eq 0 ]; then
    echo -e "\n${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}✅ All resources destroyed successfully!${NC}"
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
    
    echo -e "Cleaned up:"
    echo -e "  • Cloud Run service"
    echo -e "  • IAM policy bindings"
    echo -e "  • Terraform state\n"
    
    echo -e "${YELLOW}💡 You can safely delete this repository now.${NC}"
    echo -e "${YELLOW}   Or run 'python setup.py' to configure a new deployment.${NC}\n"
else
    echo -e "\n${RED}❌ Cleanup failed. Check errors above.${NC}"
    echo -e "${YELLOW}⚠️  You may need to manually delete resources in GCP Console.${NC}"
    echo -e "   Visit: https://console.cloud.google.com/run\n"
    exit 1
fi

