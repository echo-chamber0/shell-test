#!/bin/bash
set -e

# Colors for better UI
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# Unicode symbols for better visual
CHECK="✓"
CROSS="✗"
ARROW="→"
STAR="★"

# Function to print colored output
print_header() {
    echo -e "\n${BOLD}${PURPLE}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BOLD}${PURPLE}║${NC}  ${CYAN}$1${NC}"
    echo -e "${BOLD}${PURPLE}╚════════════════════════════════════════════════════════════════╝${NC}\n"
}

print_success() {
    echo -e "${GREEN}${CHECK}${NC} $1"
}

print_error() {
    echo -e "${RED}${CROSS}${NC} $1"
}

print_info() {
    echo -e "${BLUE}${ARROW}${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC}  $1"
}

print_step() {
    echo -e "\n${BOLD}${CYAN}▶ $1${NC}\n"
}

# Function to prompt for input with default value
prompt_input() {
    local prompt=$1
    local default=$2
    local var_name=$3
    
    echo -e "${CYAN}?${NC} ${prompt}"
    if [ -n "$default" ]; then
        echo -e "  ${YELLOW}(default: ${default})${NC}"
    fi
    echo -n "  ${ARROW} "
    read -r input
    
    if [ -z "$input" ] && [ -n "$default" ]; then
        eval "$var_name='$default'"
    else
        eval "$var_name='$input'"
    fi
}

# Function to prompt for confirmation
confirm() {
    local prompt=$1
    echo -e "\n${YELLOW}?${NC} ${prompt} ${YELLOW}(y/n)${NC}"
    echo -n "  ${ARROW} "
    read -r response
    case "$response" in
        [yY][eE][sS]|[yY]) 
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

# Function to strip ANSI color codes from a string
strip_ansi() {
    echo "$1" | sed 's/\x1b\[[0-9;]*m//g' | tr -d '\r'
}

# Function to display a menu
select_option() {
    local prompt=$1
    shift
    local options=("$@")
    
    echo -e "\n${CYAN}?${NC} ${prompt}\n"
    
    # Use plain PS3 prompt without color codes to prevent capture issues
    PS3="  → Enter your choice (number): "
    select opt in "${options[@]}"; do
        if [ -n "$opt" ]; then
            # Return only the first word, stripping any color codes or special chars
            echo "$opt" | awk '{print $1}' | sed 's/\x1b\[[0-9;]*m//g' | tr -d '\r'
            break
        else
            echo -e "${RED}Invalid selection. Please try again.${NC}"
        fi
    done
}

# Welcome banner
clear
cat << "EOF"
╔═══════════════════════════════════════════════════════════════════════╗
║                                                                       ║
║     ██████╗ ██╗      ██████╗ ██╗   ██╗██████╗     ██████╗ ██╗   ██╗ ║
║    ██╔════╝ ██║     ██╔═══██╗██║   ██║██╔══██╗    ██╔══██╗██║   ██║ ║
║    ██║      ██║     ██║   ██║██║   ██║██║  ██║    ██████╔╝██║   ██║ ║
║    ██║      ██║     ██║   ██║██║   ██║██║  ██║    ██╔══██╗██║   ██║ ║
║    ╚██████╗ ███████╗╚██████╔╝╚██████╔╝██████╔╝    ██║  ██║╚██████╔╝ ║
║     ╚═════╝ ╚══════╝ ╚═════╝  ╚═════╝ ╚═════╝     ╚═╝  ╚═╝ ╚═════╝  ║
║                                                                       ║
║              Terraform Deployment Setup - Cloud Run + Nginx          ║
║                                                                       ║
╚═══════════════════════════════════════════════════════════════════════╝
EOF

echo -e "\n${CYAN}Welcome!${NC} This script will help you deploy a Cloud Run service with nginx.\n"
echo -e "${YELLOW}${STAR}${NC} Interactive setup with validation"
echo -e "${YELLOW}${STAR}${NC} Automated Terraform deployment"
echo -e "${YELLOW}${STAR}${NC} Easy configuration"
echo ""

# Check if we're in Cloud Shell
if [ -n "$CLOUD_SHELL" ]; then
    print_success "Running in Google Cloud Shell"
else
    print_warning "Not running in Cloud Shell. Make sure gcloud is configured."
fi

# Step 1: Project Configuration
print_header "Step 1: Project Configuration"

# Get current project
CURRENT_PROJECT=$(gcloud config get-value project 2>/dev/null)

if [ -n "$CURRENT_PROJECT" ]; then
    print_info "Current GCP Project: ${BOLD}${CURRENT_PROJECT}${NC}"
    
    if confirm "Use this project?"; then
        PROJECT_ID=$CURRENT_PROJECT
    else
        prompt_input "Enter your GCP Project ID:" "" PROJECT_ID
    fi
