#!/bin/bash

# Test runner - for running all tests in Docker containers
set -e

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Log functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Test result statistics
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0

# Run a single test script
run_test() {
    local test_script="$1"
    local network_option="${2:-}"
    local test_name
    test_name=$(basename "$test_script" .sh)
    
    log_info "Running test: $test_name"
    
    TOTAL_TESTS=$((TOTAL_TESTS + 1))
    
    # Export network configuration environment variable for test scripts
    if [ "$network_option" = "in-china" ]; then
        export TEST_NETWORK="in-china"
        log_info "Using China network configuration"
    else
        export TEST_NETWORK="default"
    fi
    
    if bash "$test_script"; then
        log_success "Test passed: $test_name"
        PASSED_TESTS=$((PASSED_TESTS + 1))
        return 0
    else
        log_error "Test failed: $test_name"
        FAILED_TESTS=$((FAILED_TESTS + 1))
        return 1
    fi
}

# Run all tests
run_all_tests() {
    log_info "Starting to run all tests..."
    echo "=================================="
    
    # Find all test files
    find tests -name "*.sh" -type f | sort | while read -r test_file; do
        run_test "$test_file"
        echo "----------------------------------"
    done
    
    # Show test summary
    echo "=================================="
    log_info "Test summary:"
    echo "Total tests: $TOTAL_TESTS"
    echo "Passed: $PASSED_TESTS"
    echo "Failed: $FAILED_TESTS"
    
    if [ $FAILED_TESTS -eq 0 ]; then
        log_success "All tests passed!"
        exit 0
    else
        log_error "$FAILED_TESTS tests failed"
        exit 1
    fi
}

# Show help information
show_help() {
    echo "Usage: $0 [options] [test file]"
    echo ""
    echo "Options:"
    echo "  -h, --help        Show this help information"
    echo "  -a, --all         Run all tests (default)"
    echo "  -t, --test FILE   Run specified test file"
    echo "  -n, --network NET Specify network configuration (default|in-china)"
    echo "  -v, --verbose     Verbose output mode"
    echo ""
    echo "Examples:"
    echo "  $0                                          # Run all tests"
    echo "  $0 -t tests/install-git/01-ok.sh           # Run specific test"
    echo "  $0 -t tests/install-git/02-install.sh -n in-china  # Run test with China network configuration"
}

# Main function
main() {
    local test_file=""
    local network_option="default"
    
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_help
                exit 0
                ;;
            -t|--test)
                if [ -z "${2:-}" ]; then
                    log_error "Please specify test file"
                    exit 1
                fi
                test_file="$2"
                shift 2
                ;;
            -n|--network)
                if [ -z "${2:-}" ]; then
                    log_error "Please specify network configuration"
                    exit 1
                fi
                network_option="$2"
                shift 2
                ;;
            -a|--all)
                test_file=""
                shift
                ;;
            -v|--verbose)
                # Reserved for verbose output option
                shift
                ;;
            *)
                log_error "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
    done
    
    # Execute tests
    if [ -n "$test_file" ]; then
        run_test "$test_file" "$network_option"
    else
        run_all_tests
    fi
}

# Ensure we're in the project root directory
cd "$(dirname "$0")/.."

main "$@"
