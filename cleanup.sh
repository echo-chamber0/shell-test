#!/bin/bash
# Resource Cleanup Script
# Destroys all Terraform-managed resources

set -e

echo "================================================================================"
echo " Resource Cleanup"
echo "================================================================================"
echo ""

# Check if Terraform is initialized
if [ ! -d "terraform/.terraform" ]; then
    echo "Terraform not initialized. No resources to clean up."
    echo ""
    echo "If you have resources to remove manually:"
    echo "  gcloud run services delete SERVICE_NAME --region=REGION"
    exit 0
fi

cd terraform

# Show current resources
echo "Current infrastructure state:"
echo ""
terraform show

# Confirm destruction
echo ""
echo "================================================================================"
echo " WARNING: This will DELETE all deployed resources"
echo "================================================================================"
echo ""
echo "This action cannot be undone."
echo ""
read -p "Are you sure you want to destroy all resources? (yes/no): " confirm

if [ "$confirm" != "yes" ]; then
    echo "Cleanup cancelled. Resources preserved."
    exit 0
fi

# Destroy infrastructure
echo ""
echo "Destroying infrastructure..."
echo ""
terraform destroy -auto-approve

if [ $? -eq 0 ]; then
    echo ""
    echo "================================================================================"
    echo " Cleanup Complete"
    echo "================================================================================"
    echo ""
    echo "All resources have been successfully removed."
    echo ""
    echo "Resources destroyed:"
    echo "  - Cloud Run service"
    echo "  - IAM policy bindings"
    echo "  - Terraform state"
    echo ""
else
    echo ""
    echo "ERROR: Cleanup failed. Check errors above."
    echo ""
    echo "You may need to manually delete resources:"
    echo "  https://console.cloud.google.com/run"
    echo ""
    exit 1
fi
