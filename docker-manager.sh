#!/bin/bash

# VIN Service Checker Docker Manager
# This script provides easy commands to manage the Docker environment

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo -e "${BLUE}=== $1 ===${NC}"
}

# Function to check if Docker is running
check_docker() {
    if ! docker info > /dev/null 2>&1; then
        print_error "Docker is not running. Please start Docker and try again."
        exit 1
    fi
}

# Function to start production environment
start_production() {
    print_header "Starting Production Environment"
    check_docker
    docker compose up -d
    print_status "Production environment started successfully!"
    print_status "Frontend: http://localhost"
    print_status "Backend API: http://localhost:8080"
    print_status "Database Admin: http://localhost:5050"
}

# Function to start development environment
start_development() {
    print_header "Starting Development Environment"
    check_docker
    docker compose -f docker-compose.dev.yml up -d
    print_status "Development environment started successfully!"
    print_status "Frontend: http://localhost:8081 (with hot reloading)"
    print_status "Backend API: http://localhost:8080"
    print_status "Database Admin: http://localhost:5050"
}

# Function to stop all services
stop_services() {
    print_header "Stopping All Services"
    check_docker
    docker compose down
    docker compose -f docker-compose.dev.yml down
    print_status "All services stopped successfully!"
}

# Function to rebuild services
rebuild_services() {
    print_header "Rebuilding Services"
    check_docker
    
    if [ "$1" = "dev" ]; then
        docker compose -f docker-compose.dev.yml up -d --build
        print_status "Development services rebuilt successfully!"
    else
        docker compose up -d --build
        print_status "Production services rebuilt successfully!"
    fi
}

# Function to view logs
view_logs() {
    print_header "Viewing Logs"
    check_docker
    
    if [ "$1" = "dev" ]; then
        docker compose -f docker-compose.dev.yml logs -f
    else
        docker compose logs -f
    fi
}

# Function to clean up
cleanup() {
    print_header "Cleaning Up Docker Environment"
    check_docker
    
    print_warning "This will remove all containers, networks, and volumes. Are you sure? (y/N)"
    read -r response
    if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
        docker compose down -v
        docker compose -f docker-compose.dev.yml down -v
        docker system prune -f
        print_status "Cleanup completed successfully!"
    else
        print_status "Cleanup cancelled."
    fi
}

# Function to show status
show_status() {
    print_header "Service Status"
    check_docker
    
    echo "Production Services:"
    docker compose ps
    
    echo -e "\nDevelopment Services:"
    docker compose -f docker-compose.dev.yml ps
}

# Function to show help
show_help() {
    print_header "Docker Manager Help"
    echo "Usage: $0 [COMMAND]"
    echo ""
    echo "Commands:"
    echo "  start-prod     Start production environment"
    echo "  start-dev      Start development environment"
    echo "  stop           Stop all services"
    echo "  rebuild [dev]  Rebuild services (add 'dev' for development)"
    echo "  logs [dev]     View logs (add 'dev' for development)"
    echo "  status         Show service status"
    echo "  cleanup        Clean up Docker environment"
    echo "  help           Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 start-prod"
    echo "  $0 start-dev"
    echo "  $0 rebuild dev"
    echo "  $0 logs dev"
}

# Main script logic
case "$1" in
    "start-prod")
        start_production
        ;;
    "start-dev")
        start_development
        ;;
    "stop")
        stop_services
        ;;
    "rebuild")
        rebuild_services "$2"
        ;;
    "logs")
        view_logs "$2"
        ;;
    "status")
        show_status
        ;;
    "cleanup")
        cleanup
        ;;
    "help"|"--help"|"-h"|"")
        show_help
        ;;
    *)
        print_error "Unknown command: $1"
        echo ""
        show_help
        exit 1
        ;;
esac
