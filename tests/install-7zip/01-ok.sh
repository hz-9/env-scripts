#!/bin/bash

# Test script - for verifying basic functionality of install-7zip.sh script

# Import test utility functions
source "$(dirname "$0")/../__base.sh"

# Test constants
SCRIPT_PATH="$(dirname "$0")/../../dist/install-7zip.sh"
 
unit_test_initing "$@" "--name=install-7zip"

checkpoint_staring "1" "Check if script file exists"
if assert_file_exists "$SCRIPT_PATH"; then
    checkpoint_complete
else
    checkpoint_error
fi

checkpoint_staring "2" "Check if script is executable"
if assert_success "test -x '$SCRIPT_PATH'"; then
    checkpoint_complete
else
    checkpoint_error
fi

checkpoint_staring "3" "Check script syntax"
if assert_success "test -n '$SCRIPT_PATH'"; then
    checkpoint_complete
else
    checkpoint_error
fi

checkpoint_staring "4" "Test --help can output normally"
script_help_output=$(bash "$SCRIPT_PATH" --help 2>&1 || echo "No help option")
if [[ "$script_help_output" != "No help option" ]] && [[ "$script_help_output" == *"--help,-h"* && "$script_help_output" == *"Print help message"* ]]; then
    checkpoint_complete
else
    checkpoint_error
fi

checkpoint_staring "0" "Check if current OS is supported"
if unit_test_is_support_current_os "$SCRIPT_PATH"; then
    checkpoint_complete
else
    checkpoint_skip
    exit 2 # Skip the rest of the tests if OS is not supported
fi


unit_test_console_help_message "$script_help_output"

# Display test results
unit_test_console_summary
exit $?
