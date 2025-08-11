# Makefile for env-script testing

.PHONY: help build test-all test-single test-single-all test-all-single clean interactive shell build-scripts logs results

# Default target
help:
	@echo "Available commands:"
	@echo "  build           - Build all Docker images"
	@echo "  test-all        - Run all tests in all environments [NETWORK=in-china] [DEBUG=true]"
	@echo "  test-single ENV=environment TEST=test-file  - Run specified test in specified environment [NETWORK=in-china] [DEBUG=true]"
	@echo "  test-single-all TEST=test-file             - Run specified test in all environments [NETWORK=in-china] [DEBUG=true]"
	@echo "  test-all-single ENV=environment           - Run all tests in specified environment [NETWORK=in-china] [DEBUG=true]"
	@echo ""
	@echo "  interactive     - Start interactive test environment"
	@echo "  shell           - Start shell in Ubuntu container"
	@echo "  clean           - Clean Docker images and containers"
	@echo "  build-scripts   - Build scripts to dist directory"
	@echo ""
	@echo "Examples:"
	@echo "  make test-all"
	@echo "  make test-all NETWORK=in-china"
	@echo "  make test-all DEBUG=true"
	@echo "  make test-single ENV=ubuntu20-test TEST=tests/install-git/01-ok.sh"
	@echo "  make test-single ENV=ubuntu20-test TEST=tests/install-git/02-install.sh NETWORK=in-china"
	@echo "  make test-single ENV=ubuntu20-test TEST=tests/install-git/02-install.sh DEBUG=true"
	@echo "  make test-single-all TEST=tests/install-git/01-ok.sh"
	@echo "  make test-single-all TEST=tests/install-git/02-install.sh NETWORK=in-china"
	@echo "  make test-single-all TEST=tests/install-git/02-install.sh DEBUG=true"
	@echo "  make test-all-single ENV=ubuntu22-test"
	@echo "  make test-all-single ENV=ubuntu22-test NETWORK=in-china"
	@echo "  make test-all-single ENV=ubuntu22-test DEBUG=true"

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
	@RUNNER_ARGS=""; \
	if [ "$(NETWORK)" = "in-china" ]; then \
		echo "Using China network configuration"; \
		RUNNER_ARGS="$$RUNNER_ARGS --network in-china"; \
	fi; \
	if [ "$(DEBUG)" = "true" ]; then \
		echo "Using DEBUG mode"; \
		RUNNER_ARGS="$$RUNNER_ARGS --debug"; \
	fi; \
	echo ""; \
	echo "==================== Ubuntu 20.04 ===================="; \
	echo ""; \
	docker-compose -f docker/docker-compose.yml run --rm ubuntu20-test /app/tools/test-runner.sh $$RUNNER_ARGS; \
	echo ""; \
	echo "==================== Ubuntu 22.04 ===================="; \
	echo ""; \
	docker-compose -f docker/docker-compose.yml run --rm ubuntu22-test /app/tools/test-runner.sh $$RUNNER_ARGS; \
	echo ""; \
	echo "==================== Ubuntu 24.04 ===================="; \
	echo ""; \
	docker-compose -f docker/docker-compose.yml run --rm ubuntu24-test /app/tools/test-runner.sh $$RUNNER_ARGS; \
	echo ""; \
	echo "==================== Debian 11.9 Bullseye ====================="; \
	echo ""; \
	docker-compose -f docker/docker-compose.yml run --rm debian11-9-test /app/tools/test-runner.sh $$RUNNER_ARGS; \
	echo ""; \
	echo "==================== Debian 12.2 Bookworm ====================="; \
	echo ""; \
	docker-compose -f docker/docker-compose.yml run --rm debian12-2-test /app/tools/test-runner.sh $$RUNNER_ARGS; \
	echo ""; \
	echo "==================== Fedora 41 ======================="; \
	echo ""; \
	docker-compose -f docker/docker-compose.yml run --rm fedora41-test /app/tools/test-runner.sh $$RUNNER_ARGS; \
	echo ""; \
	echo "==================== RedHat Enterprise Linux 8.10 (UBI8) ======================"; \
	echo ""; \
	docker-compose -f docker/docker-compose.yml run --rm redhat8-10-test /app/tools/test-runner.sh $$RUNNER_ARGS; \
	echo ""; \
	echo "==================== RedHat Enterprise Linux 9.6 (UBI9) ======================"; \
	echo ""; \
	docker-compose -f docker/docker-compose.yml run --rm redhat9-6-test /app/tools/test-runner.sh $$NETWORK_ARG

