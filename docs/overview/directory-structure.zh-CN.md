# 目录结构

## 项目概述

env-script 是一个用于提供开箱即用的开发环境安装脚本集合的项目，包含 bash 脚本和相关的 Docker 测试环境。该项目旨在为不同的 Linux 发行版提供标准化的脚本安装流程，并在多个环境中进行测试验证。

## 当前目录结构

```txt
env-script/
├── .github/                          # GitHub 配置目录
│   ├── instructions/                 # 项目说明文档
│   │   ├── docker-compose.instructions.md
│   │   ├── docker-file.instructions.md
│   │   ├── markdown-format.instructions.md
│   │   ├── project-summary.md
│   │   ├── scripts-base.instructions.md
│   │   ├── scripts-install.instructions.md
│   │   ├── shell-format.instructions.md
│   │   ├── tests-install.instructions.md
│   │   └── tests-syncdb.instructions.md
│   └── prompts/                      # 提示和指导文档
│       ├── sync-docs.prompt.md       # 文档同步指南
│       └── translate-docs.md         # 文档翻译指南
├── LICENSE                           # 开源许可证文件
├── Makefile                          # Make 构建配置
├── package.json                      # Node.js 项目配置
├── README.md                         # 项目说明（英文）
├── dist/                             # 构建输出目录
│   ├── install-7zip.sh               # 构建后的7zip安装脚本
│   ├── install-curl.sh               # 构建后的curl安装脚本
│   ├── install-docker.sh             # 构建后的Docker安装脚本
│   ├── install-gdal.sh               # 构建后的GDAL安装脚本
│   ├── install-git.sh                # 构建后的Git安装脚本
│   ├── install-htop.sh               # 构建后的htop安装脚本
│   ├── install-jq.sh                 # 构建后的jq安装脚本
│   ├── install-nginx.sh              # 构建后的nginx安装脚本
│   ├── install-node.sh               # 构建后的Node.js安装脚本
│   ├── install-p7zip.sh              # 构建后的p7zip安装脚本
│   ├── install-tmux.sh               # 构建后的tmux安装脚本
│   ├── install-tree.sh               # 构建后的tree安装脚本
│   ├── install-wget.sh               # 构建后的wget安装脚本
│   ├── install-xz.sh                 # 构建后的xz安装脚本
│   ├── install-zip.sh                # 构建后的zip安装脚本
│   ├── syncdb-mongodb.sh             # 构建后的MongoDB数据同步脚本
│   ├── syncdb-mysql.sh               # 构建后的MySQL数据同步脚本
│   └── syncdb-postgresql.sh          # 构建后的PostgreSQL数据同步脚本
├── docker/                           # Docker 测试环境配置
│   ├── docker-compose.yml            # Docker Compose 编排文件
│   ├── Dockerfile.debian11-9         # Debian 11.9 测试镜像
│   ├── Dockerfile.debian12-2         # Debian 12.2 测试镜像
│   ├── Dockerfile.fedora41           # Fedora 41 测试镜像
│   ├── Dockerfile.redhat8-10         # Red Hat 8.10 测试镜像
│   ├── Dockerfile.redhat9-6          # Red Hat 9.6 测试镜像
│   ├── Dockerfile.ubuntu20-04        # Ubuntu 20.04 测试镜像
│   ├── Dockerfile.ubuntu22-04        # Ubuntu 22.04 测试镜像
│   └── Dockerfile.ubuntu24-04        # Ubuntu 24.04 测试镜像
├── docs/                             # 文档目录
│   ├── README.md                     # 项目文档（英文）
│   ├── README.zh-CN.md               # 项目文档（中文）
│   └── overview/                     # 详细文档
│       ├── directory-structure.md    # 目录结构说明（英文）
│       ├── directory-structure.zh-CN.md # 目录结构说明（中文）
│       ├── scripts.md                # 脚本清单（英文）
│       ├── scripts.zh-CN.md          # 脚本清单（中文）
│       ├── testing.md                # 测试指南（英文）
│       └── testing.zh-CN.md          # 测试指南（中文）
├── echo/                             # 回显脚本目录
├── logs/                             # 日志目录
│   ├── install-test-all-env.*.log    # 安装测试日志（全环境）
│   ├── install-test-all.*.log        # 安装测试日志（全部）
│   ├── install-test-single.*.log     # 安装测试日志（单个）
│   ├── syncdb-test-all-env.*.log     # 数据库同步测试日志（全环境）
│   ├── syncdb-test-all.*.log         # 数据库同步测试日志（全部）
│   ├── syncdb-test-file.*.log        # 数据库同步测试日志（文件）
│   └── syncdb-test-single.*.log      # 数据库同步测试日志（单个）
├── scripts/                          # 源码脚本目录
│   ├── __base.sh                     # 基础工具函数库
│   ├── install-7zip.sh               # 7zip 安装脚本
│   ├── install-curl.sh               # curl 安装脚本
│   ├── install-docker.sh             # Docker 安装脚本
│   ├── install-gdal.sh               # GDAL 安装脚本
│   ├── install-git.sh                # Git 安装脚本
│   ├── install-htop.sh               # htop 安装脚本
│   ├── install-jq.sh                 # jq 安装脚本
│   ├── install-nginx.sh              # nginx 安装脚本
│   ├── install-node.sh               # Node.js 安装脚本
│   ├── install-p7zip.sh              # p7zip 安装脚本
│   ├── install-tmux.sh               # tmux 安装脚本
│   ├── install-tree.sh               # tree 安装脚本
│   ├── install-wget.sh               # wget 安装脚本
│   ├── install-xz.sh                 # xz 安装脚本
│   ├── install-zip.sh                # zip/unzip 安装脚本
│   ├── syncdb-mongodb.sh             # MongoDB 数据同步脚本
│   ├── syncdb-mysql.sh               # MySQL 数据同步脚本
│   └── syncdb-postgresql.sh          # PostgreSQL 数据同步脚本
├── temp/                             # 临时文件目录
├── test-results/                     # 测试结果目录
├── tests/                            # 测试脚本目录
│   ├── __base.sh                     # 测试工具函数库
│   ├── install-7zip/                 # 7zip 安装测试
│   │   ├── 01-ok.sh                  # 基础功能测试
│   │   └── 02-install.sh             # 安装集成测试
│   ├── install-curl/                 # curl 安装测试
│   │   ├── 01-ok.sh                  # 基础功能测试
│   │   └── 02-install.sh             # 安装集成测试
│   ├── install-docker/               # Docker 安装测试
│   │   ├── 01-ok.sh                  # 基础功能测试
│   │   └── 02-install.sh             # 安装集成测试
│   ├── install-gdal/                 # GDAL 安装测试
│   │   ├── 01-ok.sh                  # 基础功能测试
│   │   └── 02-install.sh             # 安装集成测试
│   ├── install-git/                  # Git 安装测试
│   │   ├── 01-ok.sh                  # 基础功能测试
│   │   └── 02-install.sh             # 安装集成测试
│   ├── install-htop/                 # htop 安装测试
│   │   ├── 01-ok.sh                  # 基础功能测试
│   │   └── 02-install.sh             # 安装集成测试
│   ├── install-jq/                   # jq 安装测试
│   │   ├── 01-ok.sh                  # 基础功能测试
│   │   └── 02-install.sh             # 安装集成测试
│   ├── install-nginx/                # nginx 安装测试
│   │   ├── 01-ok.sh                  # 基础功能测试
│   │   └── 02-install.sh             # 安装集成测试
│   ├── install-node/                 # Node.js 安装测试
│   │   ├── 01-ok.sh                  # 基础功能测试
│   │   └── 02-install.sh             # 安装集成测试
│   ├── install-p7zip/                # p7zip 安装测试
│   │   ├── 01-ok.sh                  # 基础功能测试
│   │   └── 02-install.sh             # 安装集成测试
│   ├── install-tmux/                 # tmux 安装测试
│   │   ├── 01-ok.sh                  # 基础功能测试
│   │   └── 02-install.sh             # 安装集成测试
│   ├── install-tree/                 # tree 安装测试
│   │   ├── 01-ok.sh                  # 基础功能测试
│   │   └── 02-install.sh             # 安装集成测试
│   ├── install-wget/                 # wget 安装测试
│   │   ├── 01-ok.sh                  # 基础功能测试
│   │   └── 02-install.sh             # 安装集成测试
│   ├── install-xz/                   # xz 安装测试
│   │   ├── 01-ok.sh                  # 基础功能测试
│   │   └── 02-install.sh             # 安装集成测试
│   ├── install-zip/                  # zip/unzip 安装测试
│   │   ├── 01-ok.sh                  # 基础功能测试
│   │   └── 02-install.sh             # 安装集成测试
│   ├── syncdb-mongodb/               # MongoDB 数据同步测试
│   │   ├── 01-ok.sh                  # 基础功能测试
│   │   └── 02-install.sh             # 安装集成测试
│   ├── syncdb-mysql/                 # MySQL 数据同步测试
│   │   ├── 01-ok.sh                  # 基础功能测试
│   │   └── 02-install.sh             # 安装集成测试
│   └── syncdb-postgresql/            # PostgreSQL 数据同步测试
│       ├── 01-ok.sh                  # 基础功能测试
│       └── 02-install.sh             # 安装集成测试
└── tools/                            # 工具脚本目录
    ├── __base.sh                     # 工具基础函数库
    ├── build.sh                      # 脚本构建工具
    ├── demo.sh                       # 演示脚本
    ├── test-environment-manager.sh   # 测试环境管理器
    └── test-runner.sh                # 测试运行器
