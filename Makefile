# Makefile for env-script testing

.PHONY: help build test-all test-single test-single-all test-all-single clean interactive shell build-scripts logs results

# Default target
help:
	@echo "Available commands:"
	@echo "  build           - Build all Docker images"
	@echo "  test-all        - Run all tests in all environments [NETWORK=in-china]"
	@echo "  test-single ENV=environment TEST=test-file  - Run specified test in specified environment [NETWORK=in-china]"
	@echo "  test-single-all TEST=test-file             - Run specified test in all environments [NETWORK=in-china]"
	@echo "  test-all-single ENV=environment           - Run all tests in specified environment [NETWORK=in-china]"
	@echo ""
	@echo "  interactive     - Start interactive test environment"
	@echo "  shell           - Start shell in Ubuntu container"
	@echo "  clean           - Clean Docker images and containers"
	@echo "  build-scripts   - Build scripts to dist directory"
	@echo ""
	@echo "Examples:"
	@echo "  make test-all"
	@echo "  make test-all NETWORK=in-china"
	@echo "  make test-single ENV=ubuntu20-test TEST=tests/install-git/01-ok.sh"
	@echo "  make test-single ENV=ubuntu20-test TEST=tests/install-git/02-install.sh NETWORK=in-china"
	@echo "  make test-single-all TEST=tests/install-git/01-ok.sh"
	@echo "  make test-single-all TEST=tests/install-git/02-install.sh NETWORK=in-china"
	@echo "  make test-all-single ENV=ubuntu22-test"
	@echo "  make test-all-single ENV=ubuntu22-test NETWORK=in-china"

# Build scripts
build-scripts:
	@echo "Building environment scripts..."
	bash ./tools/build.sh

# Build Docker images
build: build-scripts
	@echo "Building Docker images..."
	docker-compose -f docker/docker-compose.yml build

# Run tests in all environments
test-all: build-scripts
	@echo "Running tests in all environments..."
	@if [ "$(NETWORK)" = "in-china" ]; then \
		echo "Using China network configuration"; \
		NETWORK_ARG="--network in-china"; \
	else \
		NETWORK_ARG=""; \
	fi; \
	echo ""; \
	echo "==================== Ubuntu 22.04 ===================="; \
	echo ""; \
	docker-compose -f docker/docker-compose.yml run --rm ubuntu22-test /app/tools/test-runner.sh $$NETWORK_ARG; \
	echo ""; \
	echo "==================== Ubuntu 20.04 ===================="; \
	echo ""; \
	docker-compose -f docker/docker-compose.yml run --rm ubuntu20-test /app/tools/test-runner.sh $$NETWORK_ARG; \
# 	echo ""; \
# 	echo "==================== Ubuntu 24.04 ===================="; \
# 	echo ""; \
# 	docker-compose -f docker/docker-compose.yml run --rm ubuntu24-test /app/tools/test-runner.sh $$NETWORK_ARG; \
	echo ""; \
	echo "==================== Debian 11.9 Bullseye ====================="; \
	echo ""; \
	docker-compose -f docker/docker-compose.yml run --rm debian11-9-test /app/tools/test-runner.sh $$NETWORK_ARG; \
	echo ""; \
	echo "==================== Debian 12.2 Bookworm ====================="; \
	echo ""; \
	docker-compose -f docker/docker-compose.yml run --rm debian12-2-test /app/tools/test-runner.sh $$NETWORK_ARG; \
	echo ""; \
	echo "==================== Fedora 41 ======================="; \
	echo ""; \
	docker-compose -f docker/docker-compose.yml run --rm fedora41-test /app/tools/test-runner.sh $$NETWORK_ARG; \
	echo ""; \
	echo "==================== RedHat Enterprise Linux 8.10 (UBI8) ======================"; \
	echo ""; \
	docker-compose -f docker/docker-compose.yml run --rm redhat8-10-test /app/tools/test-runner.sh $$NETWORK_ARG; \
	echo ""; \
	echo "==================== RedHat Enterprise Linux 9.6 (UBI9) ======================"; \
	echo ""; \
	docker-compose -f docker/docker-compose.yml run --rm redhat9-6-test /app/tools/test-runner.sh $$NETWORK_ARG

# ======================== Advanced test commands ========================