# ======================== Advanced test commands ========================

# Scenario 1: Run specified test in specified environment
test-single: build-scripts
	@if [ -z "$(ENV)" ] || [ -z "$(TEST)" ]; then \
		echo "Usage: make test-single ENV=environment-name TEST=test-file [NETWORK=in-china] [DEBUG=true]"; \
		echo "Example: make test-single ENV=ubuntu20-test TEST=tests/install-git/02-install.sh"; \
		echo "Example: make test-single ENV=ubuntu20-test TEST=tests/install-git/02-install.sh NETWORK=in-china"; \
		echo "Example: make test-single ENV=ubuntu20-test TEST=tests/install-git/02-install.sh DEBUG=true"; \
		echo "Available environments: ubuntu22-test, ubuntu20-test, ubuntu24-test, debian11-9-test, debian12-2-test, fedora41-test, redhat8-10-test, redhat9-6-test"; \
		exit 1; \
	fi
	@echo "Running test in $(ENV) environment: $(TEST)"
	@RUNNER_ARGS="--test $(TEST)"; \
	if [ "$(NETWORK)" = "in-china" ]; then \
		echo "Using China network configuration"; \
		RUNNER_ARGS="$$RUNNER_ARGS --network in-china"; \
	fi; \
	if [ "$(DEBUG)" = "true" ]; then \
		echo "Using DEBUG mode"; \
		RUNNER_ARGS="$$RUNNER_ARGS --debug"; \
	fi; \
	docker-compose -f docker/docker-compose.yml run --rm $(ENV) /app/tools/test-runner.sh $$RUNNER_ARGS; \
	EXIT_CODE=$$?; \
	echo ""; \
	echo "=================================="; \
	echo "📊 Test Result"; \
	echo "=================================="; \
	echo "Test file: $(TEST)"; \
	echo "Environment: $(ENV)"; \
	if [ $$EXIT_CODE -eq 0 ]; then \
		echo "Status: ✅ PASSED"; \
		echo "🎉 Test passed successfully!"; \
		exit 0; \
	elif [ $$EXIT_CODE -eq 2 ]; then \
		echo "Status: ⏭️ SKIPPED"; \
		echo "⚠️ Test was skipped (OS not supported)"; \
		exit 0; \
	else \
		echo "Status: ❌ FAILED"; \
		echo "💥 Test failed with exit code: $$EXIT_CODE"; \
		exit 1; \
	fi

# Scenario 4: Run all tests in specified environment
test-all-single: build-scripts
	@if [ -z "$(ENV)" ]; then \
		echo "Usage: make test-all-single ENV=environment-name [NETWORK=in-china] [DEBUG=true]"; \
		echo "Available environments: ubuntu22-test, ubuntu20-test, ubuntu24-test, debian11-9-test, debian12-2-test, fedora41-test, redhat8-10-test, redhat9-6-test"; \
		echo "Example: make test-all-single ENV=ubuntu22-test"; \
		echo "Example: make test-all-single ENV=fedora41-test NETWORK=in-china"; \
		echo "Example: make test-all-single ENV=ubuntu22-test DEBUG=true"; \
		exit 1; \
	fi
	@echo "Running all tests in environment $(ENV)"
	@RUNNER_ARGS=""; \
	if [ "$(NETWORK)" = "in-china" ]; then \
		echo "Using China network configuration"; \
		RUNNER_ARGS="$$RUNNER_ARGS --network in-china"; \
	fi; \
	if [ "$(DEBUG)" = "true" ]; then \
		echo "Using DEBUG mode"; \
		RUNNER_ARGS="$$RUNNER_ARGS --debug"; \
	fi; \
	TOTAL_TESTS=0; \
	PASSED_TESTS=0; \
	FAILED_TESTS=0; \
	SKIPPED_TESTS=0; \
	for test_file in $$(find tests -name "*.sh" -type f | sort); do \
		TOTAL_TESTS=$$((TOTAL_TESTS + 1)); \
		echo ""; \
		echo "==================== Running test: $$test_file ===================="; \
		echo ""; \
		docker-compose -f docker/docker-compose.yml run --rm $(ENV) /app/tools/test-runner.sh --test $$test_file $$RUNNER_ARGS; \
		EXIT_CODE=$$?; \
		if [ $$EXIT_CODE -eq 0 ]; then \
			PASSED_TESTS=$$((PASSED_TESTS + 1)); \
		elif [ $$EXIT_CODE -eq 2 ]; then \
			SKIPPED_TESTS=$$((SKIPPED_TESTS + 1)); \
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
	if [ $$SKIPPED_TESTS -gt 0 ]; then \
		echo "Skipped tests: $$SKIPPED_TESTS"; \
	fi; \
	echo "Failed tests: $$FAILED_TESTS"; \
	if [ $$FAILED_TESTS -eq 0 ]; then \
		if [ $$SKIPPED_TESTS -eq 0 ]; then \
			echo "🎉 All tests passed!"; \
		else \
			echo "🎉 All tests completed (some were skipped)!"; \
		fi; \
		exit 0; \
	else \
		echo "❌ $$FAILED_TESTS tests failed"; \
		exit 1; \
	fi

