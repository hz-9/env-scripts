#!/bin/bash

# Test script - for verifying basic functionality of syncdb-mysql.sh script

# Import test utility functions
source "$(dirname "$0")/../__base.sh"
source "$(dirname "$0")/../__install.sh"

# Test constants
SCRIPT_PATH="$(dirname "$0")/../../dist/syncdb-mysql.sh"

unit_test_initing "$@" "--name=syncdb-mysql"

checkpoint_check_script_file_exists "$SCRIPT_PATH"
checkpoint_check_script_is_executable "$SCRIPT_PATH"
checkpoint_check_script_syntax "$SCRIPT_PATH"
checkpoint_check_script_help_output "$SCRIPT_PATH"
checkpoint_check_current_os_is_supported

unit_test_console_help_message "$script_help_output"

# Display test results
unit_test_console_summary
exit $?
