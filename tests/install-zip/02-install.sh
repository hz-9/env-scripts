#!/bin/bash

# Test script - for verifying actual installation functionality of install-zip.sh script

# Import test utility functions
source "$(dirname "$0")/../__base.sh"
source "$(dirname "$0")/../__install.sh"

# Test constants
SCRIPT_PATH="$(dirname "$0")/../../dist/install-zip.sh"
 
unit_test_initing "$@" "--name=install-zip"
checkpoint_check_current_os_is_supported

common_suffix_args=$(unit_test_common_suffix_args)
console_debug_line "Common Suffix Args : $common_suffix_args"

# Run main install script using new common function
checkpoint_with_run_install_script "$SCRIPT_PATH" "$common_suffix_args"

# Need to reload environment variables and PATH
export PATH="/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:$PATH"
hash -r  # Recalculate executable file locations

# Check if zip command is available using new common function
checkpoint_check_command_available "zip"

# Check if unzip command is available
checkpoint_staring "Install script execution result"
if command -v unzip >/dev/null 2>&1; then
    checkpoint_complete
else
    checkpoint_error
fi

# Get and verify zip version information using new common function
ZIP_VERSION=$(zip -v 2>/dev/null | head -2 | tail -1 | awk '{print $4}')
checkpoint_check_software_version "zip" "$ZIP_VERSION"

# Get and verify unzip version information
UNZIP_VERSION=$(unzip -v 2>/dev/null | head -1 | awk '{print $2}')
checkpoint_check_software_version "unzip" "$UNZIP_VERSION"

# Display test results
unit_test_console_summary
exit $?
