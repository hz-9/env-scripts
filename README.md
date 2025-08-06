# Environment Scripts

A collection of ready-to-use shell scripts for setting up development environments across different system.

## 🎯 Purpose

This repository provides **production-ready installation scripts** located in the `dist/` directory. Developers can directly download and execute these scripts to install various development tools and environments.

## 📁 Project Structure

| Directory   | Description                                           |
| ----------- | ----------------------------------------------------- |
| `dist/`     | **Final production scripts** - Ready for direct use  |
| `scripts/`  | Source scripts for development                        |
| `tools/`    | Build and testing utilities                           |
| `tests/`    | Comprehensive test suites                             |
| `docker/`   | Docker environments for testing                       |
| `docs/`     | Documentation                                         |

## 🚀 Quick Start

### Direct Usage (Recommended)

Download and run scripts directly from the `dist/` directory:

```bash
# Install Git
curl -fsSL https://raw.githubusercontent.com/hz-9/env-scripts/main/dist/install-git.sh | bash

# Or download first, then run
wget https://raw.githubusercontent.com/hz-9/env-scripts/main/dist/install-git.sh
chmod +x install-git.sh
./install-git.sh
```

### Local Usage

```bash
# Clone the repository
git clone https://github.com/hz-9/env-scripts.git
cd env-script

# Use scripts directly
./dist/install-git.sh --help
./dist/install-git.sh --network=in-china
```

## 📦 Available Scripts

### Git Installer (`dist/install-git.sh`)

Installs Git across multiple Linux distributions with China mirror support.

```bash
# Basic installation
./dist/install-git.sh

# Installation with China mirrors (faster in China)
./dist/install-git.sh --network=in-china

# Install specific version
./dist/install-git.sh --git-version=2.40.0

# View help
./dist/install-git.sh --help
```

**Supported Systems:**

- Ubuntu 20.04/22.04/24.04 AMD64
- Debian 11.9/12.2 AMD64
- Fedora 41 AMD64
- Red Hat Enterprise Linux 8.10/9.6 AMD64

## 🛠️ Development

### Building Scripts

Scripts in `dist/` are automatically generated from `scripts/` source files:

```bash
# Build all scripts
make build-scripts

# Or use the build tool directly
./tools/build.sh
```

### Testing

Comprehensive testing across multiple Linux distributions using Docker:

```bash
# Run all tests in all environments
make test-all

# Test with China network configuration
make test-all NETWORK=in-china

# Run specific test in specific environment
make test-single ENV=ubuntu22-test TEST=tests/install-git/01-ok.sh

# Start interactive testing environment
make interactive
```

**Available Test Environments:**

- Ubuntu 20.04/22.04/24.04
- Debian 11.9/12.2
- Fedora 41
- Red Hat Enterprise Linux 8.10/9.6

### Adding New Scripts

1. Create source script in `scripts/` directory
2. Add corresponding tests in `tests/`
3. Build with `make build-scripts`
4. Test with `make test-all`

## 📖 Documentation

- [Testing Guide](docs/testing.md) - Comprehensive testing documentation
- [Directory Structure](docs/directory-structure.md) - Detailed project structure

## 🌏 Network Configuration

All scripts support `--network=in-china` parameter for users in China, which:

- Uses Chinese mirror sources (USTC mirrors)
- Optimizes download speeds
- Ensures reliability for Chinese users

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch
3. Add tests for new functionality  
4. Ensure all tests pass: `make test-all`
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License.
