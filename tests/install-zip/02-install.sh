#!/bin/bash

# Test script - for verifying actual installation functionality of install-zip.sh script

# Import test utility functions
source "$(dirname "$0")/../__base.sh"

# Test constants
SCRIPT_PATH="$(dirname "$0")/../../dist/install-zip.sh"
 
unit_test_initing "$@" "--name=install-zip"

checkpoint_staring "0" "Check if current OS is supported"
if unit_test_is_support_current_os "$SCRIPT_PATH"; then
    checkpoint_complete
else
    checkpoint_skip
    exit 2 # Skip the rest of the tests if OS is not supported
fi

common_suffix_args=$(unit_test_common_suffix_args)

log_debug "Common Suffix Args : $common_suffix_args"

bash "$SCRIPT_PATH" $common_suffix_args
INSTALL_EXIT_CODE=$?

checkpoint_staring "1" "Install script execution result"
if [ $INSTALL_EXIT_CODE -eq 0 ]; then
    checkpoint_complete
elif [ $INSTALL_EXIT_CODE -eq 2 ]; then
    checkpoint_skip
    exit 2 # Skip the rest of the tests if OS is not supported
else
    checkpoint_error
fi

# Need to reload environment variables and PATH
export PATH="/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:$PATH"
hash -r  # Recalculate executable file locations

checkpoint_staring "2" "Check if zip/unzip utilities are successfully installed"
if command -v zip >/dev/null 2>&1 && command -v unzip >/dev/null 2>&1; then
    checkpoint_complete
else
    checkpoint_error
fi

ZIP_VERSION=$(zip -v 2>/dev/null | head -2 | tail -1 | awk '{print $4}')
checkpoint_staring "3" "Get and verify zip version information"
if [[ -n "$ZIP_VERSION" ]]; then
    checkpoint_content "Version" "$ZIP_VERSION"
    checkpoint_complete
else
    checkpoint_error
fi

UNZIP_VERSION=$(unzip -v 2>/dev/null | head -1 | awk '{print $2}')
checkpoint_staring "3" "Get and verify unzip version information"
if [[ -n "$UNZIP_VERSION" ]]; then
    checkpoint_content "Version" "$UNZIP_VERSION"
    checkpoint_complete
else
    checkpoint_error
fi

# Display test results
unit_test_console_summary
exit $?
