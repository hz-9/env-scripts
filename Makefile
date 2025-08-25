# Makefile for env-script testing

# .PHONY declarations
.PHONY: help build build-scripts build-images
.PHONY: install-test-all install-test-all-env install-test-all-script install-test-single install-test-file
.PHONY: syncdb-test-all syncdb-test-all-env syncdb-test-all-script syncdb-test-single syncdb-test-file
.PHONY: clean interactive shell logs results

# Default target
help:
	@echo "Available commands:"
	@echo "  build                 - Build all Docker images"
	@echo ""
	@echo "  Installation script testing:"
	@echo "  install-test-all                   - Run all install tests in all environments"
	@echo "  install-test-all-env SCRIPT=name   - Run install tests for a specific script in all environments"
	@echo "  install-test-all-script ENV=env    - Run all install tests in specified environment"
	@echo "  install-test-single ENV=env SCRIPT=name - Run install tests for specific script in specific environment"
	@echo "  install-test-file ENV=env FILE=path - Run specific install test file in specific environment"
	@echo ""
	@echo "  Database sync script testing:"
	@echo "  syncdb-test-all                   - Run all syncdb tests in all environments"
	@echo "  syncdb-test-all-env SCRIPT=name   - Run syncdb tests for a specific script in all environments"
	@echo "  syncdb-test-all-script ENV=env    - Run all syncdb tests in specified environment"
	@echo "  syncdb-test-single ENV=env SCRIPT=name - Run syncdb tests for specific script in specific environment"
	@echo "  syncdb-test-file ENV=env FILE=path - Run specific syncdb test file in specific environment"
	@echo ""
	@echo "  Utility commands:"
	@echo "  interactive         - Start interactive test environment"
	@echo "  shell               - Start shell in Ubuntu container"
	@echo "  clean               - Clean Docker images and containers"
	@echo "  build-scripts       - Build scripts to dist directory"
	@echo ""
	@echo "Common options for all test commands:"
	@echo "  NETWORK=in-china    - Use China network configuration"
	@echo "  DEBUG=true          - Enable debug mode"
	@echo ""
	@echo "Available environments:"
	@echo "  ubuntu20, ubuntu22, ubuntu24"
	@echo "  debian11-9, debian12-2"
	@echo "  fedora41"
	@echo "  redhat8-10, redhat9-6"

# Build scripts
build-scripts:
	@echo "\033[0;34m"
	@printf '%*s\n' "$$(tput cols)" '' | tr ' ' '='
	@echo "🚀  Environment scripts is starting..."
	@printf '%*s\n' "$$(tput cols)" '' | tr ' ' '='
	@echo "\033[0m"

	bash ./tools/build.sh

	@echo "\033[0;34m"
	@printf '%*s\n' "$$(tput cols)" '' | tr ' ' '='
	@echo "✅  Environment scripts is completed."
	@printf '%*s\n' "$$(tput cols)" '' | tr ' ' '='
	@echo "\033[0m"

# Build Docker images
build-images:
	@echo "\033[0;34m"
	@printf '%*s\n' "$$(tput cols)" '' | tr ' ' '='
	@echo "🚀  Environment images is starting..."
	@printf '%*s\n' "$$(tput cols)" '' | tr ' ' '='
	@echo "\033[0m"

	docker-compose -f docker/docker-compose.yml build

	@echo "\033[0;34m"
	@printf '%*s\n' "$$(tput cols)" '' | tr ' ' '='
	@echo "✅  Environment images is completed."
	@printf '%*s\n' "$$(tput cols)" '' | tr ' ' '='
	@echo "\033[0m"
	
# Build scripts AND Build Docker images
build:
	@$(MAKE) build-scripts && $(MAKE) build-images

# ======================== Installation Script Testing ========================

