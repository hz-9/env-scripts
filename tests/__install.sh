#!/bin/bash

# Install test utility functions
# This file contains common functions for install test scripts

checkpoint_with_run_install_script() {
    local script_path="$1"
    local suffix_args="$2"
    checkpoint_staring "Run install script"
    if [ -n "$(get_user_param '--output')" ]; then
        bash "$script_path" $suffix_args
    else
        bash "$script_path" $suffix_args > /dev/null 2>&1
    fi
    INSTALL_EXIT_CODE=$?
    if [ $INSTALL_EXIT_CODE -eq 0 ]; then
        checkpoint_complete
    elif [ $INSTALL_EXIT_CODE -eq 2 ]; then
        checkpoint_skip
        exit 2 # Skip the rest of the tests if OS is not supported
    else
        checkpoint_error
    fi
}

checkpoint_check_command_available() {
    local command_name="$1"
    checkpoint_staring "Install script execution result"
    if command -v "$command_name" >/dev/null 2>&1; then
        checkpoint_complete
    else
        checkpoint_error
    fi
}

checkpoint_check_software_version() {
    local software_name="$1"
    local software_version="$2"
    checkpoint_staring "Get and verify ${software_name} version information"
    if [[ -n "$software_version" ]]; then
        checkpoint_content "Version" "$software_version"
        checkpoint_complete
    else
        checkpoint_error
    fi
}

checkpoint_with_run_syncdb_script() {
    local script_path="$1"
    local final_args="$2"
    checkpoint_staring "Run sync scripts"
    if [ -n "$(get_user_param '--output')" ]; then
        bash "$script_path" $final_args
    else
        bash "$script_path" $final_args > /dev/null 2>&1
    fi
    INSTALL_EXIT_CODE=$?
    if [ $INSTALL_EXIT_CODE -eq 0 ]; then
        checkpoint_complete
    elif [ $INSTALL_EXIT_CODE -eq 2 ]; then
        checkpoint_skip
        exit 2 # Skip the rest of the tests if OS is not supported
    else
        checkpoint_error
    fi
}