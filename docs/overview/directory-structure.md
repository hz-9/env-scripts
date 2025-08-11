# Directory Structure

## Project Overview

env-script is a project for providing out-of-the-box development environment installation script collections, including bash scripts and related Docker testing environments. This project aims to provide standardized script installation processes for different Linux distributions and validate them through testing across multiple environments.

## Current Directory Structure

```txt
env-script/
├── .github/                          # GitHub configuration directory
│   ├── instructions/                 # Project instruction documents
│   │   ├── docker-compose.instructions.md
│   │   ├── docker-file.instructions.md
│   │   ├── markdown-format.instructions.md
│   │   ├── project-summary.md
│   │   ├── scripts-base.instructions.md
│   │   ├── scripts-install.instructions.md
│   │   ├── shell-format.instructions.md
│   │   └── tests-install.instructions.md
│   └── prompts/                      # Prompt and guidance documents
│       └── translate-docs.md         # Document translation guide
├── LICENSE                           # Open source license file
├── Makefile                          # Make build configuration
├── package.json                      # Node.js project configuration
├── README.md                         # Project documentation (English)
├── docker/                           # Docker testing environment configuration
│   ├── docker-compose.yml            # Docker Compose orchestration file
│   ├── Dockerfile.debian11-9         # Debian 11.9 testing image
│   ├── Dockerfile.debian12-2         # Debian 12.2 testing image
│   ├── Dockerfile.fedora41           # Fedora 41 testing image
│   ├── Dockerfile.redhat8-10         # Red Hat 8.10 testing image
│   ├── Dockerfile.redhat9-6          # Red Hat 9.6 testing image
│   ├── Dockerfile.ubuntu20-04        # Ubuntu 20.04 testing image
│   ├── Dockerfile.ubuntu22-04        # Ubuntu 22.04 testing image
│   └── Dockerfile.ubuntu24-04        # Ubuntu 24.04 testing image
├── docs/                             # Documentation directory
│   ├── README.md                     # Project documentation (English)
│   ├── README.zh-CN.md               # Project documentation (Chinese)
│   └── overview/                     # Detailed documentation
│       ├── directory-structure.md    # Directory structure description (English)
│       ├── directory-structure.zh-CN.md # Directory structure description (Chinese)
│       ├── scripts.md                # Script list (English)
│       └── testing.md                # Testing guide (English)
├── logs/                             # Log directory
│   ├── all.log                       # Comprehensive log file
│   └── test-single-all.nginx.log     # nginx test log
├── scripts/                          # Source script directory
│   ├── __base.sh                     # Base utility function library
│   ├── install-curl.sh               # curl installation script
│   ├── install-docker.sh             # Docker installation script
│   ├── install-git.sh                # Git installation script
│   ├── install-htop.sh               # htop installation script
│   ├── install-jq.sh                 # jq installation script
│   ├── install-nginx.sh              # nginx installation script
│   ├── install-node.sh               # Node.js installation script
│   ├── install-p7zip.sh              # p7zip installation script
│   ├── install-tmux.sh               # tmux installation script
│   ├── install-tree.sh               # tree installation script
│   ├── install-wget.sh               # wget installation script
│   └── install-zip.sh                # zip/unzip installation script
├── temp/                             # Temporary files directory
├── test-results/                     # Test results directory
├── tests/                            # Test script directory
│   ├── test-utils.sh                 # Test utility function library
│   ├── install-curl/                 # curl installation tests
│   │   ├── 01-ok.sh                  # Basic functionality test
│   │   └── 02-install.sh             # Installation integration test
│   ├── install-docker/               # Docker installation tests
│   │   ├── 01-ok.sh                  # Basic functionality test
│   │   └── 02-install.sh             # Installation integration test
│   ├── install-git/                  # Git installation tests
│   │   ├── 01-ok.sh                  # Basic functionality test
│   │   └── 02-install.sh             # Installation integration test
│   ├── install-htop/                 # htop installation tests
│   │   ├── 01-ok.sh                  # Basic functionality test
│   │   └── 02-install.sh             # Installation integration test
│   ├── install-jq/                   # jq installation tests
│   │   ├── 01-ok.sh                  # Basic functionality test
│   │   └── 02-install.sh             # Installation integration test
│   ├── install-nginx/                # nginx installation tests
│   │   ├── 01-ok.sh                  # Basic functionality test
│   │   └── 02-install.sh             # Installation integration test
│   ├── install-node/                 # Node.js installation tests
│   │   ├── 01-ok.sh                  # Basic functionality test
│   │   └── 02-install.sh             # Installation integration test
│   ├── install-p7zip/                # p7zip installation tests
│   │   ├── 01-ok.sh                  # Basic functionality test
│   │   └── 02-install.sh             # Installation integration test
│   ├── install-tmux/                 # tmux installation tests
│   │   ├── 01-ok.sh                  # Basic functionality test
│   │   └── 02-install.sh             # Installation integration test
│   ├── install-tree/                 # tree installation tests
│   │   ├── 01-ok.sh                  # Basic functionality test
│   │   └── 02-install.sh             # Installation integration test
│   ├── install-wget/                 # wget installation tests
│   │   ├── 01-ok.sh                  # Basic functionality test
│   │   └── 02-install.sh             # Installation integration test
│   └── install-zip/                  # zip/unzip installation tests
│       ├── 01-ok.sh                  # Basic functionality test
│       └── 02-install.sh             # Installation integration test
└── tools/                            # Tool script directory
    ├── build.sh                      # Script build tool
    ├── demo.sh                       # Demo script
    └── test-runner.sh                # Test runner
```