# Run all install tests in all environments
install-test-all: build-scripts
	@mkdir -p './logs';	\
	LOG_FILE="logs/install-test-all.$$(date +%Y%m%d-%H%M%S).log"; \
	echo "\033[0;34m"; \
	printf '%*s\n' "$$(tput cols)" '' | tr ' ' '='; \
	echo "🚀  Install script test is starting..."; \
	echo "    SCRIPT  : ${SCRIPT}"; \
	printf '%*s\n' "$$(tput cols)" '' | tr ' ' '='; \
	echo "\033[0m"; \
	\
	ARGS="--mode=all --scope=install"; \
	if [ -n "$(NETWORK)" ]; then \
			echo "Makefile Add ARGS   : NETWORK=$(NETWORK)"; \
			ARGS="$$ARGS --network=$(NETWORK)"; \
	fi; \
	if [ -n "$(DEBUG)" ]; then \
			echo "Makefile Add ARGS   : DEBUG"; \
			ARGS="$$ARGS --debug"; \
	fi; \
	echo "Makefile Final ARGS : $$ARGS" 2>&1 | tee $$LOG_FILE ;\
	echo ""; \
	./tools/test-environment-manager.sh $$ARGS 2>&1 | tee $$LOG_FILE ;\
	\
	echo "\033[0;34m"; \
	printf '%*s\n' "$$(tput cols)" '' | tr ' ' '='; \
	echo "✅  Install script test is completed."; \
	echo "    Log file: $$LOG_FILE"; \
	printf '%*s\n' "$$(tput cols)" '' | tr ' ' '='; \
	echo "\033[0m";

# Run install tests for a specific script in all environments
install-test-all-env: build-scripts
	@if [ -z "$(SCRIPT)" ]; then \
		echo "\033[0;31m"; \
		echo "Usage: make install-test-all-env SCRIPT=test-file-path [NETWORK=in-china] [DEBUG=true]"; \
		echo "Example: make install-test-all-env SCRIPT=git"; \
		echo "\033[0m"; \
		exit 1; \
	else \
		mkdir -p './logs';	\
	  LOG_FILE="logs/install-test-all-env.$$(date +%Y%m%d-%H%M%S).log"; \
		echo "\033[0;34m"; \
		printf '%*s\n' "$$(tput cols)" '' | tr ' ' '='; \
		echo "🚀  Install script test for all envs is starting..."; \
		echo "    SCRIPT  : ${SCRIPT}"; \
		printf '%*s\n' "$$(tput cols)" '' | tr ' ' '='; \
		echo "\033[0m"; \
		\
		ARGS="--mode=all-env --script=install-$(SCRIPT)"; \
		if [ -n "$(NETWORK)" ]; then \
				echo "Makefile Add ARGS   : NETWORK=$(NETWORK)"; \
				ARGS="$$ARGS --network=$(NETWORK)"; \
		fi; \
		if [ -n "$(DEBUG)" ]; then \
				echo "Makefile Add ARGS   : DEBUG"; \
				ARGS="$$ARGS --debug"; \
		fi; \
		echo "Makefile Final ARGS : $$ARGS"; \
		echo ""; \
		./tools/test-environment-manager.sh $$ARGS 2>&1 | tee $$LOG_FILE ;\
		\
		echo "\033[0;34m"; \
		printf '%*s\n' "$$(tput cols)" '' | tr ' ' '='; \
		echo "✅  Install script test for all envs is completed."; \
		echo "    Log file: $$LOG_FILE"; \
		printf '%*s\n' "$$(tput cols)" '' | tr ' ' '='; \
		echo "\033[0m"; \
	fi

# Run all install tests in specific environment
install-test-all-script: build-scripts
	@if [ -z "$(ENV)" ]; then \
		echo "\033[0;31m"; \
		echo "Usage: make install-test-all-script ENV=environment [NETWORK=in-china] [DEBUG=true]"; \
		echo "Example: make install-test-all-script ENV=ubuntu22"; \
		echo "Available environments: ubuntu20, ubuntu22, ubuntu24, debian11-9, debian12-2, fedora41, redhat8-10, redhat9-6"; \
		echo "\033[0m"; \
		exit 1; \
	else \
		mkdir -p './logs';	\
	  LOG_FILE="logs/install-test-all-script.$$(date +%Y%m%d-%H%M%S).log"; \
		echo "\033[0;34m"; \
		printf '%*s\n' "$$(tput cols)" '' | tr ' ' '='; \
		echo "🚀  Install script test for all scripts is starting..."; \
		echo "    ENV     : ${ENV}"; \
		echo "    SCRIPT  : ${SCRIPT}"; \
		printf '%*s\n' "$$(tput cols)" '' | tr ' ' '='; \
		echo "\033[0m"; \
		\
		ARGS="--mode=all-script --scope=install --env=$(ENV)"; \
		if [ -n "$(NETWORK)" ]; then \
				echo "Makefile Add ARGS   : NETWORK=$(NETWORK)"; \
				ARGS="$$ARGS --network=$(NETWORK)"; \
		fi; \
		if [ -n "$(DEBUG)" ]; then \
				echo "Makefile Add ARGS   : DEBUG"; \
				ARGS="$$ARGS --debug"; \
		fi; \
		echo "Makefile Final ARGS : $$ARGS"; \
		echo ""; \
		./tools/test-environment-manager.sh $$ARGS 2>&1 | tee $$LOG_FILE ;\
		\
		echo "\033[0;34m"; \
		printf '%*s\n' "$$(tput cols)" '' | tr ' ' '='; \
		echo "✅  Install script test for all scripts is completed."; \
		echo "    Log file: $$LOG_FILE"; \
		printf '%*s\n' "$$(tput cols)" '' | tr ' ' '='; \
		echo "\033[0m"; \
	fi

