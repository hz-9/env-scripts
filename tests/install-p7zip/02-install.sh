#!/bin/bash

# Test script - for verifying actual installation functionality of install-p7zip.sh script

# Import test utility functions
source "$(dirname "$0")/../__base.sh"
source "$(dirname "$0")/../__install.sh"

# Test constants
SCRIPT_PATH="$(dirname "$0")/../../dist/install-p7zip.sh"
 
unit_test_initing "$@" "--name=install-p7zip"
checkpoint_check_current_os_is_supported

common_suffix_args=$(unit_test_common_suffix_args)

log_debug "Common Suffix Args : $common_suffix_args"

# Run main install script using new common function
checkpoint_with_run_install_script "$SCRIPT_PATH" "$common_suffix_args"

# Need to reload environment variables and PATH
export PATH="/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:$PATH"
hash -r  # Recalculate executable file locations

# Check if p7zip commands are available (7z or 7za)
checkpoint_staring "Install script execution result"
if command -v 7z >/dev/null 2>&1 || command -v 7za >/dev/null 2>&1; then
    checkpoint_complete
else
    checkpoint_error
fi

# Get and verify p7zip version information
P7ZIP_VERSION=""
if command -v 7z >/dev/null 2>&1; then
    P7ZIP_VERSION=$(7z | head -3 | tail -1 | awk '{print $3}')
elif command -v 7za >/dev/null 2>&1; then
    P7ZIP_VERSION=$(7za | head -3 | tail -1 | awk '{print $3}')
fi

checkpoint_check_software_version "p7zip" "$P7ZIP_VERSION"

# Display test results
unit_test_console_summary
exit $?
