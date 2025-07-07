.PHONY: help test test-local validate lint format clean install-deps setup-hooks create-feature \
         version-bump version-check version-list version-patch version-minor version-major \
         changelog

# Default target
help: ## Show this help message
	@echo "DevContainer Features Development Commands"
	@echo "========================================"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

# Installation and setup
install-deps: ## Install required dependencies
	@echo "Installing dependencies..."
	@which npm > /dev/null || (echo "npm is required but not installed" && exit 1)
	@which jq > /dev/null || (echo "jq is required but not installed" && exit 1)
	@which docker > /dev/null || (echo "docker is required but not installed" && exit 1)
	npm install -g @devcontainers/cli
	@echo "✅ Dependencies installed"

setup-hooks: ## Setup git pre-commit hooks
	@echo "Setting up git hooks..."
	@[ -d .git ] || (echo "Not a git repository" && exit 1)
	ln -sf ../../scripts/pre-commit.sh .git/hooks/pre-commit
	chmod +x .git/hooks/pre-commit
	@echo "✅ Pre-commit hooks installed"

# Testing commands
test: ## Run all tests in CI-like environment
	@echo "Running all tests..."
	./scripts/test-local.sh

test-local: ## Run tests locally with verbose output
	@echo "Running local tests..."
	./scripts/test-local.sh

test-feature: ## Test a specific feature (usage: make test-feature FEATURE=alpine-git)
	@if [ -z "$(FEATURE)" ]; then \
		echo "Please specify a feature: make test-feature FEATURE=alpine-git"; \
		exit 1; \
	fi
	./scripts/test-local.sh $(FEATURE)

# Validation commands
validate: ## Validate all features structure and JSON syntax
	@echo "Validating features..."
	@for feature in src/*/; do \
		if [ -d "$$feature" ]; then \
			feature_name=$$(basename "$$feature"); \
			echo "Validating $$feature_name..."; \
			if [ ! -f "$$feature/devcontainer-feature.json" ]; then \
				echo "❌ Missing devcontainer-feature.json in $$feature_name"; \
				exit 1; \
			fi; \
			if [ ! -f "$$feature/install.sh" ]; then \
				echo "❌ Missing install.sh in $$feature_name"; \
				exit 1; \
			fi; \
			if ! jq . "$$feature/devcontainer-feature.json" >/dev/null 2>&1; then \
				echo "❌ Invalid JSON in $$feature_name/devcontainer-feature.json"; \
				exit 1; \
			fi; \
			echo "✅ $$feature_name is valid"; \
		fi; \
	done
	@echo "✅ All features validated"

lint: ## Lint shell scripts using shellcheck
	@echo "Linting shell scripts..."
	@if command -v shellcheck >/dev/null 2>&1; then \
		find . -name "*.sh" -exec shellcheck {} \; && echo "✅ All shell scripts passed linting"; \
	else \
		echo "⚠️  shellcheck not found, skipping shell script linting"; \
	fi

format: ## Format JSON files
	@echo "Formatting JSON files..."
	@find src/ -name "*.json" -exec jq '.' {} \; > /dev/null
	@find test/ -name "*.json" -exec jq '.' {} \; > /dev/null
	@echo "✅ JSON files formatted"

# Development commands
create-feature: ## Create a new feature (usage: make create-feature NAME=alpine-rust DESC="Install Rust")
	@if [ -z "$(NAME)" ]; then \
		echo "Please specify a feature name: make create-feature NAME=alpine-rust DESC=\"Install Rust\""; \
		exit 1; \
	fi
	@if [ -z "$(DESC)" ]; then \
		./scripts/create-feature.sh $(NAME); \
	else \
		./scripts/create-feature.sh $(NAME) "$(DESC)"; \
	fi

# Documentation
generate-docs: ## Generate documentation for all features
	@echo "Generating documentation..."
	@if command -v devcontainer >/dev/null 2>&1; then \
		devcontainer features generate-docs -n sarigiannidis/features -p ./src/; \
		echo "✅ Documentation generated"; \
	else \
		echo "❌ devcontainer CLI not found. Please install it first: make install-deps"; \
		exit 1; \
	fi

# Cleanup
clean: ## Clean up temporary files and containers
	@echo "Cleaning up..."
	@docker system prune -f --volumes || true
	@echo "✅ Cleanup completed"

# CI/CD helpers
ci-test: validate lint test ## Run all CI checks locally

# Quick development workflow
dev: validate test-local ## Quick development workflow: validate and test

# Show feature list
list-features: ## List all available features
	@echo "Available features:"
	@echo "=================="
	@for feature in src/*/; do \
		if [ -d "$$feature" ]; then \
			feature_name=$$(basename "$$feature"); \
			if [ -f "$$feature/devcontainer-feature.json" ]; then \
				description=$$(jq -r '.description // .name' "$$feature/devcontainer-feature.json" 2>/dev/null || echo "No description"); \
				printf "%-20s %s\n" "$$feature_name" "$$description"; \
			else \
				printf "%-20s %s\n" "$$feature_name" "❌ Invalid feature"; \
			fi; \
		fi; \
	done

# Version management
version-list: ## List all features and their current versions
	@./scripts/bump-version.sh list

version-check: ## Check version consistency and format
	@./scripts/check-versions.sh --verbose

version-fix: ## Automatically fix common version issues
	@./scripts/check-versions.sh --fix

version-patch: ## Bump patch version for all features (usage: make version-patch [FEATURE=name])
	@if [ -n "$(FEATURE)" ]; then \
		./scripts/bump-version.sh patch $(FEATURE); \
	else \
		./scripts/bump-version.sh patch; \
	fi

version-minor: ## Bump minor version for all features (usage: make version-minor [FEATURE=name])
	@if [ -n "$(FEATURE)" ]; then \
		./scripts/bump-version.sh minor $(FEATURE); \
	else \
		./scripts/bump-version.sh minor; \
	fi

version-major: ## Bump major version for all features (usage: make version-major [FEATURE=name])
	@if [ -n "$(FEATURE)" ]; then \
		./scripts/bump-version.sh major $(FEATURE); \
	else \
		./scripts/bump-version.sh major; \
	fi

version-report: ## Generate a version report
	@./scripts/check-versions.sh --report

# Documentation and changelog
changelog: ## Generate changelog from git history
	@./scripts/generate-changelog.sh

changelog-since: ## Generate changelog since specific tag (usage: make changelog-since TAG=v1.0.0)
	@if [ -z "$(TAG)" ]; then \
		echo "Please specify a tag: make changelog-since TAG=v1.0.0"; \
		exit 1; \
	fi
	@./scripts/generate-changelog.sh --since $(TAG)
