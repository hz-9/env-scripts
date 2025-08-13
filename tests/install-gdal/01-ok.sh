#!/bin/bash

# Test script - for verifying basic functionality of install-gdal.sh script

# Import test utility functions
source "$(dirname "$0")/../test-utils.sh"

# Test constants
SCRIPT_PATH="$(dirname "$0")/../../dist/install-gdal.sh"

# Setup test environment
setup_test_env

test_info "Starting tests for install-gdal.sh script"

# Checkpoint 0: Check if OS is supported
test_info "Checkpoint 0: Check if current OS is supported"
if ! is_os_supported "$SCRIPT_PATH"; then
    skip_test_with_summary "Current OS is not supported for GDAL installation"
fi
test_success "Current OS is supported for GDAL installation"

# Checkpoint 1: Check if script file exists
assert_file_exists "$SCRIPT_PATH" "install-gdal.sh script file exists"

# Checkpoint 2: Check if script is executable
assert_success "test -x '$SCRIPT_PATH'" "install-gdal.sh script has execute permission"

# Checkpoint 3: Check script syntax
assert_success "bash -n '$SCRIPT_PATH'" "install-gdal.sh script syntax is correct"

# Checkpoint 4: Test --help can output normally
test_info "Testing script output format..."
# Capture script output
script_output=$(bash "$SCRIPT_PATH" --help 2>&1 || echo "No help option")
# Check if output contains expected content
if [[ "$script_output" != "No help option" ]]; then
    assert_contains "$script_output" "gdal" "Script output contains gdal-related information"
fi

# Checkpoint 5: Output --help information
test_info "Testing script help information output..."
# Display help information
script_help=$(bash "$SCRIPT_PATH" --help 2>&1)
# Check if it contains key parts of help options
if [[ "$script_help" == *"--help,-h"* && "$script_help" == *"Print help message"* ]]; then
    assert_success "echo '''$script_help\n\n'''" "Script help information output is correct"
else
    assert_failure "echo '''$script_help\n\n'''" "Script help information output is incorrect"
fi

# Display test results
show_test_summary
exit $?
