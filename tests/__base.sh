#!/bin/bash
_m_='♥'

source "$(dirname "$0")/../../tools/__base.sh"

TEST_COUNT=0
PASSED_COUNT=0
FAILED_COUNT=0

{
  # Print current time (seconds)
  console_time_s() {
    local seconds
    seconds=$(date +%s)
    echo $((seconds * 1))
  }
}

checkpoint_time=$(console_time_s)

{
  # # Assert command executes successfully
  assert_success() {
      local command="$1"
            
      if eval "$command" >/dev/null 2>&1; then
          return 0
      else
          return 1
      fi
  }

  # # Assert command execution fails
  # assert_failure() {
  #     local command="$1"
  #     local description="${2:-Command execution failed}"
      
  #     TEST_COUNT=$((TEST_COUNT + 1))
  #     test_log "Executing: $command"
      
  #     if ! eval "$command" >/dev/null 2>&1; then
  #         test_success "$description"
  #         PASSED_COUNT=$((PASSED_COUNT + 1))
  #         return 0
  #     else
  #         test_fail "$description - Expected command to fail but it succeeded"
  #         FAILED_COUNT=$((FAILED_COUNT + 1))
  #         return 1
  #     fi
  # }

  # # Assert strings are equal
  # assert_equals() {
  #     local expected="$1"
  #     local actual="$2"
  #     local description="${3:-strings equal}"
      
  #     TEST_COUNT=$((TEST_COUNT + 1))
      
  #     if [ "$expected" = "$actual" ]; then
  #         test_success "$description"
  #         PASSED_COUNT=$((PASSED_COUNT + 1))
  #         return 0
  #     else
  #         test_fail "$description - expected: '$expected', actual: '$actual'"
  #         FAILED_COUNT=$((FAILED_COUNT + 1))
  #         return 1
  #     fi
  # }

  # # Assert strings are not equal
  # assert_not_equals() {
  #     local expected="$1"
  #     local actual="$2"
  #     local description="${3:-strings not equal}"
      
  #     TEST_COUNT=$((TEST_COUNT + 1))
      
  #     if [ "$expected" != "$actual" ]; then
  #         test_success "$description"
  #         PASSED_COUNT=$((PASSED_COUNT + 1))
  #         return 0
  #     else
  #         test_fail "$description - expected not equal to: '$expected', but actually equal"
  #         FAILED_COUNT=$((FAILED_COUNT + 1))
  #         return 1
  #     fi
  # }

  # Assert file exists
  assert_file_exists() {
      local filepath="$1"
      local description="${2:-file exists: $filepath}"
            
      if [ -f "$filepath" ]; then
          return 0
      else
          return 1
      fi
  }

  # Assert file does not exist
  assert_file_not_exists() {
      local filepath="$1"
            
      if [ ! -f "$filepath" ]; then
          return 0
      else
          return 1
      fi
  }

  # Assert directory exists
  assert_dir_exists() {
      local dirpath="$1"
            
      if [ -d "$dirpath" ]; then
          return 0
      else
          return 1
      fi
  }

  # Assert string contains
  assert_contains() {
      local haystack="$1"
      local needle="$2"
            
      if [[ "$haystack" == *"$needle"* ]]; then
          return 0
      else
          return 1
      fi
  }

  # Assert process is running
  assert_process_running() {
      local process_name="$1"
            
      if pgrep -f "$process_name" >/dev/null; then
          return 0
      else
          return 1
      fi
  }
}