# Scenario 3: Run specified test in all environments
test-single-all: build-scripts
	@if [ -z "$(TEST)" ]; then \
		echo "Usage: make test-single-all TEST=test-file [NETWORK=in-china] [DEBUG=true]"; \
		echo "Example: make test-single-all TEST=tests/install-git/01-ok.sh"; \
		echo "Example: make test-single-all TEST=tests/install-git/02-install.sh NETWORK=in-china"; \
		echo "Example: make test-single-all TEST=tests/install-git/02-install.sh DEBUG=true"; \
		exit 1; \
	fi
	@echo "Running test in all environments: $(TEST)"
	@RUNNER_ARGS="--test $(TEST)"; \
	if [ "$(NETWORK)" = "in-china" ]; then \
		echo "Using China network configuration"; \
		RUNNER_ARGS="$$RUNNER_ARGS --network in-china"; \
	fi; \
	if [ "$(DEBUG)" = "true" ]; then \
		echo "Using DEBUG mode"; \
		RUNNER_ARGS="$$RUNNER_ARGS --debug"; \
	fi; \
	TOTAL_ENVS=0; \
	PASSED_ENVS=0; \
	FAILED_ENVS=0; \
	SKIPPED_ENVS=0; \
	echo ""; \
	echo "==================== Ubuntu 20.04 ===================="; \
	echo ""; \
	docker-compose -f docker/docker-compose.yml run --rm ubuntu20-test /app/tools/test-runner.sh $$RUNNER_ARGS; \
	EXIT_CODE=$$?; \
	if [ $$EXIT_CODE -eq 0 ]; then \
		PASSED_ENVS=$$((PASSED_ENVS + 1)); \
	elif [ $$EXIT_CODE -eq 2 ]; then \
		SKIPPED_ENVS=$$((SKIPPED_ENVS + 1)); \
	else \
		FAILED_ENVS=$$((FAILED_ENVS + 1)); \
	fi; \
	TOTAL_ENVS=$$((TOTAL_ENVS + 1)); \
	echo ""; \
	echo "==================== Ubuntu 22.04 ===================="; \
	echo ""; \
	docker-compose -f docker/docker-compose.yml run --rm ubuntu22-test /app/tools/test-runner.sh $$RUNNER_ARGS; \
	EXIT_CODE=$$?; \
	if [ $$EXIT_CODE -eq 0 ]; then \
		PASSED_ENVS=$$((PASSED_ENVS + 1)); \
	elif [ $$EXIT_CODE -eq 2 ]; then \
		SKIPPED_ENVS=$$((SKIPPED_ENVS + 1)); \
	else \
		FAILED_ENVS=$$((FAILED_ENVS + 1)); \
	fi; \
	TOTAL_ENVS=$$((TOTAL_ENVS + 1)); \
	echo ""; \
	echo "==================== Ubuntu 24.04 ===================="; \
	echo ""; \
	docker-compose -f docker/docker-compose.yml run --rm ubuntu24-test /app/tools/test-runner.sh $$RUNNER_ARGS; \
	EXIT_CODE=$$?; \
	if [ $$EXIT_CODE -eq 0 ]; then \
		PASSED_ENVS=$$((PASSED_ENVS + 1)); \
	elif [ $$EXIT_CODE -eq 2 ]; then \
		SKIPPED_ENVS=$$((SKIPPED_ENVS + 1)); \
	else \
		FAILED_ENVS=$$((FAILED_ENVS + 1)); \
	fi; \
	TOTAL_ENVS=$$((TOTAL_ENVS + 1)); \
	echo ""; \
	echo "==================== Debian 11.9 Bullseye ====================="; \
	echo ""; \
	docker-compose -f docker/docker-compose.yml run --rm debian11-9-test /app/tools/test-runner.sh $$RUNNER_ARGS; \
	EXIT_CODE=$$?; \
	if [ $$EXIT_CODE -eq 0 ]; then \
		PASSED_ENVS=$$((PASSED_ENVS + 1)); \
	elif [ $$EXIT_CODE -eq 2 ]; then \
		SKIPPED_ENVS=$$((SKIPPED_ENVS + 1)); \
	else \
		FAILED_ENVS=$$((FAILED_ENVS + 1)); \
	fi; \
	TOTAL_ENVS=$$((TOTAL_ENVS + 1)); \
	echo ""; \
	echo "==================== Debian 12.2 Bookworm ====================="; \
	echo ""; \
	docker-compose -f docker/docker-compose.yml run --rm debian12-2-test /app/tools/test-runner.sh $$RUNNER_ARGS; \
	EXIT_CODE=$$?; \
	if [ $$EXIT_CODE -eq 0 ]; then \
		PASSED_ENVS=$$((PASSED_ENVS + 1)); \
	elif [ $$EXIT_CODE -eq 2 ]; then \
		SKIPPED_ENVS=$$((SKIPPED_ENVS + 1)); \
	else \
		FAILED_ENVS=$$((FAILED_ENVS + 1)); \
	fi; \
	TOTAL_ENVS=$$((TOTAL_ENVS + 1)); \
	echo ""; \
	echo "==================== Fedora 41 ======================="; \
	echo ""; \
	docker-compose -f docker/docker-compose.yml run --rm fedora41-test /app/tools/test-runner.sh $$RUNNER_ARGS; \
	EXIT_CODE=$$?; \
	if [ $$EXIT_CODE -eq 0 ]; then \
		PASSED_ENVS=$$((PASSED_ENVS + 1)); \
	elif [ $$EXIT_CODE -eq 2 ]; then \
		SKIPPED_ENVS=$$((SKIPPED_ENVS + 1)); \
	else \
		FAILED_ENVS=$$((FAILED_ENVS + 1)); \
	fi; \
	TOTAL_ENVS=$$((TOTAL_ENVS + 1)); \
	echo ""; \
	echo "==================== RedHat Enterprise Linux 8.10 (UBI8) ======================"; \
	echo ""; \
	docker-compose -f docker/docker-compose.yml run --rm redhat8-10-test /app/tools/test-runner.sh $$RUNNER_ARGS; \
	EXIT_CODE=$$?; \
	if [ $$EXIT_CODE -eq 0 ]; then \
		PASSED_ENVS=$$((PASSED_ENVS + 1)); \
	elif [ $$EXIT_CODE -eq 2 ]; then \
		SKIPPED_ENVS=$$((SKIPPED_ENVS + 1)); \
	else \
		FAILED_ENVS=$$((FAILED_ENVS + 1)); \
	fi; \
	TOTAL_ENVS=$$((TOTAL_ENVS + 1)); \
	echo ""; \
	echo "==================== RedHat Enterprise Linux 9.6 (UBI9) ======================"; \
	echo ""; \
	docker-compose -f docker/docker-compose.yml run --rm redhat9-6-test /app/tools/test-runner.sh $$RUNNER_ARGS; \
	EXIT_CODE=$$?; \
	if [ $$EXIT_CODE -eq 0 ]; then \
		PASSED_ENVS=$$((PASSED_ENVS + 1)); \
	elif [ $$EXIT_CODE -eq 2 ]; then \
		SKIPPED_ENVS=$$((SKIPPED_ENVS + 1)); \
	else \
		FAILED_ENVS=$$((FAILED_ENVS + 1)); \
	fi; \
	TOTAL_ENVS=$$((TOTAL_ENVS + 1)); \
	echo ""; \
	echo "=================================="; \
	echo "📊 Test Summary Report"; \
	echo "=================================="; \
	echo "Test file: $(TEST)"; \
	echo "Total   environments: $$TOTAL_ENVS"; \
	echo "Passed  environments: $$PASSED_ENVS"; \
	echo "Skipped environments: $$SKIPPED_ENVS"; \
	echo "Failed  environments: $$FAILED_ENVS"; \
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
