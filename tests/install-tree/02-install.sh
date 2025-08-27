#!/bin/bash

# Test script - for verifying actual installation functionality of install-tree.sh script

# Import test utility functions
source "$(dirname "$0")/../__base.sh"
source "$(dirname "$0")/../__install.sh"

# Test constants
SCRIPT_PATH="$(dirname "$0")/../../dist/install-tree.sh"
 
unit_test_initing "$@" "--name=install-tree"
checkpoint_check_current_os_is_supported

common_suffix_args=$(unit_test_common_suffix_args)
console_debug_line "Common Suffix Args : $common_suffix_args"

# Run main install script using new common function
checkpoint_with_run_install_script "$SCRIPT_PATH" "$common_suffix_args"

# Need to reload environment variables and PATH
export PATH="/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:$PATH"
hash -r  # Recalculate executable file locations

# Check if command is available using new common function
checkpoint_check_command_available "tree"

# Get and verify version information using new common function
TREE_VERSION=$(tree --version | head -1 | awk '{print $2}')
checkpoint_check_software_version "tree" "$TREE_VERSION"

# Display test results
unit_test_console_summary
exit $?
