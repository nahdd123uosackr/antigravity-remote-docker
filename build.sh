#!/bin/bash
# =============================================================================
# Antigravity Remote Docker - Build Script
# =============================================================================
# This script builds the Docker image for Antigravity Remote
# 
# Usage:
#   ./build.sh [OPTIONS]
#
# Options:
#   --tag, -t <name>    Specify image tag (default: antigravity-remote:latest)
#   --no-cache          Build without using cache
#   --help, -h          Show this help message
# =============================================================================

set -e

# Default values
IMAGE_TAG="antigravity-remote:latest"
BUILD_ARGS=""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -t|--tag)
            IMAGE_TAG="$2"
            shift 2
            ;;
        --no-cache)
            BUILD_ARGS="$BUILD_ARGS --no-cache"
            shift
            ;;
        -h|--help)
            echo "Usage: ./build.sh [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  -t, --tag <name>    Specify image tag (default: antigravity-remote:latest)"
            echo "  --no-cache          Build without using cache"
            echo "  -h, --help          Show this help message"
            exit 0
            ;;
        *)
            echo -e "${RED}Error: Unknown option $1${NC}"
            exit 1
            ;;
    esac
done

# Print banner
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Antigravity Remote Docker - Build${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo -e "${RED}Error: Docker is not installed${NC}"
    echo "Please install Docker from https://docs.docker.com/get-docker/"
    exit 1
fi

# Check if running with necessary permissions
if ! docker info &> /dev/null; then
    echo -e "${RED}Error: Cannot connect to Docker daemon${NC}"
    echo "Please ensure Docker is running and you have necessary permissions"
    exit 1
fi

# Display build information
echo -e "${YELLOW}Building Docker image...${NC}"
echo "Image tag: $IMAGE_TAG"
echo ""

# Build the Docker image
echo -e "${YELLOW}Starting build process (this may take several minutes)...${NC}"
if docker build $BUILD_ARGS -t "$IMAGE_TAG" .; then
    echo ""
    echo -e "${GREEN}✓ Build successful!${NC}"
    echo ""
    echo "Image created: $IMAGE_TAG"
    echo ""
    
    # Display image information
    echo -e "${YELLOW}Image information:${NC}"
    docker images "$IMAGE_TAG" --format "table {{.Repository}}\t{{.Tag}}\t{{.ID}}\t{{.Size}}\t{{.CreatedAt}}"
    echo ""
    
    # Display next steps
    echo -e "${GREEN}Next steps:${NC}"
    echo "1. Run the container:"
    echo "   docker-compose up -d"
    echo ""
    echo "2. Or run without docker-compose:"
    echo "   docker run -d --gpus all --name antigravity-remote -p 6080:6080 -p 5901:5901 $IMAGE_TAG"
    echo ""
    echo "3. Access via browser:"
    echo "   http://localhost:6080"
    echo ""
else
    echo ""
    echo -e "${RED}✗ Build failed${NC}"
    echo "Please check the error messages above for details"
    exit 1
fi
