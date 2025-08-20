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
│   │   ├── tests-install.instructions.md
│   │   └── tests-syncdb.instructions.md
│   └── prompts/                      # Prompt and guidance documents
│       ├── sync-docs.prompt.md       # Document synchronization guide
│       └── translate-docs.md         # Document translation guide
├── LICENSE                           # Open source license file
├── Makefile                          # Make build configuration
├── package.json                      # Node.js project configuration
├── README.md                         # Project documentation (English)
├── dist/                             # Build output directory
│   ├── install-7zip.sh               # Built 7zip installation script
│   ├── install-curl.sh               # Built curl installation script
│   ├── install-docker.sh             # Built Docker installation script
│   ├── install-gdal.sh               # Built GDAL installation script
│   ├── install-git.sh                # Built Git installation script
│   ├── install-htop.sh               # Built htop installation script
│   ├── install-jq.sh                 # Built jq installation script
│   ├── install-nginx.sh              # Built nginx installation script
│   ├── install-node.sh               # Built Node.js installation script
│   ├── install-p7zip.sh              # Built p7zip installation script
│   ├── install-tmux.sh               # Built tmux installation script
│   ├── install-tree.sh               # Built tree installation script
│   ├── install-wget.sh               # Built wget installation script
│   ├── install-xz.sh                 # Built xz installation script
│   ├── install-zip.sh                # Built zip installation script
│   ├── syncdb-mongodb.sh             # Built MongoDB data sync script
│   ├── syncdb-mysql.sh               # Built MySQL data sync script
│   └── syncdb-postgresql.sh          # Built PostgreSQL data sync script
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
│       ├── scripts.zh-CN.md          # Script list (Chinese)
│       ├── testing.md                # Testing guide (English)
│       └── testing.zh-CN.md          # Testing guide (Chinese)
├── echo/                             # Echo script directory
├── logs/                             # Log directory
│   ├── install-test-all-env.*.log    # Installation test logs (all environments)
│   ├── install-test-all.*.log        # Installation test logs (all)
│   ├── install-test-single.*.log     # Installation test logs (single)
│   ├── syncdb-test-all-env.*.log     # Database sync test logs (all environments)
│   ├── syncdb-test-all.*.log         # Database sync test logs (all)
│   ├── syncdb-test-file.*.log        # Database sync test logs (file)
│   └── syncdb-test-single.*.log      # Database sync test logs (single)
├── scripts/                          # Script source directory
│   ├── __base.sh                     # Base script with common functions
│   ├── install-7zip.sh               # 7zip installation script
│   ├── install-curl.sh               # curl installation script
│   ├── install-docker.sh             # Docker installation script
│   ├── install-gdal.sh               # GDAL installation script
│   ├── install-git.sh                # Git installation script
│   ├── install-htop.sh               # htop installation script
│   ├── install-jq.sh                 # jq installation script
│   ├── install-nginx.sh              # nginx installation script
│   ├── install-node.sh               # Node.js installation script
│   ├── install-p7zip.sh              # p7zip installation script
│   ├── install-tmux.sh               # tmux installation script
│   ├── install-tree.sh               # tree installation script
│   ├── install-wget.sh               # wget installation script
│   ├── install-xz.sh                 # xz installation script
│   ├── install-zip.sh                # zip installation script
│   ├── syncdb-mongodb.sh             # MongoDB data sync script
│   ├── syncdb-mysql.sh               # MySQL data sync script
│   └── syncdb-postgresql.sh          # PostgreSQL data sync script
├── temp/                             # Temporary file directory
├── test-results/                     # Test results directory
└── tests/                            # Test directory
    ├── install-7zip/                 # 7zip installation test files
    ├── install-curl/                 # curl installation test files
    ├── install-docker/               # Docker installation test files
    ├── install-gdal/                 # GDAL installation test files
    ├── install-git/                  # Git installation test files
    ├── install-htop/                 # htop installation test files
    ├── install-jq/                   # jq installation test files
    ├── install-nginx/                # nginx installation test files
    ├── install-node/                 # Node.js installation test files
    ├── install-p7zip/                # p7zip installation test files
    ├── install-tmux/                 # tmux installation test files
    ├── install-tree/                 # tree installation test files
    ├── install-wget/                 # wget installation test files
    ├── install-xz/                   # xz installation test files
    ├── install-zip/                  # zip installation test files
    ├── syncdb-mongodb/               # MongoDB data sync test files
    │   ├── 01-ok.sh                  # Basic functionality test
    │   └── 02-install.sh             # Installation test
    ├── syncdb-mysql/                 # MySQL data sync test files
    │   ├── 01-ok.sh                  # Basic functionality test
    │   └── 02-install.sh             # Installation test
    └── syncdb-postgresql/            # PostgreSQL data sync test files
        ├── 01-ok.sh                  # Basic functionality test
        └── 02-install.sh             # Installation test
```
