# Google Cloud Platform Deployment Guide

This guide will help you deploy the VIN Service Checker application to Google Cloud Platform using Cloud Run and Cloud SQL.

## Prerequisites

1. **Google Cloud Account**: You need a Google Cloud account with billing enabled
2. **Google Cloud CLI**: Install the [gcloud CLI](https://cloud.google.com/sdk/docs/install)
3. **Docker**: Install [Docker](https://docs.docker.com/get-docker/) for building images
4. **Git**: Clone this repository

## Architecture

The application will be deployed with the following architecture:

- **Frontend**: Vue.js application deployed to Cloud Run
- **Backend**: Spring Boot application deployed to Cloud Run
- **Database**: PostgreSQL database hosted on Cloud SQL
- **Container Registry**: Google Container Registry for storing Docker images

## Step 1: Initial Setup

### 1.1 Install and Configure gcloud CLI

```bash
# Install gcloud CLI (if not already installed)
# Follow instructions at: https://cloud.google.com/sdk/docs/install

# Authenticate with Google Cloud
gcloud auth login

# Set your project ID
gcloud config set project YOUR_PROJECT_ID
```

### 1.2 Enable Required APIs

```bash
gcloud services enable \
    cloudbuild.googleapis.com \
    run.googleapis.com \
    sqladmin.googleapis.com \
    containerregistry.googleapis.com \
    cloudresourcemanager.googleapis.com
```

## Step 2: Environment Configuration

### 2.1 Create Environment File

Copy the environment template and configure your values:

```bash
cp env.gcp.template .env
```

Edit the `.env` file with your actual values:

```bash
# Google Cloud Project Configuration
PROJECT_ID=your-actual-project-id
REGION=us-central1
INSTANCE_NAME=vin-service-checker-db

# Database Configuration
DB_USER=vin_service_user
DB_PASSWORD=your-secure-database-password

# Security Configuration
JWT_SECRET=your-super-secure-jwt-secret-minimum-64-characters-long
```

### 2.2 Generate Secure Values

```bash
# Generate a secure JWT secret
openssl rand -base64 64

# Generate a secure database password
openssl rand -base64 32
```

## Step 3: Database Setup

### 3.1 Set Up Cloud SQL

Run the Cloud SQL setup script:

```bash
# Source your environment variables
source .env

# Run the setup script
./setup-cloud-sql.sh
```

This script will:
- Create a Cloud SQL PostgreSQL instance
- Create a database user
- Create the postgres database
- Configure the instance for Cloud Run connectivity

### 3.2 Verify Database Setup

```bash
# Check if the instance was created
gcloud sql instances list --project=$PROJECT_ID

# Check if the user was created
gcloud sql users list --instance=$INSTANCE_NAME --project=$PROJECT_ID

# Check if the database was created
gcloud sql databases list --instance=$INSTANCE_NAME --project=$PROJECT_ID
```

## Step 4: Build and Deploy

### 4.1 Deploy the Application

Run the deployment script:

```bash
# Source your environment variables
source .env

# Run the deployment script
./deploy-to-gcp.sh
```

This script will:
- Build Docker images for frontend and backend
- Push images to Google Container Registry
- Deploy the backend to Cloud Run
- Deploy the frontend to Cloud Run
- Configure the services with proper environment variables

### 4.2 Verify Deployment

```bash
# List Cloud Run services
gcloud run services list --region=$REGION

# Get service URLs
gcloud run services describe vin-service-checker-frontend --region=$REGION --format="value(status.url)"
gcloud run services describe vin-service-checker-backend --region=$REGION --format="value(status.url)"
```

## Step 5: Post-Deployment Configuration

### 5.1 Configure CORS (if needed)

If you encounter CORS issues, you may need to update the backend CORS configuration in `SecurityConfig.java`.

### 5.2 Set Up Custom Domain (Optional)

If you want to use a custom domain:

1. **Map Custom Domain**:
   ```bash
   gcloud run domain-mappings create --service=vin-service-checker-frontend --domain=your-domain.com --region=$REGION
   ```

2. **Configure DNS**: Point your domain to the Cloud Run service

### 5.3 Set Up SSL Certificate

Cloud Run automatically provides SSL certificates for all services.

## Step 6: Monitoring and Maintenance

### 6.1 View Logs

```bash
# View frontend logs
gcloud logging read "resource.type=cloud_run_revision AND resource.labels.service_name=vin-service-checker-frontend" --limit=50

# View backend logs
gcloud logging read "resource.type=cloud_run_revision AND resource.labels.service_name=vin-service-checker-backend" --limit=50
```

### 6.2 Monitor Performance

- Use Google Cloud Console to monitor Cloud Run performance
- Set up alerts for errors and performance issues
- Monitor Cloud SQL performance and storage usage

### 6.3 Backup Strategy

Cloud SQL automatically creates daily backups. You can also create manual backups:

```bash
gcloud sql backups create --instance=$INSTANCE_NAME --project=$PROJECT_ID
```

## Step 7: Scaling and Optimization

### 7.1 Auto-scaling Configuration

The Cloud Run services are configured with auto-scaling:
- **Frontend**: 0-1000 instances, CPU-based scaling
- **Backend**: 0-1000 instances, CPU-based scaling

### 7.2 Performance Optimization

- **Database**: Monitor query performance and add indexes as needed
- **Caching**: Consider implementing Redis for session management
- **CDN**: Use Cloud CDN for static assets

## Troubleshooting

### Common Issues

1. **Database Connection Issues**:
   - Verify Cloud SQL instance is running
   - Check connection string format
   - Ensure proper IAM permissions

2. **CORS Issues**:
   - Update CORS configuration in backend
   - Verify frontend API URL is correct

3. **Authentication Issues**:
   - Check JWT secret configuration
   - Verify environment variables are set correctly

4. **Build Failures**:
   - Check Docker build logs
   - Verify all dependencies are available
   - Ensure sufficient disk space

### Debug Commands

```bash
# Check service status
gcloud run services describe vin-service-checker-backend --region=$REGION

# View recent logs
gcloud logging read "resource.type=cloud_run_revision" --limit=10

# Check database connectivity
gcloud sql connect $INSTANCE_NAME --user=$DB_USER --project=$PROJECT_ID
```

## Cost Optimization

### Estimated Monthly Costs (US Central)

- **Cloud Run**: ~$5-20/month (depending on usage)
- **Cloud SQL**: ~$25/month (db-f1-micro instance)
- **Container Registry**: ~$1-5/month (depending on image size)
- **Total**: ~$30-50/month

### Cost Reduction Tips

1. **Use Cloud Run's scale-to-zero**: Services scale to zero when not in use
2. **Optimize database**: Use appropriate instance size
3. **Clean up unused images**: Regularly clean up old Docker images
4. **Monitor usage**: Set up billing alerts

## Security Considerations

1. **Environment Variables**: Never commit sensitive data to version control
2. **Database Security**: Use strong passwords and limit access
3. **Network Security**: Cloud Run services are secure by default
4. **IAM Permissions**: Follow principle of least privilege

## Maintenance

### Regular Tasks

1. **Update Dependencies**: Regularly update application dependencies
2. **Security Patches**: Keep Docker images and dependencies updated
3. **Database Maintenance**: Monitor and optimize database performance
4. **Backup Verification**: Test backup restoration procedures

### Update Deployment

To update the application:

```bash
# Source environment variables
source .env

# Run deployment script (it will update existing services)
./deploy-to-gcp.sh
```

## Support

For issues related to:
- **Google Cloud**: Check [Google Cloud Documentation](https://cloud.google.com/docs)
- **Application**: Check the application logs and error messages
- **Deployment**: Review the deployment script output

## Additional Resources

- [Cloud Run Documentation](https://cloud.google.com/run/docs)
- [Cloud SQL Documentation](https://cloud.google.com/sql/docs)
- [Container Registry Documentation](https://cloud.google.com/container-registry/docs)
- [Google Cloud Pricing Calculator](https://cloud.google.com/products/calculator)