# Run install tests for specific script in specific environment
install-test-single: build-scripts
	@if [ -z "$(ENV)" ] || [ -z "$(SCRIPT)" ]; then \
		echo "\033[0;31m"; \
		echo "Usage: make install-test-single ENV=environment SCRIPT=test-file-path [NETWORK=in-china] [DEBUG=true]"; \
		echo "Example: make install-test-single ENV=ubuntu22 SCRIPT=git"; \
		echo "Available environments: ubuntu20, ubuntu22, ubuntu24, debian11-9, debian12-2, fedora41, redhat8-10, redhat9-6"; \
		echo "\033[0m"; \
		exit 1; \
	else \
		mkdir -p './logs';	\
	  LOG_FILE="logs/install-test-single.$$(date +%Y%m%d-%H%M%S).log"; \
		echo "\033[0;34m"; \
		printf '%*s\n' "$$(tput cols)" '' | tr ' ' '='; \
		echo "🚀  Install script test for single is starting..."; \
		echo "    ENV     : ${ENV}"; \
		echo "    SCRIPT  : ${SCRIPT}"; \
		printf '%*s\n' "$$(tput cols)" '' | tr ' ' '='; \
		echo "\033[0m"; \
		\
		ARGS="--mode=single --env=$(ENV) --script=install-$(SCRIPT)"; \
		if [ -n "$(NETWORK)" ]; then \
				echo "Makefile Add ARGS   : NETWORK=$(NETWORK)"; \
				ARGS="$$ARGS --network=$(NETWORK)"; \
		fi; \
		if [ -n "$(DEBUG)" ]; then \
				echo "Makefile Add ARGS   : DEBUG"; \
				ARGS="$$ARGS --debug"; \
		fi; \
		echo "Makefile Final ARGS : $$ARGS"; \
		echo ""; \
		./tools/test-environment-manager.sh $$ARGS 2>&1 | tee $$LOG_FILE ;\
		\
		echo "\033[0;34m"; \
		printf '%*s\n' "$$(tput cols)" '' | tr ' ' '='; \
		echo "✅  Install script test for single is completed."; \
		echo "    Log file: $$LOG_FILE"; \
		printf '%*s\n' "$$(tput cols)" '' | tr ' ' '='; \
		echo "\033[0m"; \
	fi

