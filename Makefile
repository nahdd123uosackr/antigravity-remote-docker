# =============================================================================
# Antigravity Remote Docker - Makefile
# =============================================================================
# Convenient commands for building and managing the Docker image
# =============================================================================

.PHONY: help build build-no-cache run stop restart logs clean shell test

# Default image tag
IMAGE_TAG ?= antigravity-remote:latest
CONTAINER_NAME ?= antigravity-remote

# Colors
GREEN  := \033[0;32m
YELLOW := \033[1;33m
NC     := \033[0m # No Color

help: ## Show this help message
	@echo "$(GREEN)Antigravity Remote Docker - Available Commands$(NC)"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(YELLOW)%-15s$(NC) %s\n", $$1, $$2}'
	@echo ""

build: ## Build the Docker image
	@echo "$(GREEN)Building Docker image: $(IMAGE_TAG)$(NC)"
	docker build -t $(IMAGE_TAG) .
	@echo "$(GREEN)✓ Build complete!$(NC)"

build-no-cache: ## Build the Docker image without cache
	@echo "$(GREEN)Building Docker image (no cache): $(IMAGE_TAG)$(NC)"
	docker build --no-cache -t $(IMAGE_TAG) .
	@echo "$(GREEN)✓ Build complete!$(NC)"

up: ## Start the container using docker-compose
	@echo "$(GREEN)Starting container...$(NC)"
	docker-compose up -d
	@echo "$(GREEN)✓ Container started!$(NC)"
	@echo "Access at: http://localhost:6080"

down: ## Stop and remove the container using docker-compose
	@echo "$(YELLOW)Stopping container...$(NC)"
	docker-compose down

run: build ## Build and run the container
	@echo "$(GREEN)Starting container...$(NC)"
	docker-compose up -d
	@echo "$(GREEN)✓ Container started!$(NC)"
	@echo "Access at: http://localhost:6080"

stop: ## Stop the running container
	@echo "$(YELLOW)Stopping container...$(NC)"
	docker-compose stop

restart: ## Restart the container
	@echo "$(YELLOW)Restarting container...$(NC)"
	docker-compose restart
	@echo "$(GREEN)✓ Container restarted!$(NC)"

logs: ## Show container logs
	docker-compose logs -f

status: ## Show container status
	@docker-compose ps

shell: ## Open a shell in the running container
	docker-compose exec antigravity /bin/bash

clean: ## Remove container and image
	@echo "$(YELLOW)Cleaning up...$(NC)"
	docker-compose down -v
	docker rmi $(IMAGE_TAG) 2>/dev/null || true
	@echo "$(GREEN)✓ Cleanup complete!$(NC)"

prune: ## Remove all unused Docker resources
	@echo "$(YELLOW)Pruning Docker resources...$(NC)"
	docker system prune -a --volumes
	@echo "$(GREEN)✓ Prune complete!$(NC)"

info: ## Show image information
	@echo "$(GREEN)Image Information:$(NC)"
	@docker images $(IMAGE_TAG) --format "table {{.Repository}}\t{{.Tag}}\t{{.ID}}\t{{.Size}}\t{{.CreatedAt}}" 2>/dev/null || echo "Image not found. Run 'make build' first."

test: ## Test if the container is running properly
	@echo "$(GREEN)Testing container health...$(NC)"
	@curl -f http://localhost:6080/ > /dev/null 2>&1 && echo "$(GREEN)✓ Container is healthy!$(NC)" || echo "$(YELLOW)⚠ Container may not be running or healthy$(NC)"

# Development helpers
dev-up: ## Start container in development mode (with build)
	docker-compose up --build

dev-logs: ## Follow logs in real-time
	docker-compose logs -f antigravity

# Quick commands
build-run: build up ## Build and run in one command
rebuild: clean build up ## Clean, build, and run in one command