else
    prompt_input "Enter your GCP Project ID:" "" PROJECT_ID
fi

# Validate project exists
print_step "Validating project..."
if gcloud projects describe "$PROJECT_ID" &>/dev/null; then
    print_success "Project ${BOLD}${PROJECT_ID}${NC} is valid"
else
    print_error "Project ${BOLD}${PROJECT_ID}${NC} not found or not accessible"
    exit 1
fi

# Set the project
gcloud config set project "$PROJECT_ID" &>/dev/null

# Step 2: Region Selection
print_header "Step 2: Region Selection"

echo -e "Select a region for your Cloud Run service:\n"
REGION=$(select_option "Choose region:" \
    "us-central1 (Iowa)" \
    "us-east1 (South Carolina)" \
    "us-west1 (Oregon)" \
    "europe-west1 (Belgium)" \
    "europe-west4 (Netherlands)" \
    "asia-northeast1 (Tokyo)" \
    "asia-southeast1 (Singapore)" \
    "Custom (enter manually)")

if [[ "$REGION" == "Custom"* ]]; then
    prompt_input "Enter region:" "us-central1" REGION
else
    REGION=$(echo "$REGION" | awk '{print $1}')
fi

print_success "Region set to: ${BOLD}${REGION}${NC}"

# Step 3: Service Configuration
print_header "Step 3: Service Configuration"

prompt_input "Service name:" "nginx-demo" SERVICE_NAME

# Validate service name
if [[ ! "$SERVICE_NAME" =~ ^[a-z0-9]([-a-z0-9]*[a-z0-9])?$ ]]; then
    print_error "Invalid service name. Must be lowercase alphanumeric with hyphens."
    exit 1
fi

print_success "Service name: ${BOLD}${SERVICE_NAME}${NC}"

# Step 4: Resource Configuration
print_header "Step 4: Resource Configuration"

echo -e "Configure resources for your Cloud Run service:\n"

# CPU Selection
CPU=$(select_option "CPU allocation:" "1 (default)" "2" "4")
CPU=$(echo "$CPU" | awk '{print $1}')

# Memory Selection
MEMORY=$(select_option "Memory allocation:" "256Mi" "512Mi (default)" "1Gi" "2Gi")
MEMORY=$(echo "$MEMORY" | awk '{print $1}')

# Max Instances
prompt_input "Maximum instances:" "10" MAX_INSTANCES

# Min Instances
prompt_input "Minimum instances (0 for scale to zero):" "0" MIN_INSTANCES

print_success "Resources configured:"
echo -e "  ${ARROW} CPU: ${BOLD}${CPU}${NC}"
echo -e "  ${ARROW} Memory: ${BOLD}${MEMORY}${NC}"
echo -e "  ${ARROW} Instances: ${BOLD}${MIN_INSTANCES}-${MAX_INSTANCES}${NC}"

# Step 5: Access Control
print_header "Step 5: Access Control"

if confirm "Allow unauthenticated access (public)?"; then
    ALLOW_UNAUTH="true"
    print_info "Service will be publicly accessible"
else
    ALLOW_UNAUTH="false"
    print_warning "Service will require authentication"
fi

# Step 6: Configuration Summary
print_header "Configuration Summary"

cat << EOF
╭─────────────────────────────────────────────────────────────╮
│                    Deployment Configuration                 │
├─────────────────────────────────────────────────────────────┤
│ Project ID:         ${PROJECT_ID}
│ Region:             ${REGION}
│ Service Name:       ${SERVICE_NAME}
│ CPU:                ${CPU}
│ Memory:             ${MEMORY}
│ Min Instances:      ${MIN_INSTANCES}
│ Max Instances:      ${MAX_INSTANCES}
│ Public Access:      ${ALLOW_UNAUTH}
╰─────────────────────────────────────────────────────────────╯
EOF

echo ""

if ! confirm "Proceed with deployment?"; then
    print_warning "Deployment cancelled"
    exit 0
fi

# Strip any ANSI codes from all variables before using them
PROJECT_ID=$(strip_ansi "$PROJECT_ID")
REGION=$(strip_ansi "$REGION")
SERVICE_NAME=$(strip_ansi "$SERVICE_NAME")
CPU=$(strip_ansi "$CPU")
MEMORY=$(strip_ansi "$MEMORY")
MIN_INSTANCES=$(strip_ansi "$MIN_INSTANCES")
MAX_INSTANCES=$(strip_ansi "$MAX_INSTANCES")
ALLOW_UNAUTH=$(strip_ansi "$ALLOW_UNAUTH")

