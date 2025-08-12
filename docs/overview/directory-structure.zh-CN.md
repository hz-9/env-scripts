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
│   │   └── tests-install.instructions.md
│   └── prompts/                      # 提示和指导文档
│       └── translate-docs.md         # 文档翻译指南
├── LICENSE                           # 开源许可证文件
├── Makefile                          # Make 构建配置
├── package.json                      # Node.js 项目配置
├── README.md                         # 项目说明（英文）
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
├── logs/                             # 日志目录
│   ├── all.log                       # 综合日志文件
│   └── test-single-all.nginx.log     # nginx 测试日志
├── scripts/                          # 源码脚本目录
│   ├── __base.sh                     # 基础工具函数库
│   ├── install-curl.sh               # curl 安装脚本
│   ├── install-docker.sh             # Docker 安装脚本
│   ├── install-git.sh                # Git 安装脚本
│   ├── install-htop.sh               # htop 安装脚本
│   ├── install-jq.sh                 # jq 安装脚本
│   ├── install-nginx.sh              # nginx 安装脚本
│   ├── install-node.sh               # Node.js 安装脚本
│   ├── install-p7zip.sh              # p7zip 安装脚本
│   ├── install-tmux.sh               # tmux 安装脚本
│   ├── install-tree.sh               # tree 安装脚本
│   ├── install-wget.sh               # wget 安装脚本
│   └── install-zip.sh                # zip/unzip 安装脚本
├── temp/                             # 临时文件目录
├── test-results/                     # 测试结果目录
├── tests/                            # 测试脚本目录
│   ├── test-utils.sh                 # 测试工具函数库
│   ├── install-curl/                 # curl 安装测试
│   │   ├── 01-ok.sh                  # 基础功能测试
│   │   └── 02-install.sh             # 安装集成测试
│   ├── install-docker/               # Docker 安装测试
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
│   └── install-zip/                  # zip/unzip 安装测试
│       ├── 01-ok.sh                  # 基础功能测试
│       └── 02-install.sh             # 安装集成测试
└── tools/                            # 工具脚本目录
    ├── build.sh                      # 脚本构建工具
    ├── demo.sh                       # 演示脚本
    └── test-runner.sh                # 测试运行器
```
