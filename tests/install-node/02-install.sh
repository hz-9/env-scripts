#!/bin/bash

# Test script - for verifying actual installation functionality of install-node.sh script

# Import test utility functions
source "$(dirname "$0")/../__base.sh"

# Test constants
script_path_pre_1="$(dirname "$0")/../../dist/install-curl.sh"
script_path_pre_2="$(dirname "$0")/../../dist/install-git.sh"
script_path="$(dirname "$0")/../../dist/install-node.sh"
 
unit_test_initing "$@" "--name=install-node"

checkpoint_staring "0" "Check if current OS is supported"
if unit_test_is_support_current_os "$script_path"; then
    checkpoint_complete
else
    checkpoint_skip
    exit 2 # Skip the rest of the tests if OS is not supported
fi

common_suffix_args=$(unit_test_common_suffix_args)

log_debug "Common Suffix Args : $common_suffix_args"

bash "$script_path_pre_1" $common_suffix_args
bash "$script_path_pre_2" $common_suffix_args
bash "$script_path" $common_suffix_args
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

checkpoint_staring "2" "Check if Node.js is successfully installed"
if command -v node >/dev/null 2>&1; then
    checkpoint_complete
else
    checkpoint_error
fi

NODE_VERSION=$(node --version)
checkpoint_staring "3" "Get and verify Node.js version information"
if [[ -n "$NODE_VERSION" ]] && [[ "$NODE_VERSION" == v* ]]; then
    checkpoint_complete
else
    checkpoint_error
fi

# Display test results
unit_test_console_summary
exit $?
