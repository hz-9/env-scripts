# Testing Guide

## 🚀 Quick Test

```bash
# Build scripts
make build-scripts

# Run all installation script tests
make install-test-all

# Run all installation script tests in China network environment
make install-test-all NETWORK=in-china

# Run all database sync script tests
make syncdb-test-all

# Run all database sync script tests in China network environment
make syncdb-test-all NETWORK=in-china
```

## 🎯 Precise Test

### Installation Script Testing

#### Test Specific Script in All Environments

```bash
# Test specific installation script in all environments
make install-test-all-env SCRIPT=git
make install-test-all-env SCRIPT=docker
make install-test-all-env SCRIPT=node

# Test in China network environment
make install-test-all-env SCRIPT=git NETWORK=in-china
```

#### Test All Scripts in Specific Environment

```bash
# Run all installation script tests in specified environment
make install-test-all-script ENV=debian11-9
make install-test-all-script ENV=debian12-2
make install-test-all-script ENV=fedora41
make install-test-all-script ENV=redhat8-10
make install-test-all-script ENV=redhat9-6
make install-test-all-script ENV=ubuntu20-04
make install-test-all-script ENV=ubuntu22-04
make install-test-all-script ENV=ubuntu24-04

# Using China network
make install-test-all-script ENV=ubuntu22-04 NETWORK=in-china
```

#### Test Specific Script in Specific Environment

```bash
# Test specific installation script in specific environment
make install-test-single ENV=ubuntu22-04 SCRIPT=git
make install-test-single ENV=debian12-2 SCRIPT=docker NETWORK=in-china
```

#### Run Specific Test File

```bash
# Run specific test file in specific environment
make install-test-file ENV=debian11-9 FILE=tests/install-git/01-ok.sh
make install-test-file ENV=ubuntu22-04 FILE=tests/install-docker/02-install.sh NETWORK=in-china
```

### Database Sync Script Testing

#### Test Specific Sync Script in All Environments

```bash
# Test specific database sync script in all environments
make syncdb-test-all-env SCRIPT=postgresql
make syncdb-test-all-env SCRIPT=mysql
make syncdb-test-all-env SCRIPT=mongo

# Test in China network environment
make syncdb-test-all-env SCRIPT=postgresql NETWORK=in-china
```

#### Test All Sync Scripts in Specific Environment

```bash
# Run all database sync script tests in specified environment
make syncdb-test-all-script ENV=debian11-9
make syncdb-test-all-script ENV=ubuntu22-04

# Using China network
make syncdb-test-all-script ENV=ubuntu22-04 NETWORK=in-china
```

#### Test Specific Sync Script in Specific Environment

```bash
# Test specific database sync script in specific environment
make syncdb-test-single ENV=ubuntu22-04 SCRIPT=postgresql
make syncdb-test-single ENV=debian12-2 SCRIPT=mysql NETWORK=in-china
make syncdb-test-single ENV=ubuntu24-04 SCRIPT=mongo NETWORK=in-china
```

#### Run Specific Sync Test File

```bash
# Run specific sync test file in specific environment
make syncdb-test-file ENV=ubuntu22-04 FILE=tests/syncdb-mysql/02-install.sh NETWORK=in-china
```

## 🛠️ Other Commands

```bash
# Interactive test environment
make interactive

# Start shell in container
make shell

# Clean Docker images and containers
make clean

# View Docker logs
make logs

# Display test results
make results
```

## 🌐 Test Parameters

All test commands support the following parameters:

- `NETWORK=in-china` - Use China network configuration, suitable for users in mainland China
- `DEBUG=true` - Enable debug mode with detailed output

## 🖥️ Supported Test Environments

Tests are supported in the following environments:

- **Ubuntu**: 20.04, 22.04, 24.04 (AMD64)
- **Debian**: 11.9, 12.2 (AMD64)
- **Fedora**: 41 (AMD64)
- **Red Hat Enterprise Linux**: 8.10, 9.6 (AMD64)

## 🧪 Test Architecture

The test framework uses Docker containers to run tests in isolated environments, ensuring consistency and reproducibility of test results. The testing process includes:

1. Building scripts and Docker images
2. Running tests in specified environments
3. Collecting test results and logs
4. Generating test reports

Each script has two basic types of tests:

- **Basic verification test (01-ok.sh)** - Checks script syntax, help information, and OS compatibility
- **Installation test (02-install.sh)** - Tests actual installation functionality

## 📋 Developing New Tests

To add tests for a new script, follow these steps:

1. Create a subdirectory for the script under the `tests/` directory
2. Add at least two test files: `01-ok.sh` and `02-install.sh`
3. Use assertion functions from the test utilities library to verify script behavior
4. Run tests to ensure they work in all supported environments
