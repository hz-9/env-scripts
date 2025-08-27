#!/bin/bash

# Test Environment Manager - Coordinates test execution across different OS environments
# We don't set -x here, we only pass the DEBUG parameter to the actual test scripts
set -e

source tools/__base.sh

startTime=$(console_time_s)

# Get project root directory
root=$(cd "$(dirname "$0")" || exit; dirname "$(pwd)")

# OS environments to test
OS_ENVIRONMENTS=(
    "ubuntu20-04"
    "ubuntu22-04"
    "ubuntu24-04"
    "debian11-9"
    "debian12-2"
    "fedora41"
    "redhat8-10"
    "redhat9-6"
)

# # Get OS display name function (instead of associative array for bash 3 compatibility)
# get_os_display_name() {
#     local env="$1"
#     case "$env" in
#         "ubuntu20") echo "Ubuntu 20.04" ;;
#         "ubuntu22") echo "Ubuntu 22.04" ;;
#         "ubuntu24") echo "Ubuntu 24.04" ;;
#         "debian11-9") echo "Debian 11.9 Bullseye" ;;
#         "debian12-2") echo "Debian 12.2 Bookworm" ;;
#         "fedora41") echo "Fedora 41" ;;
#         "redhat8-10") echo "RedHat Enterprise Linux 8.10 (UBI8)" ;;
#         "redhat9-6") echo "RedHat Enterprise Linux 9.6 (UBI9)" ;;
#         *) echo "Unknown Environment" ;;
#     esac
# }

total_unit_tests=0
passed_unit_tests=0
failed_unit_tests=0
skipped_unit_tests=0

failed_environments=()

# Run tests in a specific environment
run_test_in_environment() {
  local scope="$1"
  local env="$2"
  local runner_args="$3"

  # If scope = 'syncdb' then env = '${scope}-docker'
  if [ "$scope" = "syncdb" ]; then
      env="${env}-docker"
  fi

  # local display_name=$(get_os_display_name "$env")
  
  # # echo ""
  # # echo "==================== $display_name ===================="
  # # echo ""
  
  # Remove single quotes from runner_args before passing to docker
  runner_args="${runner_args//\'}"

  set +e  # Temporarily disable exit on error
  docker-compose -f docker/docker-compose.yml run --rm "$env" /app/tools/test-runner.sh $runner_args
  local docker_compose_exit_code=$?
  set -e  # Re-enable exit on error

  # echo "docker_compose_exit_code: $docker_compose_exit_code"

  total_unit_tests=$((total_unit_tests + 1))
  if [ $docker_compose_exit_code -eq 0 ]; then
     # echo "Tests in environment '$env' passed."
     passed_unit_tests=$((passed_unit_tests + 1))
    #  return 0
  elif [ $docker_compose_exit_code -eq 2 ]; then
    skipped_unit_tests=$((skipped_unit_tests + 1))
    # echo "Tests in environment '$env' skipped."
    # return 2
  else
    failed_unit_tests=$((failed_unit_tests + 1))
    failed_environments+=("${env}${_m_}${runner_args}")
    # echo "Tests in environment '$env' failed."
    # return 1
  fi
}

