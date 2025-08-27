#!/bin/bash

# Test script - for verifying actual installation functionality of install-docker.sh script

# Import test utility functions
source "$(dirname "$0")/../__base.sh"
source "$(dirname "$0")/../__install.sh"

# Test constants
SCRIPT_PATH_PRE_1="$(dirname "$0")/../../dist/install-curl.sh"
SCRIPT_PATH="$(dirname "$0")/../../dist/install-docker.sh"
 
unit_test_initing "$@" "--name=install-docker"
checkpoint_check_current_os_is_supported

common_suffix_args=$(unit_test_common_suffix_args)
log_debug "Common Suffix Args : $common_suffix_args"

# Install prerequisite packages
bash "$SCRIPT_PATH_PRE_1" $common_suffix_args

# Run main install script using new common function
checkpoint_with_run_install_script "$SCRIPT_PATH" "$common_suffix_args"

# Need to reload environment variables and PATH
export PATH="/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:$PATH"
hash -r  # Recalculate executable file locations

# Check if command is available using new common function
checkpoint_check_command_available "docker"

# Get and verify version information using new common function
DOCKER_VERSION=$(docker --version | awk '{print $3}' | sed 's/,//')
checkpoint_check_software_version "Docker" "$DOCKER_VERSION"

# Get and verify Docker Compose version information
DOCKER_COMPOSE_VERSION=$(docker compose version | awk '{print $4}')
checkpoint_check_software_version "Docker Compose" "$DOCKER_COMPOSE_VERSION"

# Display test results
unit_test_console_summary
exit $?
