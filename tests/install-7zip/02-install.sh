#!/bin/bash

# Test script - for verifying actual installation functionality of install-7zip.sh script

# Import test utility functions
source "$(dirname "$0")/../test-utils.sh"

# Test constants
SCRIPT_PATH_PRE_1="$(dirname "$0")/../../dist/install-xz.sh"
SCRIPT_PATH_PRE_2="$(dirname "$0")/../../dist/install-curl.sh"
SCRIPT_PATH="$(dirname "$0")/../../dist/install-7zip.sh"

# Setup test environment
setup_test_env

test_info "Starting tests for install-7zip.sh script actual installation functionality"

# Checkpoint 0: Check if OS is supported
test_info "Checkpoint 0: Check if current OS is supported"
if ! is_os_supported "$SCRIPT_PATH"; then
    skip_test_with_summary "Current OS is not supported for 7Zip installation"
fi
test_success "Current OS is supported for 7Zip installation"

# Checkpoint 1: Does the file run correctly?
test_info "Checkpoint 1: Test if script can execute correctly"
test_info "install-7zip.sh execution log (real-time output):"

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
bash "$SCRIPT_PATH_PRE_2" $SCRIPT_ARGS
bash "$SCRIPT_PATH" $SCRIPT_ARGS
INSTALL_EXIT_CODE=$?

if [ $INSTALL_EXIT_CODE -eq 0 ]; then
    test_success "install-7zip.sh script executed successfully (exit code: $INSTALL_EXIT_CODE)"
    TEST_COUNT=$((TEST_COUNT + 1))
    PASSED_COUNT=$((PASSED_COUNT + 1))
else
    test_fail "install-7zip.sh script execution failed (exit code: $INSTALL_EXIT_CODE)"
    TEST_COUNT=$((TEST_COUNT + 1))
    FAILED_COUNT=$((FAILED_COUNT + 1))
fi

# Checkpoint 2: Is it installed normally?
test_info "Checkpoint 2: Check if 7Zip is successfully installed"

# Need to reload environment variables and PATH
export PATH="/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:$PATH"
hash -r  # Recalculate executable file locations

if command -v 7zz >/dev/null 2>&1; then
    test_success "7Zip command has been successfully installed and is available"
    TEST_COUNT=$((TEST_COUNT + 1))
    PASSED_COUNT=$((PASSED_COUNT + 1))
else
    test_fail "7Zip command not found, installation may have failed"
    TEST_COUNT=$((TEST_COUNT + 1))
    FAILED_COUNT=$((FAILED_COUNT + 1))
fi

# Checkpoint 3: Can version information be obtained correctly?
test_info "Checkpoint 3: Get and verify 7Zip version information"

if command -v 7zz >/dev/null 2>&1; then
    Z7_VERSION=$(7zz --version 2>&1 | head -n 2)
    Z7_VERSION_EXIT_CODE=$?
    
    test_info "7Zip version information: $Z7_VERSION"
    
    if [ $Z7_VERSION_EXIT_CODE -eq 0 ]; then
        test_success "7Zip version information obtained successfully: $Z7_VERSION"
        TEST_COUNT=$((TEST_COUNT + 1))
        PASSED_COUNT=$((PASSED_COUNT + 1))
    else
        test_fail "Failed to get 7Zip version information or format is incorrect"
        TEST_COUNT=$((TEST_COUNT + 1))
        FAILED_COUNT=$((FAILED_COUNT + 1))
    fi
else
    test_fail "Cannot get 7Zip version information because 7Zip command does not exist"
    TEST_COUNT=$((TEST_COUNT + 1))
    FAILED_COUNT=$((FAILED_COUNT + 1))
fi

# Display test results
show_test_summary
exit $?
