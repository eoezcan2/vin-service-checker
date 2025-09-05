#!/bin/bash

# Cloud SQL Setup Script for VIN Service Checker
# This script creates and configures the Cloud SQL instance

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
    
    required_vars=("PROJECT_ID" "REGION" "INSTANCE_NAME" "DB_USER" "DB_PASSWORD")
    
    for var in "${required_vars[@]}"; do
        if [ -z "${!var}" ]; then
            print_error "Environment variable $var is not set"
            exit 1
        fi
    done
    
    print_success "All required environment variables are set"
}

# Create Cloud SQL instance
create_sql_instance() {
    print_status "Creating Cloud SQL instance..."
    
    # Check if instance already exists
    if gcloud sql instances describe $INSTANCE_NAME --project=$PROJECT_ID >/dev/null 2>&1; then
        print_warning "Cloud SQL instance $INSTANCE_NAME already exists"
        return 0
    fi
    
    # Create the instance
    gcloud sql instances create $INSTANCE_NAME \
        --project=$PROJECT_ID \
        --database-version=POSTGRES_15 \
        --tier=db-f1-micro \
        --region=$REGION \
        --storage-type=SSD \
        --storage-size=10GB \
        --backup-start-time=02:00 \
        --maintenance-window-day=SUN \
        --maintenance-window-hour=03 \
        --availability-type=zonal
    
    print_success "Cloud SQL instance created successfully"
}

# Create database user
create_database_user() {
    print_status "Creating database user..."
    
    # Check if user already exists
    if gcloud sql users list --instance=$INSTANCE_NAME --project=$PROJECT_ID | grep -q $DB_USER; then
        print_warning "Database user $DB_USER already exists"
        return 0
    fi
    
    # Create the user
    gcloud sql users create $DB_USER \
        --instance=$INSTANCE_NAME \
        --project=$PROJECT_ID \
        --password=$DB_PASSWORD
    
    print_success "Database user created successfully"
}

# Create database
create_database() {
    print_status "Creating database..."
    
    # Check if database already exists
    if gcloud sql databases list --instance=$INSTANCE_NAME --project=$PROJECT_ID | grep -q postgres; then
        print_warning "Database 'postgres' already exists"
        return 0
    fi
    
    # Create the database
    gcloud sql databases create postgres \
        --instance=$INSTANCE_NAME \
        --project=$PROJECT_ID
    
    print_success "Database created successfully"
}

# Configure instance settings
configure_instance() {
    print_status "Configuring instance settings..."
    
    # Enable Cloud SQL Admin API
    gcloud services enable sqladmin.googleapis.com --project=$PROJECT_ID
    
    # Configure instance settings
    gcloud sql instances patch $INSTANCE_NAME \
        --project=$PROJECT_ID \
        --authorized-networks=0.0.0.0/0 \
        --require-ssl=false
    
    print_success "Instance configured successfully"
}

# Get connection information
get_connection_info() {
    print_status "Getting connection information..."
    
    # Get the instance connection name
    INSTANCE_CONNECTION_NAME=$(gcloud sql instances describe $INSTANCE_NAME --project=$PROJECT_ID --format="value(connectionName)")
    
    print_success "Cloud SQL setup completed successfully!"
    print_status "Instance Connection Name: $INSTANCE_CONNECTION_NAME"
    print_status "Database: postgres"
    print_status "User: $DB_USER"
    print_status "Instance: $INSTANCE_NAME"
    print_status "Region: $REGION"
    
    echo ""
    print_status "Connection string for your application:"
    echo "jdbc:postgresql:///postgres?cloudSqlInstance=$INSTANCE_CONNECTION_NAME&socketFactory=com.google.cloud.sql.postgres.SocketFactory"
}

# Main setup function
main() {
    print_status "Starting Cloud SQL setup..."
    
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
    
    # Run setup steps
    check_env_vars
    create_sql_instance
    create_database_user
    create_database
    configure_instance
    get_connection_info
    
    print_success "Cloud SQL setup completed!"
}

# Run main function
main "$@"
