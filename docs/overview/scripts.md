# Scripts List

This document lists all available installation scripts in the project. Each script provides cross-platform installation support for specific tools and software.

## Available Scripts

### Base Utilities

#### **install-curl.sh** - curl Installation

curl is a command-line tool for transferring data with URLs.

**Command line usage:**

```bash
# Using curl
curl -o- https://raw.githubusercontent.com/hz-9/env-scripts/master/dist/install-curl.sh | bash

# Using wget
wget -qO- https://raw.githubusercontent.com/hz-9/env-scripts/master/dist/install-curl.sh | bash

# With options
curl -o- https://raw.githubusercontent.com/hz-9/env-scripts/master/dist/install-curl.sh | bash -s -- --network=in-china
```

#### **install-wget.sh** - wget Installation

wget is a command-line utility for downloading files from the web.

**Command line usage:**

```bash
# Using curl
curl -o- https://raw.githubusercontent.com/hz-9/env-scripts/master/dist/install-wget.sh | bash

# Using wget
wget -qO- https://raw.githubusercontent.com/hz-9/env-scripts/master/dist/install-wget.sh | bash

# With options
curl -o- https://raw.githubusercontent.com/hz-9/env-scripts/master/dist/install-wget.sh | bash -s -- --network=in-china
```

#### **install-git.sh** - Git Installation

Git is a distributed version control system for tracking changes in source code.

**Command line usage:**

```bash
# Using curl
curl -o- https://raw.githubusercontent.com/hz-9/env-scripts/master/dist/install-git.sh | bash

# Using wget
wget -qO- https://raw.githubusercontent.com/hz-9/env-scripts/master/dist/install-git.sh | bash

# With options
curl -o- https://raw.githubusercontent.com/hz-9/env-scripts/master/dist/install-git.sh | bash -s -- --network=in-china
```

### Development Tools

#### **install-node.sh** - Node.js Installation

Node.js is a JavaScript runtime built on Chrome's V8 JavaScript engine.

**Command line usage:**

```bash
# Using curl
curl -o- https://raw.githubusercontent.com/hz-9/env-scripts/master/dist/install-node.sh | bash

# Using wget
wget -qO- https://raw.githubusercontent.com/hz-9/env-scripts/master/dist/install-node.sh | bash

# With options
curl -o- https://raw.githubusercontent.com/hz-9/env-scripts/master/dist/install-node.sh | bash -s -- --network=in-china
```

#### **install-docker.sh** - Docker Installation

Docker is a platform for developing, shipping, and running applications in containers.

**Command line usage:**

```bash
# Using curl
curl -o- https://raw.githubusercontent.com/hz-9/env-scripts/master/dist/install-docker.sh | bash

# Using wget
wget -qO- https://raw.githubusercontent.com/hz-9/env-scripts/master/dist/install-docker.sh | bash

# With options
curl -o- https://raw.githubusercontent.com/hz-9/env-scripts/master/dist/install-docker.sh | bash -s -- --network=in-china
```

### System Utilities

#### **install-htop.sh** - htop Installation

htop is an interactive process viewer for Unix systems.

**Command line usage:**

```bash
# Using curl
curl -o- https://raw.githubusercontent.com/hz-9/env-scripts/master/dist/install-htop.sh | bash

# Using wget
wget -qO- https://raw.githubusercontent.com/hz-9/env-scripts/master/dist/install-htop.sh | bash

# With options
curl -o- https://raw.githubusercontent.com/hz-9/env-scripts/master/dist/install-htop.sh | bash -s -- --network=in-china
```

#### **install-tmux.sh** - tmux Installation

tmux is a terminal multiplexer that allows multiple terminal sessions to be accessed simultaneously.

**Command line usage:**

```bash
# Using curl
curl -o- https://raw.githubusercontent.com/hz-9/env-scripts/master/dist/install-tmux.sh | bash

# Using wget
wget -qO- https://raw.githubusercontent.com/hz-9/env-scripts/master/dist/install-tmux.sh | bash

# With options
curl -o- https://raw.githubusercontent.com/hz-9/env-scripts/master/dist/install-tmux.sh | bash -s -- --network=in-china
```

#### **install-tree.sh** - tree Installation

tree is a command-line utility that displays directory structures in a tree-like format.

**Command line usage:**