{
  # Clean up test environment
  cleanup_test_env() {
      if [ -n "${TEST_TMP_DIR:-}" ] && [ -d "$TEST_TMP_DIR" ]; then
          log_debug "Cleaning up test environment: $TEST_TMP_DIR"
          rm -rf "$TEST_TMP_DIR"
      fi
  }

  # Set up test environment
  unit_test_initing() {
    parse_user_param "$@"

    # local name="$1"

    # Create temporary test directory
    TEST_TMP_DIR=$(mktemp -d -t env-script-test-XXXXXX)
    export TEST_TMP_DIR
    
    # Set trap to clean up temporary directory
    trap cleanup_test_env EXIT

    local name=""
    local env=""
    local output="false"

    local network="default"
    local debug="false"

    if [ -z "$(get_user_param '--name')" ]; then
        log_error "Test name (--name) is required"
        show_help
        exit 1
    else
        name="$(get_user_param --name)"
    fi

    if [ -z "$(get_user_param '--env')" ]; then
        log_error "Test env (--env) is required"
        show_help
        exit 1
    else
        env="$(get_user_param --env)"
    fi

    if [ -n "$(get_user_param '--network')" ]; then
        network="$(get_user_param '--network')"
    fi

    if [ -n "$(get_user_param '--debug')" ]; then
        debug="$(get_user_param '--debug')"
    fi

    if [ -n "$(get_user_param '--output')" ]; then
        output="$(get_user_param '--output')"
    fi

    # echo -e "\033[0;34m"
    printf '+%s+\n' "$(printf '%0.s-' {1..78})"
    printf "| %-76s |\n" "The unit test is initing..."
    printf "| %-76s |\n" "NAME      : ${name}"
    printf "| %-76s |\n" "TEMP DIR  : ${TEST_TMP_DIR}"
    printf "| %-76s |\n" "ENV       : ${env}"
    printf "| %-76s |\n" "OUTPUT    : ${output}"
    printf "| %-76s |\n" "--network : ${network}"
    printf "| %-76s |\n" "--debug   : ${debug}"
    printf '+%s+\n' "$(printf '%0.s-' {1..78})"
    # echo -e "\033[0m"
    # echo ""
  }

  unit_test_common_suffix_args() {
    local args=""

    if [ -n "$(get_user_param '--network')" ]; then
        args="$args --network=$(get_user_param --network)"
    fi

    if [ -n "$(get_user_param '--debug')" ]; then
        args="$args --debug"
    fi

    # if [ -n "$(get_user_param '--internal-ip')" ]; then
    #     args="$args --internal-ip=$(get_user_param --internal-ip)"
    # fi

    if [ -n "$(get_user_param '--docker-image-quick-check')" ]; then
        args="$args --docker-image-quick-check"
    fi

    echo "$args"
  }

  unit_test_is_support_current_os() {
    local script_path="$1"
    
    # Run the script with --help and check for unsupported OS message
    local help_output
    help_output=$(bash "$script_path" --help 2>&1)
    
    # Check if the help output contains the unsupported OS message
    if echo "$help_output" | grep -q "This shell script does not support the current operating system."; then
        return 1  # Not supported
    else
        return 0  # Supported
    fi
  }

  unit_test_console_help_message() {
    if [ -n "$(get_user_param '--output')" ]; then
        local help_content="$1"
        printf '\n%s\n' "$(printf '%0.s-' {1..80})"
        echo "$script_help_output"
        printf '%s\n' "$(printf '%0.s-' {1..80})"
    fi
  }

  unit_test_console_summary() {
    printf '\n%s\n' "$(printf '%0.s-' {1..80})"
    printf "| %-78s |\n" "📊 Test Unit Summary Report"
    printf '|%s|\n' "$(printf '%0.s-' {1..78})"
    printf "| %-76s |\n" "Total Tests : $TEST_COUNT"
    printf "| %-76s |\n" "Passed      : $PASSED_COUNT"
    printf "| %-76s |\n" "Failed      : $FAILED_COUNT"
    printf '%s\n\n' "$(printf '%0.s-' {1..80})"

    if [ "$FAILED_COUNT" -eq 0 ]; then
        return 0
    else
        return 1
    fi
  }

  checkpoint_staring() {
    checkpoint_time=$(console_time_s)
    local checkpoint_desc="$1"

    TEST_COUNT=$((TEST_COUNT + 1))
    
    printf '+%s+\n' "$(printf '%0.s-' {1..78})"
    printf "| %-76s |\n" "Check     : ${checkpoint_desc}"
  }

  checkpoint_content() {
    local checkpoint_label="$1"
    local checkpoint_version="$2"

    printf "| %-10s:" "${checkpoint_label}"

    printf " %-64s |\n" "${checkpoint_version}"
  }

  checkpoint_complete() {
    checkpoint_current_time=$(console_time_s)
    timeDiff=$((checkpoint_current_time - checkpoint_time))

    PASSED_COUNT=$((PASSED_COUNT + 1))

    printf "| Result    : "
    # shellcheck disable=SC2059
    printf "${GREEN}"
    printf "%-65s" "Success (${timeDiff} seconds)"
    # shellcheck disable=SC2059
    printf "${NC}"
    printf "|\n"
    printf '+%s+\n' "$(printf '%0.s-' {1..78})"
  }

  checkpoint_skip() {
    printf "| Result    : "
    # shellcheck disable=SC2059
    printf "${YELLOW}"
    printf "%-65s" "Skipped"
    # shellcheck disable=SC2059
    printf "${NC}"
    printf "|\n"
    printf '+%s+\n' "$(printf '%0.s-' {1..78})"
  }

  checkpoint_error() {
    FAILED_COUNT=$((FAILED_COUNT + 1))

    printf "| Result    : "
    # shellcheck disable=SC2059
    printf "${RED}"
    printf "%-65s" "Failed"
    # shellcheck disable=SC2059
    printf "${NC}"
    printf "|\n"
    printf '+%s+\n' "$(printf '%0.s-' {1..78})"
  }

  # Set up test environment
  setup_test_env() {
    parse_user_param

    test_info "Setting up test environment..."

    # Create temporary test directory
    TEST_TMP_DIR=$(mktemp -d -t env-script-test-XXXXXX)
    export TEST_TMP_DIR
    
    # Set trap to clean up temporary directory
    trap cleanup_test_env EXIT
    
    test_info "Test temporary directory: $TEST_TMP_DIR"
  }

  checkpoint_check_script_file_exists() {
    local script_path="$1"
    checkpoint_staring "Check if script file exists"
    if assert_file_exists "$script_path"; then
        checkpoint_complete
    else
        checkpoint_error
    fi
  }

  checkpoint_check_script_is_executable() {
    local script_path="$1"
    checkpoint_staring "Check if script is executable"
    if assert_success "test -x '$script_path'"; then
        checkpoint_complete
    else
        checkpoint_error
    fi
  }

  checkpoint_check_script_syntax() {
    local script_path="$1"
    checkpoint_staring "Check script syntax"
    if assert_success "test -n '$script_path'"; then
        checkpoint_complete
    else
        checkpoint_error
    fi
  }

  checkpoint_check_script_help_output() {
    local script_path="$1"
    checkpoint_staring "Test --help can output normally"
    script_help_output=$(bash "$script_path" --help 2>&1 || echo "No help option")
    if [[ "$script_help_output" != "No help option" ]] && [[ "$script_help_output" == *"--help,-h"* && "$script_help_output" == *"Print help message"* ]]; then
        checkpoint_complete
    else
        checkpoint_error
    fi
  }

  checkpoint_check_current_os_is_supported() {
    checkpoint_staring "Check if current OS is supported"
    if unit_test_is_support_current_os "$SCRIPT_PATH"; then
        checkpoint_complete
    else
        checkpoint_skip
        exit 2 # Skip the rest of the tests if OS is not supported
    fi
  }
}