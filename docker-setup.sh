#!/bin/bash
# YottaSecure Docker Setup Script
# This script helps you set up and manage your Docker environment

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🔧 YottaSecure Docker Setup${NC}"
echo "=================================="

# Check if Docker is installed and running
check_docker() {
    if ! command -v docker &> /dev/null; then
        echo -e "${RED}❌ Docker is not installed. Please install Docker first.${NC}"
        echo "Visit: https://docs.docker.com/get-docker/"
        exit 1
    fi

    if ! docker info &> /dev/null; then
        echo -e "${RED}❌ Docker is not running. Please start Docker.${NC}"
        exit 1
    fi

    echo -e "${GREEN}✅ Docker is installed and running${NC}"
}

# Check if Docker Compose is available
check_docker_compose() {
    if docker compose version &> /dev/null; then
        DOCKER_COMPOSE_CMD="docker compose"
    elif docker-compose --version &> /dev/null; then
        DOCKER_COMPOSE_CMD="docker-compose"
    else
        echo -e "${RED}❌ Docker Compose is not available. Please install Docker Compose.${NC}"
        exit 1
    fi

    echo -e "${GREEN}✅ Docker Compose is available${NC}"
}

# Setup environment file
setup_env() {
    if [ ! -f ".env" ]; then
        if [ -f "env.example" ]; then
            cp env.example .env
            echo -e "${YELLOW}📝 Created .env file from env.example${NC}"
            echo -e "${YELLOW}⚠️  Please edit .env file and add your OPENAI_API_KEY${NC}"
        else
            echo -e "${RED}❌ env.example file not found${NC}"
            exit 1
        fi
    else
        echo -e "${GREEN}✅ .env file already exists${NC}"
    fi

    # Check if OPENAI_API_KEY is set
    if ! grep -q "^OPENAI_API_KEY=sk-" .env 2>/dev/null; then
        echo -e "${YELLOW}⚠️  OPENAI_API_KEY not configured in .env file${NC}"
        echo "Please edit .env file and add your OpenAI API key"
    fi
}

# Build and start services
start_services() {
    echo -e "${BLUE}🏗️  Building Docker images...${NC}"
    $DOCKER_COMPOSE_CMD build

    echo -e "${BLUE}🚀 Starting services...${NC}"
    $DOCKER_COMPOSE_CMD up -d

    echo -e "${GREEN}✅ Services started successfully!${NC}"
}

# Show service status
show_status() {
    echo -e "${BLUE}📊 Service Status:${NC}"
    $DOCKER_COMPOSE_CMD ps

    echo -e "\n${BLUE}🌐 Service URLs:${NC}"
    echo "• Frontend:      http://localhost:3000"
    echo "• Backend API:   http://localhost:3001"
    echo "• Rasa Server:   http://localhost:5005"
    echo "• Rasa Actions:  http://localhost:5055"
    echo "• PostgreSQL:    localhost:5432"
}

# Show logs
show_logs() {
    echo -e "${BLUE}📋 Recent logs:${NC}"
    $DOCKER_COMPOSE_CMD logs --tail=50
}

# Stop services
stop_services() {
    echo -e "${YELLOW}🛑 Stopping services...${NC}"
    $DOCKER_COMPOSE_CMD down
    echo -e "${GREEN}✅ Services stopped${NC}"
}

# Clean up
cleanup() {
    echo -e "${YELLOW}🧹 Cleaning up Docker resources...${NC}"
    $DOCKER_COMPOSE_CMD down -v --remove-orphans
    docker system prune -f
    echo -e "${GREEN}✅ Cleanup completed${NC}"
}

# Main menu
show_menu() {
    echo -e "\n${BLUE}Available commands:${NC}"
    echo "1. setup   - Initial setup and start services"
    echo "2. start   - Start all services"
    echo "3. stop    - Stop all services"
    echo "4. restart - Restart all services"
    echo "5. status  - Show service status"
    echo "6. logs    - Show service logs"
    echo "7. build   - Rebuild Docker images"
    echo "8. clean   - Stop services and clean up"
    echo "9. help    - Show this menu"
}

# Main script logic
case "${1:-help}" in
    "setup")
        check_docker
        check_docker_compose
        setup_env
        start_services
        show_status
        ;;
    "start")
        check_docker
        check_docker_compose
        start_services
        show_status
        ;;
    "stop")
        stop_services
        ;;
    "restart")
        check_docker
        check_docker_compose
        stop_services
        start_services
        show_status
        ;;
    "status")
        show_status
        ;;
    "logs")
        show_logs
        ;;
    "build")
        check_docker
        check_docker_compose
        echo -e "${BLUE}🏗️  Rebuilding Docker images...${NC}"
        $DOCKER_COMPOSE_CMD build --no-cache
        ;;
    "clean")
        cleanup
        ;;
    "help"|*)
        show_menu
        ;;
esac