```bash
# Using curl
curl -o- https://raw.githubusercontent.com/hz-9/env-scripts/master/dist/install-tree.sh | bash

# Using wget
wget -qO- https://raw.githubusercontent.com/hz-9/env-scripts/master/dist/install-tree.sh | bash

# With options
curl -o- https://raw.githubusercontent.com/hz-9/env-scripts/master/dist/install-tree.sh | bash -s -- --network=in-china
```

### File and Data Processing

#### **install-jq.sh** - jq Installation

jq is a lightweight and flexible command-line JSON processor.

**Command line usage:**

```bash
# Using curl
curl -o- https://raw.githubusercontent.com/hz-9/env-scripts/master/dist/install-jq.sh | bash

# Using wget
wget -qO- https://raw.githubusercontent.com/hz-9/env-scripts/master/dist/install-jq.sh | bash

# With options
curl -o- https://raw.githubusercontent.com/hz-9/env-scripts/master/dist/install-jq.sh | bash -s -- --network=in-china
```

#### **install-zip.sh** - zip/unzip Installation

zip and unzip are utilities for creating and extracting ZIP archives.

**Command line usage:**

```bash
# Using curl
curl -o- https://raw.githubusercontent.com/hz-9/env-scripts/master/dist/install-zip.sh | bash

# Using wget
wget -qO- https://raw.githubusercontent.com/hz-9/env-scripts/master/dist/install-zip.sh | bash

# With options
curl -o- https://raw.githubusercontent.com/hz-9/env-scripts/master/dist/install-zip.sh | bash -s -- --network=in-china
```

#### **install-p7zip.sh** - p7zip Installation

p7zip is a command-line version of 7-Zip for Unix-like systems.

**Command line usage:**

```bash
# Using curl
curl -o- https://raw.githubusercontent.com/hz-9/env-scripts/master/dist/install-p7zip.sh | bash

# Using wget
wget -qO- https://raw.githubusercontent.com/hz-9/env-scripts/master/dist/install-p7zip.sh | bash

# With options
curl -o- https://raw.githubusercontent.com/hz-9/env-scripts/master/dist/install-p7zip.sh | bash -s -- --network=in-china
```

### Web Services

#### **install-nginx.sh** - nginx Installation

nginx is a web server that can also be used as a reverse proxy, load balancer, and HTTP cache.

**Command line usage:**

```bash
# Using curl
curl -o- https://raw.githubusercontent.com/hz-9/env-scripts/master/dist/install-nginx.sh | bash

# Using wget
wget -qO- https://raw.githubusercontent.com/hz-9/env-scripts/master/dist/install-nginx.sh | bash

# With options
curl -o- https://raw.githubusercontent.com/hz-9/env-scripts/master/dist/install-nginx.sh | bash -s -- --network=in-china
```

## Common Parameters

All scripts support the following common parameters:

- `--network=in-china`: Use China-optimized mirror sources for faster downloads
- `--debug`: Enable debug mode for detailed output
- `--help`: Display help information
- `--version`: Show script version

## Supported Operating Systems

All scripts are tested and supported on:

- **Ubuntu**: 20.04, 22.04, 24.04 (AMD64)
- **Debian**: 11.9, 12.2 (AMD64)
- **Fedora**: 41 (AMD64)
- **Red Hat Enterprise Linux**: 8.10, 9.6 (AMD64)

> Generally supports all sub-versions with the same major version, such as Debian 11.8/12.1, etc.

## Usage Examples

### Quick Installation

```bash
# Install Git directly
curl -o- https://raw.githubusercontent.com/hz-9/env-scripts/master/dist/install-git.sh | bash

# Install Node.js with China network optimization
curl -o- https://raw.githubusercontent.com/hz-9/env-scripts/master/dist/install-node.sh | bash -s -- --network=in-china
```

### Local Usage

```bash
# Clone the repository
git clone https://github.com/hz-9/env-scripts.git
cd env-scripts

# Use scripts directly
./dist/install-git.sh --help
./dist/install-docker.sh --network=in-china
```

### Batch Installation

```bash
# Install multiple tools
for script in git node docker nginx; do
  curl -o- https://raw.githubusercontent.com/hz-9/env-scripts/master/dist/install-$script.sh | bash -s -- --network=in-china
done
```

## Development Information

- **Base Library**: All scripts depend on `__base.sh` for common functionality
- **Testing**: Each script has comprehensive tests in the `tests/` directory
- **Building**: Scripts are built from source in `scripts/` to production versions in `dist/`
- **Documentation**: See [Testing Guide](testing.md) for development and testing procedures