run_tests_in_environment() {
  local scope="$1"
  local env="$2"
  local test_script="$3"
  local suffix_args="$4"

  local scan_dir="${root}/tests/$test_script"
  local test_dir_name="tests/$test_script"
  log_info "Scan Dir         : $scan_dir"

  if [ ! -d "$scan_dir" ]; then
    log_error "Test script directory does not exist: $scan_dir"
  else
    # Loop through all files in the directory
    for file in "$scan_dir"/*; do
      if [[ -f "$file" ]] && [[ "$(basename "$file")" != _* ]]; then
        local test_file="${test_dir_name}/$(basename "$file")"
        local runner_args="--file=$test_file $suffix_args"
        log_info "Runner ARGS      : $runner_args"
        # Run specific test file
        run_test_in_environment "$scope" "$env" "$runner_args"
      fi
    done
  fi
}

run_all_tests_in_environment() {
  local scope="$1"
  local env="$2"
  local suffix_args="$3"

  local scan_dir="${root}/tests"

  log_info "Scan Dir         : $scan_dir"

  if [ ! -d "$scan_dir" ]; then
    log_error "Test script directory does not exist: $scan_dir"
  else
    for file in "$scan_dir"/*; do
      # If scope = install, only run tests under tests/install-* directories
      if [ -n "$scope" ] && [[ "$(basename "$file")" = "$scope"* ]]; then
        run_tests_in_environment "$scope" "$env" "$(basename "$file")" "$suffix_args"
      fi
    done
  fi
}

run_tests_in_all_nvironment() {
  local scope="$1"
  local test_script="$2"
  local suffix_args="$3"

  # Iterate through OS_ENVIRONMENTS array
  for env in "${OS_ENVIRONMENTS[@]}"; do
    run_tests_in_environment "$scope" "$env" "$test_script" "$suffix_args --env=$env"
  done
}

run_all_tests_in_all_nvironment() {
  local scope="$1"
  local suffix_args="$2"

  # Iterate through OS_ENVIRONMENTS array
  for env in "${OS_ENVIRONMENTS[@]}"; do
    run_all_tests_in_environment "$scope" "$env" "$suffix_args --env=$env"
  done
}

# Show help information
show_help() {
    echo "Usage: $0 [options]"
    echo ""
    echo "Options:"
    echo "  -h, --help                Show this help information"
    echo "  -m, --mode MODE          Test mode (all|all-sys|all-script|single)"
    echo "  -t, --test-dir DIR       Test directory (e.g., tests/install-*, tests/syncdb-*)"
    echo "  -f, --test-file FILE     Run specified test file (for single mode)"
    echo "  -e, --env ENV            Environment to test in (for all-script and single modes)"
    echo "  -s, --script NAME        Script name to test (for all-sys and single modes)"
    echo "  -n, --network NET        Specify network configuration (default|in-china)"
    echo "  -d, --debug              Pass debug flag to tested scripts (only affects the tested scripts, not the test framework)"
    echo "  --no-debug               Disable debug mode (overrides DEBUG environment variable)"
    echo ""
    echo "Examples:"
    echo "  $0 -m all -t tests/install-*                  # Run all install tests in all environments"
    echo "  $0 -m all-sys -t tests/install-* -s git       # Run git tests in all environments"
    echo "  $0 -m all-script -t tests/install-* -e ubuntu22-04  # Run all tests in Ubuntu 22.04"
    echo "  $0 -m single -t tests/install-* -e ubuntu22-04 -s git  # Run git tests in Ubuntu 22.04"
    echo "  $0 -m single -f tests/install-git/01-ok.sh -e ubuntu22-04  # Run specific test"
}

unit_test_console_summary() {
    currentTime=$(console_time_s)
    timeDiff=$((currentTime - startTime))

    echo -e "\033[0;34m"
    printf '+%s+\n' "$(printf '%0.s-' {1..78})"
    printf "| %-78s |\n" "📊 Final Test Summary Report"
    printf '|%s|\n' "$(printf '%0.s-' {1..78})"
    printf "| %-76s |\n" "Total unit test : $total_unit_tests"
    printf "| %-76s |\n" "Passed          : $passed_unit_tests"
    printf "| %-76s |\n" "Skipped         : $skipped_unit_tests"
    printf "| %-76s |\n" "Failed          : $failed_unit_tests"
    printf "| %-76s |\n" "TIME            : $timeDiff seconds"
    printf '+%s+' "$(printf '%0.s-' {1..78})"
    echo -e "\033[0m"

    if [ "$failed_unit_tests" -eq 0 ]; then
        return 0
    else
        echo -e "\033[0;31m"
        printf '+%s+\n' "$(printf '%0.s-' {1..78})"
        printf "| %-77s |\n" "❌  Failed Environment"
        printf "+%s+\n" "$(printf '%0.s-' {1..78})"

        # failed_environments
        for env in "${failed_environments[@]}"; do
          local _env _args
          parse_param_2fields "$env" _env _args
          printf "| %-76s |\n" "Env  : $_env"
          printf "| %-76s |\n" "Args : $_args"
          printf "+%s+\n" "$(printf '%0.s-' {1..78})"
        done
        echo -e "\033[0m"

        return 1
    fi
}

main() {
    local mode=""
    local test_file=""
    local test_script=""
    local env=""
    local suffix_args=""
    # local script_name=""
    # local network_option=""
    # local debug_option="false"

    parse_user_param "$@"

    # Check required parameters and parse arguments
    if [ "$(get_user_param '--help')" == 'true' ]; then
      show_help
      exit 0
    fi

    if [ -z "$(get_user_param '--mode')" ]; then
        log_error "Test mode (--mode) is required"
        show_help
        exit 1
    else
        mode="$(get_user_param --mode)"
    fi

    if [ -n "$(get_user_param '--env')" ]; then
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

    if [ -n "$(get_user_param '--file')" ]; then
        test_file="$(get_user_param --file)"
    fi

    if [ -n "$(get_user_param '--script')" ]; then
        test_script="$(get_user_param --script)"
    fi

    # Add internal IP to suffix_args
    internal_ip=$(ifconfig | grep 'inet ' | grep -v '127.0.0.1' | awk '{print $2}' | head -n 1)
    suffix_args="$suffix_args--internal-ip=$internal_ip "

    scope="$(get_user_param '--scope')"

    log_info "Env Manager ARGS : $suffix_args"
    
    # Execute tests based on mode
    case "$mode" in

        all)
            log_info "Suffix ARGS      : $suffix_args"
            run_all_tests_in_all_nvironment "$scope" "$suffix_args"
            unit_test_console_summary
            ;;
        all-env)
            log_info "Suffix ARGS      : $suffix_args"
            run_tests_in_all_nvironment "$scope" "$test_script" "$suffix_args"
            unit_test_console_summary
            ;;
        all-script)
            log_info "Suffix ARGS      : $suffix_args"
            run_all_tests_in_environment "$scope" "$env" "$suffix_args"
            unit_test_console_summary
            ;;
        single)
            if [ -n "$test_file" ]; then
                local runner_args="--file=$test_file $suffix_args"
                log_info "Runner ARGS      : $runner_args"
                run_test_in_environment "$scope" "$env" "$runner_args"
            elif [ -n "$test_script" ]; then
                log_info "Suffix ARGS      : $suffix_args"
                run_tests_in_environment "$scope" "$env" "$test_script" "$suffix_args"
                unit_test_console_summary
            else
                log_error "Either test script (--test-script) or test file (--test-file) is required"
                show_help
                exit 1
            fi
            ;;
        *)
            log_error "Unknown test mode: $mode"
            log_error "Unknown test mode 1: $test_file"
            log_error "Unknown test mode 2: $suffix_args"
            show_help
            exit 1
            ;;
    esac
}

# Ensure we're in the project root directory
cd "$(dirname "$0")/.."

# Call main function with all script arguments
main "$@"
exit $?