# Export variables for Terraform
export TF_VAR_project_id="$PROJECT_ID"
export TF_VAR_region="$REGION"
export TF_VAR_service_name="$SERVICE_NAME"
export TF_VAR_cpu="$CPU"
export TF_VAR_memory="$MEMORY"
export TF_VAR_min_instances="$MIN_INSTANCES"
export TF_VAR_max_instances="$MAX_INSTANCES"
export TF_VAR_allow_unauthenticated="$ALLOW_UNAUTH"

# Save configuration to file for later reference
cat > terraform.tfvars << EOF
project_id              = "$PROJECT_ID"
region                  = "$REGION"
service_name            = "$SERVICE_NAME"
cpu                     = "$CPU"
memory                  = "$MEMORY"
min_instances           = $MIN_INSTANCES
max_instances           = $MAX_INSTANCES
allow_unauthenticated   = $ALLOW_UNAUTH
EOF

print_success "Configuration saved to terraform.tfvars"

# Step 7: Terraform Initialization
print_header "Step 7: Terraform Initialization"

print_step "Initializing Terraform..."
if terraform init; then
    print_success "Terraform initialized successfully"
else
    print_error "Terraform initialization failed"
    exit 1
fi

# Step 8: Terraform Plan
print_header "Step 8: Review Deployment Plan"

print_step "Generating deployment plan..."
echo ""
if terraform plan -out=tfplan; then
    print_success "Plan generated successfully"
    echo ""
    
    if ! confirm "Review looks good? Proceed with deployment?"; then
        print_warning "Deployment cancelled"
        rm -f tfplan
        exit 0
    fi
else
    print_error "Terraform plan failed"
    exit 1
fi

# Step 9: Deployment
print_header "Step 9: Deploying Infrastructure"

print_step "Applying Terraform configuration..."
echo -e "${YELLOW}This may take 2-3 minutes...${NC}\n"

if terraform apply tfplan; then
    rm -f tfplan
    print_success "Deployment completed successfully!"
else
    print_error "Deployment failed"
    rm -f tfplan
    exit 1
fi

# Step 10: Results
print_header "Deployment Complete! 🎉"

SERVICE_URL=$(terraform output -raw service_url 2>/dev/null || echo "")

if [ -n "$SERVICE_URL" ]; then
    echo -e "${GREEN}${STAR}${NC} ${BOLD}Your service is now running!${NC}\n"
    echo -e "${CYAN}Service URL:${NC}"
    echo -e "  ${BOLD}${SERVICE_URL}${NC}\n"
    
    echo -e "${CYAN}Quick Actions:${NC}"
    echo -e "  ${ARROW} Test with curl: ${YELLOW}curl ${SERVICE_URL}${NC}"
    echo -e "  ${ARROW} View logs: ${YELLOW}gcloud run services logs read ${SERVICE_NAME} --region=${REGION}${NC}"
    echo -e "  ${ARROW} View in console: ${YELLOW}https://console.cloud.google.com/run?project=${PROJECT_ID}${NC}\n"
    
    if confirm "Open service URL in browser preview?"; then
        if [ -n "$CLOUD_SHELL" ]; then
            cloudshell open-workspace-url "$SERVICE_URL"
        else
            echo -e "\n${BLUE}Open this URL in your browser:${NC}"
            echo -e "${BOLD}${SERVICE_URL}${NC}\n"
        fi
    fi
    
    if confirm "Test the service with curl?"; then
        print_step "Testing service..."
        echo ""
        if curl -s "$SERVICE_URL" | head -20; then
            echo ""
            print_success "Service is responding correctly!"
        else
            print_warning "Service might still be starting up. Try again in a few moments."
        fi
    fi
fi

# Cleanup instructions
echo ""
print_header "Next Steps"

cat << EOF
${CYAN}Useful Commands:${NC}

  ${ARROW} View all resources:
    ${YELLOW}terraform state list${NC}

  ${ARROW} Update configuration:
    1. Edit terraform.tfvars
    2. Run: ${YELLOW}terraform apply${NC}

  ${ARROW} Destroy resources (cleanup):
    ${YELLOW}terraform destroy${NC}

  ${ARROW} View service details:
    ${YELLOW}gcloud run services describe ${SERVICE_NAME} --region=${REGION}${NC}

  ${ARROW} View logs:
    ${YELLOW}gcloud run services logs read ${SERVICE_NAME} --region=${REGION} --limit=50${NC}

${GREEN}Thank you for using this deployment tool!${NC} ${STAR}

EOF

# Optional: Open tutorial
if [ -f "tutorial.md" ] && [ -n "$CLOUD_SHELL" ]; then
    echo ""
    if confirm "Would you like to open the interactive tutorial?"; then
        cloudshell launch-tutorial tutorial.md
    fi
fi

