#!/bin/bash

# Test script - for verifying actual installation functionality of install-docker.sh script

# Import test utility functions
source "$(dirname "$0")/../test-utils.sh"

# Test constants
SCRIPT_PATH_PRE_1="$(dirname "$0")/../../dist/install-curl.sh"
SCRIPT_PATH="$(dirname "$0")/../../dist/install-docker.sh"

# Setup test environment
setup_test_env

test_info "Starting tests for install-docker.sh script actual installation functionality"

# Checkpoint 0: Check if OS is supported
test_info "Checkpoint 0: Check if current OS is supported"
if ! is_os_supported "$SCRIPT_PATH"; then
    skip_test_with_summary "Current OS is not supported for Docker installation"
fi
test_success "Current OS is supported for Docker installation"

# Checkpoint 1: Does the file run correctly?
test_info "Checkpoint 1: Test if script can execute correctly"
test_info "install-docker.sh execution log (real-time output):"

# Decide whether to use --network=in-china parameter based on network configuration
SCRIPT_ARGS=""

if [ "${TEST_NETWORK:-default}" = "in-china" ]; then
    test_info "Running script with China network configuration"
    test_debug "Using --network=in-china parameter"
    SCRIPT_ARGS="$SCRIPT_ARGS --network=in-china"
fi

if [ "${TEST_DEBUG:-false}" = "true" ]; then
    test_debug "Using --debug parameter"
    SCRIPT_ARGS="$SCRIPT_ARGS --debug"
fi

test_debug "Final script arguments: $SCRIPT_ARGS"

bash "$SCRIPT_PATH_PRE_1" $SCRIPT_ARGS
bash "$SCRIPT_PATH" $SCRIPT_ARGS
INSTALL_EXIT_CODE=$?

if [ $INSTALL_EXIT_CODE -eq 0 ]; then
    test_success "install-docker.sh script executed successfully (exit code: $INSTALL_EXIT_CODE)"
    TEST_COUNT=$((TEST_COUNT + 1))
    PASSED_COUNT=$((PASSED_COUNT + 1))
else
    test_fail "install-docker.sh script execution failed (exit code: $INSTALL_EXIT_CODE)"
    TEST_COUNT=$((TEST_COUNT + 1))
    FAILED_COUNT=$((FAILED_COUNT + 1))
fi

# Checkpoint 2: Is it installed normally?
test_info "Checkpoint 2: Check if Docker is successfully installed"

# Need to reload environment variables and PATH
export PATH="/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:$PATH"
hash -r  # Recalculate executable file locations

if command -v docker >/dev/null 2>&1; then
    test_success "Docker command has been successfully installed and is available"
    TEST_COUNT=$((TEST_COUNT + 1))
    PASSED_COUNT=$((PASSED_COUNT + 1))
else
    test_fail "Docker command not found, installation may have failed"
    TEST_COUNT=$((TEST_COUNT + 1))
    FAILED_COUNT=$((FAILED_COUNT + 1))
fi

# Checkpoint 3: Can version information be obtained correctly?
test_info "Checkpoint 3: Get and verify Docker version information"

if command -v docker >/dev/null 2>&1; then
    DOCKER_VERSION=$(docker --version 2>&1)
    DOCKER_VERSION_EXIT_CODE=$?
    
    test_info "Docker version information: $DOCKER_VERSION"
    
    if [ $DOCKER_VERSION_EXIT_CODE -eq 0 ] && [[ "$DOCKER_VERSION" == Docker\ version* ]]; then
        test_success "Docker version information obtained successfully: $DOCKER_VERSION"
        TEST_COUNT=$((TEST_COUNT + 1))
        PASSED_COUNT=$((PASSED_COUNT + 1))
    else
        test_fail "Failed to get Docker version information or format is incorrect"
        TEST_COUNT=$((TEST_COUNT + 1))
        FAILED_COUNT=$((FAILED_COUNT + 1))
    fi
else
    test_fail "Cannot get Docker version information because Docker command does not exist"
    TEST_COUNT=$((TEST_COUNT + 1))
    FAILED_COUNT=$((FAILED_COUNT + 1))
fi

# Display test results
show_test_summary
exit $?
