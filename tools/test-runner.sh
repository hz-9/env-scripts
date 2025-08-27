#!/bin/bash

# Test Runner - Executes test files with proper environment and reporting
set -e

source tools/__base.sh

# Run a single test script
run_test() {
    local test_script="$1"
    local suffix_args="$2"
    # local network_option="${2:-}"
    # local debug_mode="${3:-false}"
    local test_name
    test_name=$(basename "$test_script" .sh)

    startTime=$(console_time_s)

    echo -e "\033[0;34m"
    printf '+%s+\n' "$(printf '%0.s-' {1..78})"
    printf "| %-76s |\n" "The unit test is starting..."
    printf "| %-76s |\n" "FILE      : ${test_script}"
    printf "| %-76s |\n" "ARGS      : ${suffix_args}"
    printf '+%s+\n' "$(printf '%0.s-' {1..78})"
    echo -e "\033[0m"

    # Create a temporary file to capture output for skip detection
    local temp_output
    temp_output=$(mktemp)

    # Run the test with tee to show real-time output and capture it
    bash "$test_script" $suffix_args 2>&1 | tee "$temp_output"

    local test_exit_code=${PIPESTATUS[0]}  # Get exit code from bash command, not tee
    
    # Read the captured output to check for skip status
    local test_output
    test_output=$(cat "$temp_output")
    rm -f "$temp_output"

    currentTime=$(console_time_s)
    timeDiff=$((currentTime - startTime))

    echo -e "\033[0;34m"
    printf '+%s+\n' "$(printf '%0.s-' {1..78})"
    printf "| %-76s |\n" "The unit test is completed."
    printf "| %-76s |\n" "FILE      : ${test_script}"
    printf "| %-76s |\n" "EXIT      : ${test_exit_code}"
    printf "| %-76s |\n" "TIME      : ${timeDiff} seconds"
    printf '+%s+\n' "$(printf '%0.s-' {1..78})"
    echo -e "\033[0m"
    
    # Check if test was skipped
    if [ $test_exit_code -eq 2 ]; then
        log_warning "The unit test is skipped."
        return 2
    elif [ $test_exit_code -eq 0 ]; then
        log_success "The unit test is passed."
        return 0
    else
        log_error "The unit test is failed."
        return 1
    fi
}

# Show help information
show_help() {
    echo "Usage: $0 [options]"
    echo ""
    echo "Options:"
    echo "  -h, --help           Show this help information"
    echo "  -t, --test-dir DIR   Test directory to run tests from (e.g., tests/install-*, tests/syncdb-*)"
    echo "  -f, --test-file FILE Run specified test file"
    echo "  -s, --script NAME    Run tests for specific script (e.g., git, nginx)"
    echo "  -n, --network NET    Specify network configuration (default|in-china)"
    echo "  -d, --debug          Enable debug mode"
    echo ""
    echo "Examples:"
    echo "  $0 -t tests/install-*                    # Run all install tests"
    echo "  $0 -t tests/syncdb-*                     # Run all syncdb tests"
    echo "  $0 -t tests/install-* -f tests/install-git/01-ok.sh  # Run specific test"
    echo "  $0 -t tests/install-* -s git             # Run all tests for git script"
    echo "  $0 -t tests/install-* -n in-china        # Run with China network config"
}

# Main function
main() {
    local test_file=""
    local suffix_args=""

    parse_user_param "$@"

    # Check required parameters and parse arguments
    if [ "$(get_user_param '--help')" == 'true' ]; then
      show_help
      exit 0
    fi

    if [ -n "$(get_user_param '--file')" ]; then
        test_file="$(get_user_param --file)"
    fi

    if [ -z "$(get_user_param '--env')" ]; then
        log_error "Test env (--env) is required"
        show_help
        exit 1
    else
        env="$(get_user_param --env)"
        suffix_args="$suffix_args--env=$env "
    fi

    if [ -n "$(get_user_param '--network')" ]; then
        suffix_args="$suffix_args--network=$(get_user_param --network) "
    fi

    if [ -n "$(get_user_param '--debug')" ]; then
        suffix_args="$suffix_args--debug "
    fi

    if [ -n "$(get_user_param '--output')" ]; then
        suffix_args="$suffix_args--output "
    fi

    if [ -n "$(get_user_param '--docker-image-quick-check')" ]; then
        suffix_args="$suffix_args--docker-image-quick-check "
    fi

    if [ -n "$(get_user_param '--internal-ip')" ]; then
        suffix_args="$suffix_args--internal-ip=$(get_user_param --internal-ip) "
    fi

    # Execute based on parameters
    if [ -n "$test_file" ]; then
        # Run a specific test file
        if [ ! -f "$test_file" ]; then
            log_error "Test file not found: $test_file"
            return 1
        fi

        set +e  # Temporarily disable exit on error
        run_test "$test_file" "$suffix_args"
        local run_test_exit_code=$?
        set -e  # Re-enable exit on error
        return $run_test_exit_code
    fi

    return 1
}

# Ensure we're in the project root directory
cd "$(dirname "$0")/.."

# Call main function with all script arguments
main "$@"
exit $?