# Run specific install test file in specific environment
install-test-file: build-scripts
	@if [ -z "$(ENV)" ] || [ -z "$(FILE)" ]; then \
		echo "\033[0;31m"; \
		echo "Usage: make install-test-file ENV=environment FILE=test-file-path [NETWORK=in-china] [DEBUG=true]"; \
		echo "Example: make install-test-file ENV=ubuntu22 FILE=tests/install-git/01-ok.sh"; \
		echo "Available environments: ubuntu20, ubuntu22, ubuntu24, debian11-9, debian12-2, fedora41, redhat8-10, redhat9-6"; \
		echo "\033[0m"; \
		exit 1; \
	else \
		mkdir -p './logs';	\
		LOG_FILE="logs/install-test-file.$$(date +%Y%m%d-%H%M%S).log"; \
		echo "\033[0;34m"; \
		printf '%*s\n' "$$(tput cols)" '' | tr ' ' '='; \
		echo "🚀  Install script test for single file is starting..."; \
		echo "    ENV     : ${ENV}"; \
		echo "    FILE    : ${FILE}"; \
		printf '%*s\n' "$$(tput cols)" '' | tr ' ' '='; \
		echo "\033[0m"; \
		\
		ARGS="--mode=single --env=$(ENV) --file=$(FILE)"; \
		if [ -n "$(NETWORK)" ]; then \
				echo "Makefile Add ARGS   : NETWORK=$(NETWORK)"; \
				ARGS="$$ARGS --network=$(NETWORK)"; \
		fi; \
		if [ -n "$(DEBUG)" ]; then \
				echo "Makefile Add ARGS   : DEBUG"; \
				ARGS="$$ARGS --debug"; \
		fi; \
		echo "Makefile Final ARGS : $$ARGS"; \
		echo ""; \
		./tools/test-environment-manager.sh $$ARGS 2>&1 | tee $$LOG_FILE ;\
		\
		echo "\033[0;34m"; \
		printf '%*s\n' "$$(tput cols)" '' | tr ' ' '='; \
		echo "✅  Install script test for single file is completed."; \
		echo "    Log file: $$LOG_FILE"; \
		printf '%*s\n' "$$(tput cols)" '' | tr ' ' '='; \
		echo "\033[0m"; \
	fi

# ======================== Database Sync Script Testing ========================

# Run all syncdb tests in all environments
syncdb-test-all: build-scripts
	@mkdir -p './logs';	\
	LOG_FILE="logs/syncdb-test-all.$$(date +%Y%m%d-%H%M%S).log"; \
	echo "\033[0;34m"; \
	printf '%*s\n' "$$(tput cols)" '' | tr ' ' '='; \
	echo "🚀  Database sync script test is starting..."; \
	echo "    SCRIPT  : ${SCRIPT}"; \
	printf '%*s\n' "$$(tput cols)" '' | tr ' ' '='; \
	echo "\033[0m"; \
	\
	ARGS="--mode=all --scope=syncdb"; \
	if [ -n "$(NETWORK)" ]; then \
			echo "Makefile Add ARGS   : NETWORK=$(NETWORK)"; \
			ARGS="$$ARGS --network=$(NETWORK)"; \
	fi; \
	if [ -n "$(DEBUG)" ]; then \
			echo "Makefile Add ARGS   : DEBUG"; \
			ARGS="$$ARGS --debug"; \
	fi; \
	echo "Makefile Final ARGS : $$ARGS" 2>&1 | tee $$LOG_FILE ;\
	echo ""; \
	./tools/test-environment-manager.sh $$ARGS 2>&1 | tee $$LOG_FILE ;\
	\
	echo "\033[0;34m"; \
	printf '%*s\n' "$$(tput cols)" '' | tr ' ' '='; \
	echo "✅  Database sync script test is completed."; \
	echo "    Log file: $$LOG_FILE"; \
	printf '%*s\n' "$$(tput cols)" '' | tr ' ' '='; \
	echo "\033[0m";

# Run syncdb tests for a specific script in all environments
syncdb-test-all-env: build-scripts
	@if [ -z "$(SCRIPT)" ]; then \
		echo "\033[0;31m"; \
		echo "Usage: make syncdb-test-all-env SCRIPT=script-name [NETWORK=in-china] [DEBUG=true]"; \
		echo "Example: make syncdb-test-all-env SCRIPT=mysql"; \
		echo "\033[0m"; \
		exit 1; \
	else \
		mkdir -p './logs';	\
	  LOG_FILE="logs/syncdb-test-all-env.$$(date +%Y%m%d-%H%M%S).log"; \
		echo "\033[0;34m"; \
		printf '%*s\n' "$$(tput cols)" '' | tr ' ' '='; \
		echo "🚀  Database sync script test for all envs is starting..."; \
		echo "    SCRIPT  : ${SCRIPT}"; \
		printf '%*s\n' "$$(tput cols)" '' | tr ' ' '='; \
		echo "\033[0m"; \
		\
		ARGS="--mode=all-env --script=syncdb-$(SCRIPT)"; \
		if [ -n "$(NETWORK)" ]; then \
				echo "Makefile Add ARGS   : NETWORK=$(NETWORK)"; \
				ARGS="$$ARGS --network=$(NETWORK)"; \
		fi; \
		if [ -n "$(DEBUG)" ]; then \
				echo "Makefile Add ARGS   : DEBUG"; \
				ARGS="$$ARGS --debug"; \
		fi; \
		echo "Makefile Final ARGS : $$ARGS"; \
		echo ""; \
		./tools/test-environment-manager.sh $$ARGS 2>&1 | tee $$LOG_FILE ;\
		\
		echo "\033[0;34m"; \
		printf '%*s\n' "$$(tput cols)" '' | tr ' ' '='; \
		echo "✅  Database sync script test for all envs is completed."; \
		echo "    Log file: $$LOG_FILE"; \
		printf '%*s\n' "$$(tput cols)" '' | tr ' ' '='; \
		echo "\033[0m"; \
	fi

