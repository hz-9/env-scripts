#!/bin/bash

# Test script - for verifying actual installation functionality of install-7zip.sh script

# Import test utility functions
source "$(dirname "$0")/../__base.sh"
source "$(dirname "$0")/../__install.sh"

# Test constants
SCRIPT_PATH_PRE_1="$(dirname "$0")/../../dist/install-xz.sh"
SCRIPT_PATH_PRE_2="$(dirname "$0")/../../dist/install-curl.sh"
SCRIPT_PATH="$(dirname "$0")/../../dist/install-7zip.sh"
 
unit_test_initing "$@" "--name=install-7zip"
checkpoint_check_current_os_is_supported

common_suffix_args=$(unit_test_common_suffix_args)
log_debug "Common Suffix Args : $common_suffix_args"

# Install prerequisite packages
bash "$SCRIPT_PATH_PRE_1" $common_suffix_args
bash "$SCRIPT_PATH_PRE_2" $common_suffix_args

# Run main install script using new common function
checkpoint_with_run_install_script "$SCRIPT_PATH" "$common_suffix_args"

# Need to reload environment variables and PATH
export PATH="/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:$PATH"
hash -r  # Recalculate executable file locations

# Check if command is available using new common function
checkpoint_check_command_available "7zz"

# Get and verify version information using new common function
Z7_VERSION=$(7zz | head -n 2 | tail -n 1 | awk '{print $3}')
checkpoint_check_software_version "7zip" "$Z7_VERSION"

# Display test results
unit_test_console_summary
exit $?
