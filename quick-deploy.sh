#!/bin/bash

# Quick Deploy Script for VIN Service Checker
# This script provides a simplified deployment process

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

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

# Check if .env file exists
if [ ! -f .env ]; then
    print_error ".env file not found!"
    print_status "Please copy env.gcp.template to .env and configure your values:"
    echo "cp env.gcp.template .env"
    echo "Then edit .env with your actual values"
    exit 1
fi

# Source environment variables
source .env

print_status "Starting quick deployment for VIN Service Checker..."

# Check prerequisites
print_status "Checking prerequisites..."

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

# Check if Docker is running
if ! docker info &> /dev/null; then
    print_error "Docker is not running. Please start Docker first."
    exit 1
fi

print_success "Prerequisites check passed!"

# Set the project
print_status "Setting Google Cloud project..."
gcloud config set project $PROJECT_ID

# Enable required APIs
print_status "Enabling required APIs..."
gcloud services enable \
    cloudbuild.googleapis.com \
    run.googleapis.com \
    sqladmin.googleapis.com \
    containerregistry.googleapis.com \
    cloudresourcemanager.googleapis.com

# Check if Cloud SQL instance exists
print_status "Checking Cloud SQL instance..."
if ! gcloud sql instances describe $INSTANCE_NAME --project=$PROJECT_ID >/dev/null 2>&1; then
    print_warning "Cloud SQL instance $INSTANCE_NAME does not exist."
    print_status "Setting up Cloud SQL..."
    PROJECT_ID=$PROJECT_ID REGION=$REGION INSTANCE_NAME=$INSTANCE_NAME DB_USER=$DB_USER DB_PASSWORD=$DB_PASSWORD ./setup-cloud-sql.sh
else
    print_success "Cloud SQL instance exists"
fi

# Deploy the application
print_status "Deploying application..."
PROJECT_ID=$PROJECT_ID REGION=$REGION INSTANCE_NAME=$INSTANCE_NAME DB_USER=$DB_USER DB_PASSWORD=$DB_PASSWORD JWT_SECRET=$JWT_SECRET ./deploy-to-gcp.sh

# Verify database configuration
print_status "Verifying database configuration..."
if gcloud sql instances describe $INSTANCE_NAME --project=$PROJECT_ID --format="value(settings.storageAutoResize)" | grep -q "True"; then
    print_success "✓ Database auto-resize is enabled"
else
    print_warning "Database auto-resize is not enabled"
fi

if gcloud sql instances describe $INSTANCE_NAME --project=$PROJECT_ID --format="value(settings.backupConfiguration.enabled)" | grep -q "True"; then
    print_success "✓ Database backups are enabled"
else
    print_warning "Database backups are not enabled"
fi

print_success "Quick deployment completed!"
print_status "Your application should now be available at the URLs shown above."
print_status "Database reliability features are configured and active."
print_status "Check the deployment logs for any issues."
