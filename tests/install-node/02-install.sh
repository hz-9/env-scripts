#!/bin/bash

# Test script - for verifying actual installation functionality of install-node.sh script

# Import test utility functions
source "$(dirname "$0")/../test-utils.sh"

# Test constants
SCRIPT_PATH_PRE_1="$(dirname "$0")/../../dist/install-curl.sh"
SCRIPT_PATH_PRE_2="$(dirname "$0")/../../dist/install-git.sh"
SCRIPT_PATH="$(dirname "$0")/../../dist/install-node.sh"

# Setup test environment
setup_test_env

test_info "Starting tests for install-node.sh script actual installation functionality"

# Checkpoint 0: Check if OS is supported
test_info "Checkpoint 0: Check if current OS is supported"
if ! is_os_supported "$SCRIPT_PATH"; then
    skip_test_with_summary "Current OS is not supported for Node.js installation"
fi
test_success "Current OS is supported for Node.js installation"

# Checkpoint 1: Does the file run correctly?
test_info "Checkpoint 1: Test if script can execute correctly"
test_info "install-node.sh execution log (real-time output):"

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
bash "$SCRIPT_PATH"       $SCRIPT_ARGS
INSTALL_EXIT_CODE=$?

if [ $INSTALL_EXIT_CODE -eq 0 ]; then
    test_success "install-node.sh script executed successfully (exit code: $INSTALL_EXIT_CODE)"
    TEST_COUNT=$((TEST_COUNT + 1))
    PASSED_COUNT=$((PASSED_COUNT + 1))
else
    test_fail "install-node.sh script execution failed (exit code: $INSTALL_EXIT_CODE)"
    TEST_COUNT=$((TEST_COUNT + 1))
    FAILED_COUNT=$((FAILED_COUNT + 1))
fi

# Checkpoint 2: Is it installed normally?
test_info "Checkpoint 2: Check if Node.js is successfully installed"

# Load NVM environment to access node command
export NVM_DIR="$HOME/.nvm"
# Source NVM if available
if [ -s "$NVM_DIR/nvm.sh" ]; then
    source "$NVM_DIR/nvm.sh"
fi
if [ -s "$NVM_DIR/bash_completion" ]; then
    source "$NVM_DIR/bash_completion"
fi

# Need to reload environment variables and PATH
export PATH="/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:$PATH"
hash -r  # Recalculate executable file locations

if command -v node >/dev/null 2>&1; then
    test_success "node command has been successfully installed and is available"
    TEST_COUNT=$((TEST_COUNT + 1))
    PASSED_COUNT=$((PASSED_COUNT + 1))
else
    test_fail "node command not found, installation may have failed"
    TEST_COUNT=$((TEST_COUNT + 1))
    FAILED_COUNT=$((FAILED_COUNT + 1))
fi

# Checkpoint 3: Can version information be obtained correctly?
test_info "Checkpoint 3: Get and verify Node.js version information"

if command -v node >/dev/null 2>&1; then
    NODE_VERSION=$(node --version 2>&1)
    NODE_VERSION_EXIT_CODE=$?
    
    test_info "Node.js version information: $NODE_VERSION"
    
    if [ $NODE_VERSION_EXIT_CODE -eq 0 ] && [[ "$NODE_VERSION" == v* ]]; then
        test_success "Node.js version information obtained successfully: $NODE_VERSION"
        TEST_COUNT=$((TEST_COUNT + 1))
        PASSED_COUNT=$((PASSED_COUNT + 1))
    else
        test_fail "Failed to get Node.js version information or format is incorrect"
        TEST_COUNT=$((TEST_COUNT + 1))
        FAILED_COUNT=$((FAILED_COUNT + 1))
    fi
else
    test_fail "Cannot get Node.js version information because node command does not exist"
    TEST_COUNT=$((TEST_COUNT + 1))
    FAILED_COUNT=$((FAILED_COUNT + 1))
fi

if command -v npm >/dev/null 2>&1; then
    NPM_VERSION=$(npm --version 2>&1)
    NPM_VERSION_EXIT_CODE=$?
    
    test_info "npm version information: $NPM_VERSION"
    
    if [ $NPM_VERSION_EXIT_CODE -eq 0 ] && [[ "$NPM_VERSION" =~ ^[0-9]+(\.[0-9]+)*$ ]]; then
        test_success "npm version information obtained successfully: $NPM_VERSION"
        TEST_COUNT=$((TEST_COUNT + 1))
        PASSED_COUNT=$((PASSED_COUNT + 1))
    else
        test_fail "Failed to get npm version information or format is incorrect"
        TEST_COUNT=$((TEST_COUNT + 1))
        FAILED_COUNT=$((FAILED_COUNT + 1))
    fi
else
    test_fail "Cannot get npm version information because npm command does not exist"
    TEST_COUNT=$((TEST_COUNT + 1))
    FAILED_COUNT=$((FAILED_COUNT + 1))
fi  

# Display test results
show_test_summary
exit $?
