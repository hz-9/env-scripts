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
│   ├── prompts/                      # Prompt and guidance documents
│   │   ├── sync-docs.prompt.md       # Document synchronization guide
│   │   └── translate-docs.md         # Document translation guide
│   └── workflows/                    # GitHub Actions workflows
│       └── generate-pages.yml        # Page generation workflow
├── .gitignore                        # Git ignore file configuration
├── .markdownlint.json                # Markdown format check configuration
├── .nvmrc                            # Node.js version specification
├── .shellcheckrc                     # ShellCheck configuration
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
│   ├── syncdb-mongo.sh               # Built MongoDB data sync script
│   ├── syncdb-mysql.sh               # Built MySQL data sync script
│   └── syncdb-postgresql.sh          # Built PostgreSQL data sync script
├── docker/                           # Docker testing environment configuration
│   ├── .dockerignore                 # Docker ignore file configuration
│   ├── docker-compose.yml            # Docker Compose orchestration file
│   ├── Dockerfile.debian11-9         # Debian 11.9 testing image
│   ├── Dockerfile.debian11-9.docker  # Debian 11.9 Docker image build file
│   ├── Dockerfile.debian12-2         # Debian 12.2 testing image
│   ├── Dockerfile.debian12-2.docker  # Debian 12.2 Docker image build file
│   ├── Dockerfile.fedora41           # Fedora 41 testing image
│   ├── Dockerfile.fedora41.docker    # Fedora 41 Docker image build file
│   ├── Dockerfile.redhat8-10         # Red Hat 8.10 testing image
│   ├── Dockerfile.redhat8-10.docker  # Red Hat 8.10 Docker image build file
│   ├── Dockerfile.redhat8-10.mirrors/   # Red Hat 8.10 mirror configuration directory
│   │   └── epel.repo                 # EPEL mirror configuration
│   ├── Dockerfile.redhat9-6          # Red Hat 9.6 testing image
│   ├── Dockerfile.redhat9-6.docker   # Red Hat 9.6 Docker image build file
│   ├── Dockerfile.redhat9-6.mirrors/    # Red Hat 9.6 mirror configuration directory
│   │   └── epel.repo                 # EPEL mirror configuration
│   ├── Dockerfile.ubuntu20-04        # Ubuntu 20.04 testing image
│   ├── Dockerfile.ubuntu20-04.docker # Ubuntu 20.04 Docker image build file
│   ├── Dockerfile.ubuntu22-04        # Ubuntu 22.04 testing image
│   ├── Dockerfile.ubuntu22-04.docker # Ubuntu 22.04 Docker image build file
│   ├── Dockerfile.ubuntu24-04        # Ubuntu 24.04 testing image
│   └── Dockerfile.ubuntu24-04.docker # Ubuntu 24.04 Docker image build file
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
├── logs/                             # Log directory
│   ├── install-test-all-env.*.log    # Installation test logs (all environments)
│   ├── install-test-all.*.log        # Installation test logs (all)
│   ├── install-test-single.*.log     # Installation test logs (single)
│   ├── syncdb-test-all-env.*.log     # Database sync test logs (all environments)
│   ├── syncdb-test-all.*.log         # Database sync test logs (all)
│   ├── syncdb-test-file.*.log        # Database sync test logs (file)
│   └── syncdb-test-single.*.log      # Database sync test logs (single)
├── scripts/                          # Script source directory
│   ├── __base.sh                     # Base utility function library
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
│   ├── install-zip.sh                # zip/unzip installation script
│   ├── syncdb-mongo.sh               # MongoDB data sync script
│   ├── syncdb-mysql.sh               # MySQL data sync script
│   └── syncdb-postgresql.sh          # PostgreSQL data sync script
├── temp/                             # Temporary file directory
├── tests/                            # Test script directory
│   ├── __base.sh                     # Test utility function library
│   ├── install-7zip/                 # 7zip installation tests
│   │   ├── 01-ok.sh                  # Basic functionality test
│   │   └── 02-install.sh             # Installation integration test
│   ├── install-curl/                 # curl installation tests
│   │   ├── 01-ok.sh                  # Basic functionality test
│   │   └── 02-install.sh             # Installation integration test
│   ├── install-docker/               # Docker installation tests
│   │   ├── 01-ok.sh                  # Basic functionality test
│   │   └── 02-install.sh             # Installation integration test
│   ├── install-gdal/                 # GDAL installation tests
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
│   ├── install-xz/                   # xz installation tests
│   │   ├── 01-ok.sh                  # Basic functionality test
│   │   └── 02-install.sh             # Installation integration test
│   ├── install-zip/                  # zip/unzip installation tests
│   │   ├── 01-ok.sh                  # Basic functionality test
│   │   └── 02-install.sh             # Installation integration test
│   ├── syncdb-mongo/                 # MongoDB data sync tests
│   │   ├── 01-ok.sh                  # Basic functionality test
│   │   └── 02-install.sh             # Installation integration test
│   ├── syncdb-mysql/                 # MySQL data sync tests
│   │   ├── 01-ok.sh                  # Basic functionality test
│   │   └── 02-install.sh             # Installation integration test
│   └── syncdb-postgresql/            # PostgreSQL data sync tests
│       ├── 01-ok.sh                  # Basic functionality test
│       └── 02-install.sh             # Installation integration test
└── tools/                            # Tool script directory
    ├── __base.sh                     # Tool base function library
    ├── build.sh                      # Script build tool
    ├── demo.sh                       # Demo script
    ├── test-environment-manager.sh   # Test environment manager
    └── test-runner.sh                # Test runner
```