# Scenario 1: Run specified test in specified environment
test-single: build-scripts
	@if [ -z "$(ENV)" ] || [ -z "$(TEST)" ]; then \
		echo "Usage: make test-single ENV=environment-name TEST=test-file [NETWORK=in-china]"; \
		echo "Example: make test-single ENV=ubuntu20-test TEST=tests/install-git/02-install.sh"; \
		echo "Example: make test-single ENV=ubuntu20-test TEST=tests/install-git/02-install.sh NETWORK=in-china"; \
		echo "Available environments: ubuntu22-test, ubuntu20-test, ubuntu24-test, debian11-9-test, debian12-2-test, fedora41-test, redhat8-10-test, redhat9-6-test"; \
		exit 1; \
	fi
	@echo "Running test in $(ENV) environment: $(TEST)"
	@if [ "$(NETWORK)" = "in-china" ]; then \
		echo "Using China network configuration"; \
		docker-compose -f docker/docker-compose.yml run --rm $(ENV) /app/tools/test-runner.sh --test $(TEST) --network in-china; \
	else \
		docker-compose -f docker/docker-compose.yml run --rm $(ENV) /app/tools/test-runner.sh --test $(TEST); \
	fi

# Scenario 4: Run all tests in specified environment
test-all-single: build-scripts
	@if [ -z "$(ENV)" ]; then \
		echo "Usage: make test-all-single ENV=environment-name [NETWORK=in-china]"; \
		echo "Available environments: ubuntu22-test, ubuntu20-test, ubuntu24-test, debian11-9-test, debian12-2-test, fedora41-test, redhat8-10-test, redhat9-6-test"; \
		echo "Example: make test-all-single ENV=ubuntu22-test"; \
		echo "Example: make test-all-single ENV=fedora41-test NETWORK=in-china"; \
		exit 1; \
	fi
	@echo "Running all tests in environment $(ENV)"
	@if [ "$(NETWORK)" = "in-china" ]; then \
		echo "Using China network configuration"; \
		NETWORK_ARG="--network in-china"; \
	else \
		NETWORK_ARG=""; \
	fi; \
	TOTAL_TESTS=0; \
	PASSED_TESTS=0; \
	FAILED_TESTS=0; \
	for test_file in $$(find tests -name "*.sh" -type f | sort); do \
		TOTAL_TESTS=$$((TOTAL_TESTS + 1)); \
		echo ""; \
		echo "==================== Running test: $$test_file ===================="; \
		echo ""; \
		if docker-compose -f docker/docker-compose.yml run --rm $(ENV) /app/tools/test-runner.sh --test $$test_file $$NETWORK_ARG; then \
			PASSED_TESTS=$$((PASSED_TESTS + 1)); \
		else \
			FAILED_TESTS=$$((FAILED_TESTS + 1)); \
		fi; \
	done; \
	echo ""; \
	echo "=================================="; \
	echo "📊 Test Summary Report"; \
	echo "=================================="; \
	echo "Test environment: $(ENV)"; \
	echo "Total tests: $$TOTAL_TESTS"; \
	echo "Passed tests: $$PASSED_TESTS"; \
	echo "Failed tests: $$FAILED_TESTS"; \
	if [ $$FAILED_TESTS -eq 0 ]; then \
		echo "🎉 All tests passed!"; \
		exit 0; \
	else \
		echo "❌ $$FAILED_TESTS tests failed"; \
		exit 1; \
	fi

