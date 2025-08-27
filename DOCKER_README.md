# VIN Service Checker - Docker Setup

This document explains how to run the VIN Service Checker application using Docker.

## Architecture

The application consists of:
- **Frontend**: Vue.js application served by Nginx
- **Backend**: Spring Boot application
- **Database**: PostgreSQL
- **Admin Tool**: Adminer (optional, for database management)

## Prerequisites

- Docker
- Docker Compose

## Quick Start

### Production Mode

1. **Clone the repository** (if not already done):
   ```bash
   git clone <repository-url>
   cd vin-service-checker
   ```

2. **Start all services**:
   ```bash
   docker-compose up -d
   ```

3. **Access the application**:
   - Frontend: http://localhost
   - Backend API: http://localhost:8080
   - Database Admin: http://localhost:5050

### Development Mode

1. **Start development environment**:
   ```bash
   docker-compose -f docker-compose.dev.yml up -d
   ```

2. **Access the application**:
   - Frontend: http://localhost:8081 (with hot reloading)
   - Backend API: http://localhost:8080
   - Database Admin: http://localhost:5050

## Services

### Frontend (Port 80/8081)
- **Production**: Nginx serves the built Vue.js application
- **Development**: Vue CLI development server with hot reloading
- **Features**: 
  - Vue Router history mode support
  - Static asset caching
  - Gzip compression
  - Security headers

### Backend (Port 8080)
- **Technology**: Spring Boot with JWT authentication
- **Database**: PostgreSQL
- **Features**:
  - RESTful API
  - JWT token authentication
  - Health checks
  - Automatic database migration

### Database (Port 5432)
- **Technology**: PostgreSQL 15
- **Features**:
  - Persistent data storage
  - Health checks
  - Automatic restart

### Adminer (Port 5050)
- **Purpose**: Database administration tool
- **Access**: http://localhost:5050
- **Credentials**: 
  - System: PostgreSQL
  - Server: db
  - Username: root
  - Password: admin
  - Database: postgres

## Environment Variables

### Frontend
- `VUE_APP_API_URL`: Backend API URL (default: http://localhost:8080)

### Backend
- `SPRING_DATASOURCE_URL`: Database connection URL
- `SPRING_DATASOURCE_USERNAME`: Database username
- `SPRING_DATASOURCE_PASSWORD`: Database password
- `SPRING_JPA_HIBERNATE_DDL_AUTO`: Database schema update mode
- `JWT_SECRET`: JWT signing secret

### Database
- `POSTGRES_USER`: Database username
- `POSTGRES_PASSWORD`: Database password
- `POSTGRES_DB`: Database name

## Useful Commands

### Start Services
```bash
# Production
docker-compose up -d

# Development
docker-compose -f docker-compose.dev.yml up -d
```

### Stop Services
```bash
# Production
docker-compose down

# Development
docker-compose -f docker-compose.dev.yml down
```

### View Logs
```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f frontend
docker-compose logs -f backend
docker-compose logs -f db
```

### Rebuild Services
```bash
# Production
docker-compose up -d --build

# Development
docker-compose -f docker-compose.dev.yml up -d --build
```

### Clean Up
```bash
# Stop and remove containers, networks
docker-compose down

# Stop and remove containers, networks, volumes
docker-compose down -v

# Remove all unused containers, networks, images
docker system prune -a
```

## Development Workflow

1. **Start development environment**:
   ```bash
   docker-compose -f docker-compose.dev.yml up -d
   ```

2. **Make changes to the code**:
   - Frontend changes will automatically reload
   - Backend changes require rebuilding the container

3. **Rebuild backend after changes**:
   ```bash
   docker-compose -f docker-compose.dev.yml up -d --build backend
   ```

4. **View logs for debugging**:
   ```bash
   docker-compose -f docker-compose.dev.yml logs -f frontend-dev
   docker-compose -f docker-compose.dev.yml logs -f backend
   ```

## Production Deployment

1. **Set environment variables** (optional):
   ```bash
   export JWT_SECRET=your-secure-jwt-secret
   ```

2. **Start production services**:
   ```bash
   docker-compose up -d
   ```

3. **Verify all services are running**:
   ```bash
   docker-compose ps
   ```

4. **Check health status**:
   ```bash
   curl http://localhost:8080/actuator/health
   ```

## Troubleshooting

### Frontend Issues
- **Port already in use**: Change the port mapping in docker-compose.yml
- **API connection errors**: Check if backend is running and accessible
- **Build errors**: Check Docker logs for specific error messages

### Backend Issues
- **Database connection errors**: Ensure PostgreSQL container is running
- **JWT errors**: Check JWT_SECRET environment variable
- **Port conflicts**: Change port mapping if needed

### Database Issues
- **Connection refused**: Check if PostgreSQL container is healthy
- **Data persistence**: Ensure volumes are properly configured
- **Permission errors**: Check database credentials

### General Issues
- **Container won't start**: Check Docker logs for error messages
- **Network issues**: Ensure Docker network is created properly
- **Resource constraints**: Increase Docker memory/CPU limits if needed

## Security Considerations

1. **Change default passwords** in production
2. **Use strong JWT secrets**
3. **Configure proper firewall rules**
4. **Use HTTPS in production**
5. **Regular security updates**

## Performance Optimization

1. **Use production Docker images**
2. **Configure proper resource limits**
3. **Enable Docker layer caching**
4. **Use multi-stage builds**
5. **Optimize Nginx configuration**

## Monitoring

- **Health checks**: Built into all services
- **Logs**: Available via `docker-compose logs`
- **Metrics**: Backend exposes actuator endpoints
- **Database**: Use Adminer for database monitoring
