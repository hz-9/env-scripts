#!/bin/bash

# Test utility function library
# Provides common test assertions and utility functions

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# Test status
TEST_COUNT=0
PASSED_COUNT=0
FAILED_COUNT=0

# Debug function
test_debug() {
    if [ "${TEST_DEBUG:-false}" = "true" ]; then
        echo -e "${PURPLE}[DEBUG]${NC} $1"
    fi
}

# Log functions
test_log() {
    echo -e "${BLUE}[TEST]${NC} $1"
}

test_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

test_success() {
    echo -e "${GREEN}[PASS]${NC} $1"
}

test_fail() {
    echo -e "${RED}[FAIL]${NC} $1"
}

test_warning() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

# Skip entire test with summary
skip_test_with_summary() {
    local reason="$1"
    echo -e "${YELLOW}[SKIP]${NC} $reason"
    exit 2
}

# 断言函数

# Assert command executes successfully
assert_success() {
    local command="$1"
    local description="${2:-Command executed successfully}"
    
    TEST_COUNT=$((TEST_COUNT + 1))
    test_log "Executing: $command"
    
    if eval "$command" >/dev/null 2>&1; then
        test_success "$description"
        PASSED_COUNT=$((PASSED_COUNT + 1))
        return 0
    else
        test_fail "$description - Command execution failed"
        FAILED_COUNT=$((FAILED_COUNT + 1))
        return 1
    fi
}

# Assert command execution fails
assert_failure() {
    local command="$1"
    local description="${2:-Command execution failed}"
    
    TEST_COUNT=$((TEST_COUNT + 1))
    test_log "Executing: $command"
    
    if ! eval "$command" >/dev/null 2>&1; then
        test_success "$description"
        PASSED_COUNT=$((PASSED_COUNT + 1))
        return 0
    else
        test_fail "$description - Expected command to fail but it succeeded"
        FAILED_COUNT=$((FAILED_COUNT + 1))
        return 1
    fi
}

# Assert strings are equal
assert_equals() {
    local expected="$1"
    local actual="$2"
    local description="${3:-字符串相等}"
    
    TEST_COUNT=$((TEST_COUNT + 1))
    
    if [ "$expected" = "$actual" ]; then
        test_success "$description"
        PASSED_COUNT=$((PASSED_COUNT + 1))
        return 0
    else
        test_fail "$description - 期望: '$expected', 实际: '$actual'"
        FAILED_COUNT=$((FAILED_COUNT + 1))
        return 1
    fi
}

# 断言字符串不相等
assert_not_equals() {
    local expected="$1"
    local actual="$2"
    local description="${3:-字符串不相等}"
    
    TEST_COUNT=$((TEST_COUNT + 1))
    
    if [ "$expected" != "$actual" ]; then
        test_success "$description"
        PASSED_COUNT=$((PASSED_COUNT + 1))
        return 0
    else
        test_fail "$description - 期望不等于: '$expected', 但实际相等"
        FAILED_COUNT=$((FAILED_COUNT + 1))
        return 1
    fi
}

# 断言文件存在
assert_file_exists() {
    local filepath="$1"
    local description="${2:-文件存在: $filepath}"
    
    TEST_COUNT=$((TEST_COUNT + 1))
    
    if [ -f "$filepath" ]; then
        test_success "$description"
        PASSED_COUNT=$((PASSED_COUNT + 1))
        return 0
    else
        test_fail "$description - 文件不存在"
        FAILED_COUNT=$((FAILED_COUNT + 1))
        return 1
    fi
}

# 断言文件不存在
assert_file_not_exists() {
    local filepath="$1"
    local description="${2:-文件不存在: $filepath}"
    
    TEST_COUNT=$((TEST_COUNT + 1))
    
    if [ ! -f "$filepath" ]; then
        test_success "$description"
        PASSED_COUNT=$((PASSED_COUNT + 1))
        return 0
    else
        test_fail "$description - 文件存在但期望不存在"
        FAILED_COUNT=$((FAILED_COUNT + 1))
        return 1
    fi
}

# 断言目录存在
assert_dir_exists() {
    local dirpath="$1"
    local description="${2:-目录存在: $dirpath}"
    
    TEST_COUNT=$((TEST_COUNT + 1))
    
    if [ -d "$dirpath" ]; then
        test_success "$description"
        PASSED_COUNT=$((PASSED_COUNT + 1))
        return 0
    else
        test_fail "$description - 目录不存在"
        FAILED_COUNT=$((FAILED_COUNT + 1))
        return 1
    fi
}

# 断言字符串包含
assert_contains() {
    local haystack="$1"
    local needle="$2"
    local description="${3:-字符串包含: '$needle'}"
    
    TEST_COUNT=$((TEST_COUNT + 1))
    
    if [[ "$haystack" == *"$needle"* ]]; then
        test_success "$description"
        PASSED_COUNT=$((PASSED_COUNT + 1))
        return 0
    else
        test_fail "$description - '$haystack' 不包含 '$needle'"
        FAILED_COUNT=$((FAILED_COUNT + 1))
        return 1
    fi
}

# 断言进程正在运行
assert_process_running() {
    local process_name="$1"
    local description="${2:-进程正在运行: $process_name}"
    
    TEST_COUNT=$((TEST_COUNT + 1))
    
    if pgrep -f "$process_name" >/dev/null; then
        test_success "$description"
        PASSED_COUNT=$((PASSED_COUNT + 1))
        return 0
    else
        test_fail "$description - 进程未运行"
        FAILED_COUNT=$((FAILED_COUNT + 1))
        return 1
    fi
}

# 工具函数

# 运行命令并捕获输出
run_and_capture() {
    local command="$1"
    eval "$command" 2>&1
}

# Set up test environment
setup_test_env() {
    test_info "Setting up test environment..."
    
    # Create temporary test directory
    TEST_TMP_DIR=$(mktemp -d -t env-script-test-XXXXXX)
    export TEST_TMP_DIR
    
    # Set trap to clean up temporary directory
    trap cleanup_test_env EXIT
    
    test_info "Test temporary directory: $TEST_TMP_DIR"
}

# Clean up test environment
cleanup_test_env() {
    if [ -n "${TEST_TMP_DIR:-}" ] && [ -d "$TEST_TMP_DIR" ]; then
        test_info "Cleaning up test environment: $TEST_TMP_DIR"
        rm -rf "$TEST_TMP_DIR"
    fi
}

# Show test result summary
show_test_summary() {
    echo ""
    echo "=================================="
    test_info "Test summary:"
    echo "Total tests: $TEST_COUNT"
    echo "Passed: $PASSED_COUNT"
    echo "Failed: $FAILED_COUNT"
    
    if [ $FAILED_COUNT -eq 0 ]; then
        test_info "All tests completed (some were skipped)."
        return 0
    else
        test_fail "$FAILED_COUNT tests failed"
        return 1
    fi
}

# Mock user input
mock_user_input() {
    local input="$1"
    echo "$input"
}

# 检查软件是否已安装
is_installed() {
    local software="$1"
    command -v "$software" >/dev/null 2>&1
}

# Check if the current OS is supported for installation
# Returns 0 if supported, 1 if not supported
# Usage: is_os_supported script_path
is_os_supported() {
    local script_path="$1"
    
    if [ -z "$script_path" ] || [ ! -f "$script_path" ]; then
        # If no script path provided or script doesn't exist, assume not supported
        return 1
    fi
    
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
