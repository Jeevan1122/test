# YottaSecure Docker Setup Guide

This guide will help you set up and run the entire YottaSecure application stack using Docker.

## Prerequisites

1. **Docker Desktop** - Install from [docker.com](https://docs.docker.com/get-docker/)
2. **Docker Compose** - Usually included with Docker Desktop
3. **OpenAI API Key** - Required for Rasa chatbot functionality

## Architecture Overview

The application consists of 5 main services:

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│  React Frontend │    │  Node.js Backend│    │  Rasa Chatbot   │
│  (Port 3000)    │◄──►│  (Port 3001)    │◄──►│  (Port 5005)    │
└─────────────────┘    └─────────────────┘    └─────────────────┘
                                │                       │
                                ▼                       ▼
                        ┌─────────────────┐    ┌─────────────────┐
                        │  PostgreSQL DB  │    │  Rasa Actions   │
                        │  (Port 5432)    │    │  (Port 5055)    │
                        └─────────────────┘    └─────────────────┘
```

## Quick Start

### 1. Initial Setup

```bash
# Make the setup script executable
chmod +x docker-setup.sh

# Run initial setup
./docker-setup.sh setup
```

This will:
- Check Docker installation
- Create environment file from template
- Build all Docker images
- Start all services
- Show service status

### 2. Configure Environment

Edit the `.env` file and add your OpenAI API key:

```bash
# Edit the .env file
nano .env

# Add your OpenAI API key
OPENAI_API_KEY=sk-your-actual-api-key-here
```

### 3. Restart Services

After configuring the environment:

```bash
./docker-setup.sh restart
```

## Service Management

### Start Services
```bash
./docker-setup.sh start
```

### Stop Services
```bash
./docker-setup.sh stop
```

### Check Status
```bash
./docker-setup.sh status
```

### View Logs
```bash
./docker-setup.sh logs
```

### Rebuild Images
```bash
./docker-setup.sh build
```

### Clean Up
```bash
./docker-setup.sh clean
```

## Manual Docker Commands

If you prefer using Docker Compose directly:

```bash
# Start all services
docker compose up -d

# View logs
docker compose logs -f

# Stop services
docker compose down

# Rebuild and start
docker compose up -d --build
```

## Service URLs

Once running, access the services at:

- **Frontend Application**: http://localhost:3000
- **Backend API**: http://localhost:3001
- **Rasa Chatbot**: http://localhost:5005
- **Rasa Actions**: http://localhost:5055
- **PostgreSQL**: localhost:5432

## Trivy Security Scanning

The backend service includes Trivy for container security scanning. It can scan Docker images for vulnerabilities.

### Example API Usage

```bash
# Run a security scan
curl -X POST http://localhost:3001/api/run-scan \
  -H "Content-Type: application/json" \
  -d '{"imageName": "nginx:latest"}'

# View scan results
curl http://localhost:3001/api/view-scan-summary
```

## Database Access

The PostgreSQL database is configured with:
- **Host**: localhost (or `db` from within containers)
- **Port**: 5432
- **Database**: rasa_db
- **Username**: rasa_user
- **Password**: rasa_123

Connect using any PostgreSQL client or the command line:

```bash
# Connect from host machine
psql -h localhost -p 5432 -U rasa_user -d rasa_db

# Connect from within a container
docker compose exec db psql -U rasa_user -d rasa_db
```

## Troubleshooting

### Common Issues

1. **Port conflicts**: If ports are already in use, modify the port mappings in `docker-compose.yml`

2. **OpenAI API Key missing**: Ensure your `.env` file contains a valid OpenAI API key

3. **Database connection issues**: Wait for the database to be fully initialized (check with `./docker-setup.sh status`)

4. **Memory issues**: Increase Docker Desktop memory allocation in settings

### Checking Logs

```bash
# All services
docker compose logs

# Specific service
docker compose logs backend
docker compose logs rasa
docker compose logs frontend
```

### Resetting Everything

```bash
# Stop and remove everything
./docker-setup.sh clean

# Start fresh
./docker-setup.sh setup
```

## Development vs Production

This setup is optimized for development. For production deployment:

1. Use production-grade web servers (nginx for frontend)
2. Implement proper secrets management
3. Use external managed databases
4. Add monitoring and logging
5. Implement proper SSL/TLS certificates
6. Use container orchestration (Kubernetes)

## File Structure

```
├── docker-compose.yml          # Main orchestration file
├── Dockerfile.frontend         # React app containerization
├── nginx.conf                  # Nginx configuration for frontend
├── Backend/
│   └── Dockerfile             # Node.js backend containerization
├── rasa-chatbot/
│   └── Dockerfile             # Rasa containerization
├── .dockerignore              # Global Docker ignore rules
├── Backend/.dockerignore      # Backend-specific ignore rules
├── rasa-chatbot/.dockerignore # Rasa-specific ignore rules
├── env.example                # Environment template
├── docker-setup.sh           # Setup and management script
└── DOCKER_SETUP.md           # This documentation
```

## Support

For issues or questions:
1. Check the logs using `./docker-setup.sh logs`
2. Verify all services are running with `./docker-setup.sh status`
3. Review this documentation
4. Contact the development team
