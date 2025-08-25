# Environment Scripts

A collection of ready-to-use development environment installation scripts for different systems.

## 🎯 Project Purpose

This repository provides **production-ready installation scripts** located in the `dist/` directory. Developers can directly download and execute these scripts to install various development tools and environments.

## 📁 Project Structure

| Directory   | Description                                    |
| ----------- | ---------------------------------------------- |
| `dist/`     | **Final production scripts** - Ready to use   |
| `scripts/`  | Development source scripts                     |
| `tools/`    | Build and testing tools                        |
| `tests/`    | Comprehensive test suites                      |
| `docker/`   | Docker environments for testing                |
| `docs/`     | Documentation                                  |

## 🚀 Quick Start

### Direct Usage (Recommended)

Download and run scripts directly from the `dist/` directory:

```bash
# Install Git
curl -o-   https://raw.githubusercontent.com/hz-9/env-scripts/master/dist/install-git.sh | bash

wget -qO-  https://raw.githubusercontent.com/hz-9/env-scripts/master/dist/install-git.sh | bash
```

Click here to view all supported [scripts](./overview/scripts.md).

### Local Usage

```bash
# Clone repository
git clone https://github.com/hz-9/env-scripts.git
cd env-scripts

# Use scripts directly
./dist/install-git.sh --help
./dist/install-git.sh --network=in-china
```

## Supported Systems

- Ubuntu 20.04/22.04/24.04 AMD64
- Debian 11.9/12.2 AMD64
- Fedora 41 AMD64
- Red Hat Enterprise Linux 8.10/9.6 AMD64

> Usually also supports all sub-versions with the same version numbers, such as Debian 11.8/12.1, etc.

## 🛠️ Development

### Building Scripts

Scripts in `dist/` are automatically generated from `scripts/` source files:

```bash
# Build all scripts
make build-scripts

# Or use build tool directly
./tools/build.sh
```

### Testing

Use Docker for comprehensive testing across multiple Linux distributions:

```bash
# Run all tests in all environments
make test-all

# Test with China network configuration
make test-all NETWORK=in-china

# Run specific test in specific environment
make test-single ENV=ubuntu22-04 TEST=tests/install-git/01-ok.sh

# Start interactive testing environment
make interactive
```

For more testing usage instructions, see [Testing Guide](./overview/testing.md).

**Available Testing Environments:**

- Ubuntu 20.04/22.04/24.04
- Debian 11.9/12.2
- Fedora 41
- Red Hat Enterprise Linux 8.10/9.6

### Adding New Scripts

1. Create source script in `scripts/` directory
2. Add corresponding tests in `tests/`
3. Build using `make build-scripts`
4. Test using `make test-all`

## 📖 Documentation

- [Testing Guide](overview/testing.md) - Comprehensive testing documentation
- [Directory Structure](overview/directory-structure.md) - Detailed project structure

## 🌏 Network Configuration

All scripts support the `--network=in-china` parameter for Chinese users:

- Use Huawei Cloud mirror sources
- Optimize download speeds
- Ensure reliability for Chinese users

## 🤝 Contributing

1. Fork this repository
2. Create feature branch
3. Add tests for new features
4. Ensure all tests pass: `make test-all`
5. Submit Pull Request

## 📄 License

This project is licensed under the MIT License.
