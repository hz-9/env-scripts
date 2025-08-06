#!/bin/bash

# Quick test and demo script

set -e

# Color output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Environment Script Test Demo ===${NC}"
echo ""

# 1. Build scripts
echo -e "${BLUE}Step 1: Build scripts${NC}"
if [ -f "build.sh" ]; then
    bash build.sh
    echo -e "${GREEN}✓ Script build completed${NC}"
else
    echo -e "${YELLOW}⚠ build.sh does not exist, skipping build${NC}"
fi
echo ""

# 2. Check test environment
echo -e "${BLUE}Step 2: Check test environment${NC}"

if command -v docker >/dev/null 2>&1; then
    echo -e "${GREEN}✓ Docker is installed${NC}"
    
    if command -v docker-compose >/dev/null 2>&1; then
        echo -e "${GREEN}✓ Docker Compose is installed${NC}"
    else
        echo -e "${YELLOW}⚠ Docker Compose is not installed, recommend installing for full functionality${NC}"
    fi
else
    echo -e "${YELLOW}⚠ Docker is not installed, tests will run in local environment${NC}"
fi

if command -v make >/dev/null 2>&1; then
    echo -e "${GREEN}✓ Make is installed${NC}"
else
    echo -e "${YELLOW}⚠ Make is not installed, commands need to be run manually${NC}"
fi
echo ""

# 3. Run basic tests
echo -e "${BLUE}Step 3: Run basic tests${NC}"

if [ -f "test-runner.sh" ]; then
    chmod +x test-runner.sh
    
    # Run a simple test
    if [ -f "tests/install-git/01-ok.sh" ]; then
        echo "Running Git install script test..."
        ./test-runner.sh --test tests/install-git/01-ok.sh
    else
        echo "Creating and running tests..."
        ./test-runner.sh --all
    fi
else
    echo -e "${YELLOW}⚠ test-runner.sh does not exist${NC}"
fi
echo ""

# 4. Show available commands
echo -e "${BLUE}Step 4: Available commands${NC}"
echo ""
echo "Run tests manually:"
echo "  ./test-runner.sh --all                    # Run all tests"
echo "  ./test-runner.sh --test tests/*/01-ok.sh  # Run specific test"
echo ""

if command -v make >/dev/null 2>&1; then
    echo "Using Make:"
    echo "  make test                    # Run tests in Docker"
    echo "  make test-all               # Run tests in all environments"
    echo "  make interactive            # Start interactive environment"
    echo "  make help                   # Show all available commands"
    echo ""
fi

if command -v docker >/dev/null 2>&1; then
    echo "Using Docker directly:"
    echo "  docker build -t env-script-test ."
    echo "  docker run --rm -v \$(pwd):/app env-script-test"
    echo ""
    
    if command -v docker-compose >/dev/null 2>&1; then
        echo "Using Docker Compose:"
        echo "  docker-compose run --rm ubuntu-test"
        echo "  docker-compose run --rm interactive"
        echo ""
    fi
fi

echo -e "${GREEN}=== Demo completed ===${NC}"
echo ""
echo "See TESTING.md for detailed testing guide"