# Scenario 3: Run specified test in all environments
test-single-all: build-scripts
	@if [ -z "$(TEST)" ]; then \
		echo "Usage: make test-single-all TEST=test-file [NETWORK=in-china]"; \
		echo "Example: make test-single-all TEST=tests/install-git/01-ok.sh"; \
		echo "Example: make test-single-all TEST=tests/install-git/02-install.sh NETWORK=in-china"; \
		exit 1; \
	fi
	@echo "Running test in all environments: $(TEST)"
	@if [ "$(NETWORK)" = "in-china" ]; then \
		echo "Using China network configuration"; \
		NETWORK_ARG="--network in-china"; \
	else \
		NETWORK_ARG=""; \
	fi; \
	TOTAL_ENVS=0; \
	PASSED_ENVS=0; \
	FAILED_ENVS=0; \
	echo ""; \
	echo "==================== Ubuntu 22.04 ===================="; \
	echo ""; \
	if docker-compose -f docker/docker-compose.yml run --rm ubuntu22-test /app/tools/test-runner.sh --test $(TEST) $$NETWORK_ARG; then \
		PASSED_ENVS=$$((PASSED_ENVS + 1)); \
	else \
		FAILED_ENVS=$$((FAILED_ENVS + 1)); \
	fi; \
	TOTAL_ENVS=$$((TOTAL_ENVS + 1)); \
	echo ""; \
	echo "==================== Ubuntu 20.04 ===================="; \
	echo ""; \
	if docker-compose -f docker/docker-compose.yml run --rm ubuntu20-test /app/tools/test-runner.sh --test $(TEST) $$NETWORK_ARG; then \
		PASSED_ENVS=$$((PASSED_ENVS + 1)); \
	else \
		FAILED_ENVS=$$((FAILED_ENVS + 1)); \
	fi; \
	TOTAL_ENVS=$$((TOTAL_ENVS + 1)); \
	echo ""; \
	echo "==================== Ubuntu 24.04 ===================="; \
	echo ""; \
	if docker-compose -f docker/docker-compose.yml run --rm ubuntu24-test /app/tools/test-runner.sh --test $(TEST) $$NETWORK_ARG; then \
		PASSED_ENVS=$$((PASSED_ENVS + 1)); \
	else \
		FAILED_ENVS=$$((FAILED_ENVS + 1)); \
	fi; \
	TOTAL_ENVS=$$((TOTAL_ENVS + 1)); \
	echo ""; \
	echo "==================== Debian 11.9 Bullseye ====================="; \
	echo ""; \
	if docker-compose -f docker/docker-compose.yml run --rm debian11-9-test /app/tools/test-runner.sh --test $(TEST) $$NETWORK_ARG; then \
		PASSED_ENVS=$$((PASSED_ENVS + 1)); \
	else \
		FAILED_ENVS=$$((FAILED_ENVS + 1)); \
	fi; \
	TOTAL_ENVS=$$((TOTAL_ENVS + 1)); \
	echo ""; \
	echo "==================== Debian 12.2 Bookworm ====================="; \
	echo ""; \
	if docker-compose -f docker/docker-compose.yml run --rm debian12-2-test /app/tools/test-runner.sh --test $(TEST) $$NETWORK_ARG; then \
		PASSED_ENVS=$$((PASSED_ENVS + 1)); \
	else \
		FAILED_ENVS=$$((FAILED_ENVS + 1)); \
	fi; \
	TOTAL_ENVS=$$((TOTAL_ENVS + 1)); \
	echo ""; \
	echo "==================== Fedora 41 ======================="; \
	echo ""; \
	if docker-compose -f docker/docker-compose.yml run --rm fedora41-test /app/tools/test-runner.sh --test $(TEST) $$NETWORK_ARG; then \
		PASSED_ENVS=$$((PASSED_ENVS + 1)); \
	else \
		FAILED_ENVS=$$((FAILED_ENVS + 1)); \
	fi; \
	TOTAL_ENVS=$$((TOTAL_ENVS + 1)); \
	echo ""; \
	echo "==================== RedHat Enterprise Linux 8.10 (UBI8) ======================"; \
	echo ""; \
	if docker-compose -f docker/docker-compose.yml run --rm redhat8-10-test /app/tools/test-runner.sh --test $(TEST) $$NETWORK_ARG; then \
		PASSED_ENVS=$$((PASSED_ENVS + 1)); \
	else \
		FAILED_ENVS=$$((FAILED_ENVS + 1)); \
	fi; \
	TOTAL_ENVS=$$((TOTAL_ENVS + 1)); \
	echo ""; \
	echo "==================== RedHat Enterprise Linux 9.6 (UBI9) ======================"; \
	echo ""; \
	if docker-compose -f docker/docker-compose.yml run --rm redhat9-6-test /app/tools/test-runner.sh --test $(TEST) $$NETWORK_ARG; then \
		PASSED_ENVS=$$((PASSED_ENVS + 1)); \
	else \
		FAILED_ENVS=$$((FAILED_ENVS + 1)); \
	fi; \
	TOTAL_ENVS=$$((TOTAL_ENVS + 1)); \
	echo ""; \
	echo "=================================="; \
	echo "📊 Test Summary Report"; \
	echo "=================================="; \
	echo "Test file: $(TEST)"; \
	echo "Total environments: $$TOTAL_ENVS"; \
	echo "Passed environments: $$PASSED_ENVS"; \
	echo "Failed environments: $$FAILED_ENVS"; \
	if [ $$FAILED_ENVS -eq 0 ]; then \
		echo "🎉 All environment tests passed!"; \
		exit 0; \
	else \
		echo "❌ $$FAILED_ENVS environment tests failed"; \
		exit 1; \
	fi

# Start interactive environment
interactive: build-scripts
	@echo "Starting interactive test environment..."
	docker-compose -f docker/docker-compose.yml run --rm interactive

# Start shell in container
shell: build-scripts
	@echo "Starting Ubuntu container shell..."
	docker-compose -f docker/docker-compose.yml run --rm ubuntu22-test /bin/bash

# Clean up
clean:
	@echo "Cleaning Docker images and containers..."
	docker-compose -f docker/docker-compose.yml down --rmi all --volumes --remove-orphans

# View logs
logs:
	docker-compose -f docker/docker-compose.yml logs

# Show test results
results:
	@if [ -d "test-results" ]; then \
		echo "Test results:"; \
		find test-results -name "*.log" -exec echo "=== {} ===" \; -exec cat {} \;; \
	else \
		echo "No test results found"; \
	fi