# Run all syncdb tests in specific environment
syncdb-test-all-script: build-scripts
	@if [ -z "$(ENV)" ]; then \
		echo "\033[0;31m"; \
		echo "Usage: make syncdb-test-all-script ENV=environment [NETWORK=in-china] [DEBUG=true]"; \
		echo "Example: make syncdb-test-all-script ENV=ubuntu22"; \
		echo "Available environments: ubuntu20, ubuntu22, ubuntu24, debian11-9, debian12-2, fedora41, redhat8-10, redhat9-6"; \
		echo "\033[0m"; \
		exit 1; \
	else \
		mkdir -p './logs';	\
	  LOG_FILE="logs/syncdb-test-all-script.$$(date +%Y%m%d-%H%M%S).log"; \
		echo "\033[0;34m"; \
		printf '%*s\n' "$$(tput cols)" '' | tr ' ' '='; \
		echo "🚀  Database sync script test for all scripts is starting..."; \
		echo "    ENV     : ${ENV}"; \
		echo "    SCRIPT  : ${SCRIPT}"; \
		printf '%*s\n' "$$(tput cols)" '' | tr ' ' '='; \
		echo "\033[0m"; \
		\
		ARGS="--mode=all-script --scope=syncdb --env=$(ENV)"; \
		if [ -n "$(NETWORK)" ]; then \
				echo "Makefile Add ARGS   : NETWORK=$(NETWORK)"; \
				ARGS="$$ARGS --network=$(NETWORK)"; \
		fi; \
		if [ -n "$(DEBUG)" ]; then \
				echo "Makefile Add ARGS   : DEBUG"; \
				ARGS="$$ARGS --debug"; \
		fi; \
		echo "Makefile Final ARGS : $$ARGS"; \
		echo ""; \
		./tools/test-environment-manager.sh $$ARGS 2>&1 | tee $$LOG_FILE ;\
		\
		echo "\033[0;34m"; \
		printf '%*s\n' "$$(tput cols)" '' | tr ' ' '='; \
		echo "✅  Database sync script test for all scripts is completed."; \
		echo "    Log file: $$LOG_FILE"; \
		printf '%*s\n' "$$(tput cols)" '' | tr ' ' '='; \
		echo "\033[0m"; \
	fi

# Run syncdb tests for specific script in specific environment
syncdb-test-single: build-scripts
	@if [ -z "$(ENV)" ] || [ -z "$(SCRIPT)" ]; then \
		echo "\033[0;31m"; \
		echo "Usage: make syncdb-test-single ENV=environment SCRIPT=script-name [NETWORK=in-china] [DEBUG=true]"; \
		echo "Example: make syncdb-test-single ENV=ubuntu22 SCRIPT=mysql"; \
		echo "Available environments: ubuntu20, ubuntu22, ubuntu24, debian11-9, debian12-2, fedora41, redhat8-10, redhat9-6"; \
		echo "\033[0m"; \
		exit 1; \
	else \
		mkdir -p './logs';	\
	  LOG_FILE="logs/syncdb-test-single.$$(date +%Y%m%d-%H%M%S).log"; \
		echo "\033[0;34m"; \
		printf '%*s\n' "$$(tput cols)" '' | tr ' ' '='; \
		echo "🚀  Database sync script test for single is starting..."; \
		echo "    ENV     : ${ENV}"; \
		echo "    SCRIPT  : ${SCRIPT}"; \
		printf '%*s\n' "$$(tput cols)" '' | tr ' ' '='; \
		echo "\033[0m"; \
		\
		ARGS="--mode=single --env=$(ENV) --script=syncdb-$(SCRIPT)"; \
		if [ -n "$(NETWORK)" ]; then \
				echo "Makefile Add ARGS   : NETWORK=$(NETWORK)"; \
				ARGS="$$ARGS --network=$(NETWORK)"; \
		fi; \
		if [ -n "$(DEBUG)" ]; then \
				echo "Makefile Add ARGS   : DEBUG"; \
				ARGS="$$ARGS --debug"; \
		fi; \
		echo "Makefile Final ARGS : $$ARGS"; \
		echo ""; \
		./tools/test-environment-manager.sh $$ARGS 2>&1 | tee $$LOG_FILE ;\
		\
		echo "\033[0;34m"; \
		printf '%*s\n' "$$(tput cols)" '' | tr ' ' '='; \
		echo "✅  Database sync script test for single is completed."; \
		echo "    Log file: $$LOG_FILE"; \
		printf '%*s\n' "$$(tput cols)" '' | tr ' ' '='; \
		echo "\033[0m"; \
	fi

