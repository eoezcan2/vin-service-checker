#!/bin/bash

# Google Cloud Platform Deployment Script for VIN Service Checker
# This script deploys the application to Google Cloud Platform

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if required environment variables are set
check_env_vars() {
    print_status "Checking environment variables..."
    
    required_vars=("PROJECT_ID" "REGION" "INSTANCE_NAME" "DB_USER" "DB_PASSWORD" "JWT_SECRET")
    
    for var in "${required_vars[@]}"; do
        if [ -z "${!var}" ]; then
            print_error "Environment variable $var is not set"
            exit 1
        fi
    done
    
    print_success "All required environment variables are set"
}

# Enable required APIs
enable_apis() {
    print_status "Enabling required Google Cloud APIs..."
    
    gcloud services enable \
        cloudbuild.googleapis.com \
        run.googleapis.com \
        sqladmin.googleapis.com \
        containerregistry.googleapis.com \
        cloudresourcemanager.googleapis.com
    
    print_success "APIs enabled successfully"
}

# Configure IAM permissions for Cloud Run services
configure_iam_permissions() {
    print_status "Configuring IAM permissions for Cloud Run services..."
    
    # Allow unauthenticated access to frontend
    gcloud run services add-iam-policy-binding vin-service-checker-frontend \
        --region=$REGION \
        --member="allUsers" \
        --role="roles/run.invoker" \
        --project=$PROJECT_ID || print_warning "Frontend IAM policy may already exist"
    
    # Allow unauthenticated access to backend
    gcloud run services add-iam-policy-binding vin-service-checker-backend \
        --region=$REGION \
        --member="allUsers" \
        --role="roles/run.invoker" \
        --project=$PROJECT_ID || print_warning "Backend IAM policy may already exist"
    
    print_success "IAM permissions configured successfully"
}

# Configure Docker authentication for GCR
configure_docker_auth() {
    print_status "Configuring Docker authentication for Google Container Registry..."
    
    # Configure Docker to use gcloud as a credential helper
    gcloud auth configure-docker --quiet
    
    print_success "Docker authentication configured successfully"
}

# Build and push backend image
build_and_push_backend() {
    print_status "Building and pushing backend image..."
    
    # Configure Docker authentication first
    configure_docker_auth
    
    # Build and push backend image
    print_status "Building backend image..."
    docker build -t gcr.io/$PROJECT_ID/vin-service-checker-backend:latest ./vin-service-checker-server
    docker push gcr.io/$PROJECT_ID/vin-service-checker-backend:latest
    
    print_success "Backend Docker image built and pushed successfully"
}

# Build and push frontend image
build_and_push_frontend() {
    print_status "Building and pushing frontend image..."
    
    # Build and push frontend image with backend URL
    print_status "Building frontend image..."
    docker build --build-arg VUE_APP_API_URL=https://$BACKEND_SERVICE_URL -t gcr.io/$PROJECT_ID/vin-service-checker-frontend:latest .
    docker push gcr.io/$PROJECT_ID/vin-service-checker-frontend:latest
    
    print_success "Frontend Docker image built and pushed successfully"
}

# Deploy backend to Cloud Run
deploy_backend() {
    print_status "Deploying backend to Cloud Run..."
    
    # Replace placeholders in the YAML file
    sed -e "s/\${PROJECT_ID}/$PROJECT_ID/g" \
        -e "s/\${REGION}/$REGION/g" \
        -e "s/\${INSTANCE_NAME}/$INSTANCE_NAME/g" \
        -e "s/\${DB_USER}/$DB_USER/g" \
        -e "s/\${DB_PASSWORD}/$DB_PASSWORD/g" \
        -e "s/\${JWT_SECRET}/$JWT_SECRET/g" \
        cloud-run-backend.yaml > cloud-run-backend-deploy.yaml
    
    # Deploy to Cloud Run
    gcloud run services replace cloud-run-backend-deploy.yaml --region=$REGION
    
    # Get the backend service URL
    BACKEND_SERVICE_URL=$(gcloud run services describe vin-service-checker-backend --region=$REGION --format="value(status.url)" | sed 's/https:\/\///')
    export BACKEND_SERVICE_URL
    
    print_success "Backend deployed successfully"
    print_status "Backend URL: https://$BACKEND_SERVICE_URL"
}

# Deploy frontend to Cloud Run
deploy_frontend() {
    print_status "Deploying frontend to Cloud Run..."
    
    # Replace placeholders in the YAML file
    sed -e "s/\${PROJECT_ID}/$PROJECT_ID/g" \
        -e "s/\${BACKEND_SERVICE_URL}/$BACKEND_SERVICE_URL/g" \
        cloud-run-frontend.yaml > cloud-run-frontend-deploy.yaml
    
    # Deploy to Cloud Run
    gcloud run services replace cloud-run-frontend-deploy.yaml --region=$REGION
    
    # Get the frontend service URL
    FRONTEND_SERVICE_URL=$(gcloud run services describe vin-service-checker-frontend --region=$REGION --format="value(status.url)" | sed 's/https:\/\///')
    
    print_success "Frontend deployed successfully"
    print_status "Frontend URL: https://$FRONTEND_SERVICE_URL"
}

# Set up Cloud SQL connection
setup_cloud_sql() {
    print_status "Setting up Cloud SQL connection..."
    
    # Check if Cloud SQL instance exists
    if ! gcloud sql instances describe $INSTANCE_NAME --project=$PROJECT_ID >/dev/null 2>&1; then
        print_warning "Cloud SQL instance $INSTANCE_NAME does not exist. Please create it manually or use the provided SQL setup script."
        print_status "You can create it using: gcloud sql instances create $INSTANCE_NAME --database-version=POSTGRES_15 --tier=db-f1-micro --region=$REGION"
    else
        print_success "Cloud SQL instance $INSTANCE_NAME exists"
    fi
}

# Main deployment function
main() {
    print_status "Starting Google Cloud Platform deployment..."
    
    # Check if gcloud is installed
    if ! command -v gcloud &> /dev/null; then
        print_error "gcloud CLI is not installed. Please install it first."
        exit 1
    fi
    
    # Check if user is authenticated
    if ! gcloud auth list --filter=status:ACTIVE --format="value(account)" | grep -q .; then
        print_error "You are not authenticated with gcloud. Please run 'gcloud auth login' first."
        exit 1
    fi
    
    # Set the project
    gcloud config set project $PROJECT_ID
    
    # Run deployment steps
    check_env_vars
    enable_apis
    setup_cloud_sql
    build_and_push_backend
    deploy_backend
    build_and_push_frontend
    deploy_frontend
    configure_iam_permissions
    
    print_success "Deployment completed successfully!"
    print_status "Your application is now available at:"
    print_status "Frontend: https://$FRONTEND_SERVICE_URL"
    print_status "Backend: https://$BACKEND_SERVICE_URL"
}

# Run main function
main "$@"

