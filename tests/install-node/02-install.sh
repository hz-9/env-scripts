#!/bin/bash

# Test script - for verifying actual installation functionality of install-node.sh script

# Import test utility functions
source "$(dirname "$0")/../__base.sh"
source "$(dirname "$0")/../__install.sh"

# Test constants
script_path_pre_1="$(dirname "$0")/../../dist/install-curl.sh"
script_path_pre_2="$(dirname "$0")/../../dist/install-git.sh"
script_path="$(dirname "$0")/../../dist/install-node.sh"
 
unit_test_initing "$@" "--name=install-node"
checkpoint_check_current_os_is_supported

common_suffix_args=$(unit_test_common_suffix_args)
log_debug "Common Suffix Args : $common_suffix_args"

# Install prerequisite packages
bash "$script_path_pre_1" $common_suffix_args
bash "$script_path_pre_2" $common_suffix_args

# Run main install script using new common function
checkpoint_with_run_install_script "$script_path" "$common_suffix_args"

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

# Check if command is available using new common function
checkpoint_check_command_available "node"

# Get and verify version information using new common function
NODE_VERSION=$(node --version)
checkpoint_check_software_version "Node.js" "$NODE_VERSION"

# Display test results
unit_test_console_summary
exit $?