# Run specific syncdb test file in specific environment
syncdb-test-file: build-scripts
	@if [ -z "$(ENV)" ] || [ -z "$(FILE)" ]; then \
		echo "\033[0;31m"; \
		echo "Usage: make syncdb-test-file ENV=environment FILE=test-file-path [NETWORK=in-china] [DEBUG=true]"; \
		echo "Example: make syncdb-test-file ENV=ubuntu22 FILE=tests/syncdb-mysql/01-ok.sh"; \
		echo "Available environments: ubuntu20, ubuntu22, ubuntu24, debian11-9, debian12-2, fedora41, redhat8-10, redhat9-6"; \
		echo "\033[0m"; \
		exit 1; \
	else \
		mkdir -p './logs';	\
		LOG_FILE="logs/syncdb-test-file.$$(date +%Y%m%d-%H%M%S).log"; \
		echo "\033[0;34m"; \
		printf '%*s\n' "$$(tput cols)" '' | tr ' ' '='; \
		echo "🚀  Database sync script test for single file is starting..."; \
		echo "    ENV     : ${ENV}"; \
		echo "    FILE    : ${FILE}"; \
		printf '%*s\n' "$$(tput cols)" '' | tr ' ' '='; \
		echo "\033[0m"; \
		\
		ARGS="--mode=single --env=$(ENV) --file=$(FILE)"; \
		if [ -n "$(NETWORK)" ]; then \
				echo "Makefile Add ARGS   : NETWORK=$(NETWORK)"; \
				ARGS="$$ARGS --network=$(NETWORK)"; \
		fi; \
		if [ -n "$(DEBUG)" ]; then \
				echo "Makefile Add ARGS   : DEBUG"; \
				ARGS="$$ARGS --debug"; \
		fi; \
		echo "Makefile Final ARGS : $$ARGS"; \
		echo ""; \
		./tools/test-environment-manager.sh $$ARGS 2>&1 | tee $$LOG_FILE ;\
		\
		echo "\033[0;34m"; \
		printf '%*s\n' "$$(tput cols)" '' | tr ' ' '='; \
		echo "✅  Database sync script test for single file is completed."; \
		echo "    Log file: $$LOG_FILE"; \
		printf '%*s\n' "$$(tput cols)" '' | tr ' ' '='; \
		echo "\033[0m"; \
	fi

# ======================== Utility Commands ========================

# Start interactive environment
interactive: build-scripts
	@echo "Starting interactive test environment..."
	docker-compose -f docker/docker-compose.yml run --rm interactive

# Start shell in container
shell: build-scripts
	@echo "Starting Ubuntu container shell..."
	docker-compose -f docker/docker-compose.yml run --rm ubuntu22 /bin/bash

# Clean up
clean:
	@echo "Cleaning Docker images and containers..."
	docker-compose -f docker/docker-compose.yml down --rmi all --volumes --remove-orphans

# View logs
logs:
	docker-compose -f docker/docker-compose.yml logs

# Show test results
results:
	@if [ -d "logs" ]; then \
		echo "Test results:"; \
		find logs -name "*.log" -exec echo "=== {} ===" \; -exec cat {} \;; \
	else \
		echo "No test results found"; \
	fi
