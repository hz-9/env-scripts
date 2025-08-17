#!/bin/bash

# Test script - for verifying actual installation functionality of install-p7zip.sh script

# Import test utility functions
source "$(dirname "$0")/../__base.sh"

# Test constants
SCRIPT_PATH="$(dirname "$0")/../../dist/install-p7zip.sh"
 
unit_test_initing "$@" "--name=install-p7zip"

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

checkpoint_staring "2" "Check if p7zip is successfully installed"
if command -v 7z >/dev/null 2>&1 || command -v 7za >/dev/null 2>&1; then
    checkpoint_complete
else
    checkpoint_error
fi

P7ZIP_VERSION=""
if command -v 7z >/dev/null 2>&1; then
    P7ZIP_VERSION=$(7z | head -3 | tail -1 | awk '{print $3}')
elif command -v 7za >/dev/null 2>&1; then
    P7ZIP_VERSION=$(7za | head -3 | tail -1 | awk '{print $3}')
fi

checkpoint_staring "3" "Get and verify p7zip version information"
if [[ -n "$P7ZIP_VERSION" ]]; then
    checkpoint_complete
else
    checkpoint_error
fi

# Display test results
unit_test_console_summary
exit $?
