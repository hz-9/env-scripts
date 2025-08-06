# 目录结构

## 项目概述

env-script 是一个用于测试环境脚本安装的项目，包含 bash 脚本和相关的 Docker 测试环境。该项目旨在提供一套标准化的脚本安装流程，并在多个 Linux 发行版中进行测试验证。

## 当前目录结构

``` txt
env-script/
├── .github/                          # GitHub 配置
│   ├── instructions/                 # 项目说明文档
│   │   ├── directory-structure.instructions.md
│   │   ├── chat-context-record.md
│   │   └── project-summary.md
│   └── workflows/                    # CI/CD 流水线
│       └── test.yml                  # 自动化测试配置
├── docker/                           # Docker 测试环境
│   ├── Dockerfile                    # Ubuntu 22.04 测试环境
│   ├── Dockerfile.ubuntu20-04        # Ubuntu 20.04 测试环境
│   ├── Dockerfile.centos             # CentOS 8 测试环境
│   ├── docker-compose.yml            # Docker Compose 编排
│   └── .dockerignore                 # Docker 忽略文件
├── docs/                             # 文档目录
│   └── TESTING.md                    # 测试使用指南
├── tools/                            # 工具脚本
│   ├── build.sh                      # 项目构建脚本
│   ├── test-runner.sh                # 测试运行器
│   └── demo.sh                       # 演示脚本
├── scripts/                          # 源码脚本目录
│   ├── __base.sh                     # 基础工具函数库
│   └── install-git.sh                # Git 安装脚本
├── scripts-back/                     # 备份或历史脚本
│   ├── __console.sh                  # 控制台工具
│   ├── __const.sh                    # 常量定义
│   ├── __install.common.sh           # 通用安装函数
│   ├── __judge-system.sh             # 系统判断工具
│   ├── __parse-paramter.sh           # 参数解析工具
│   ├── __parse-user-paramter.sh      # 用户参数解析
│   └── run.test.sh                   # 测试运行脚本
├── dist/                             # 构建输出目录
│   └── install-git.sh                # 合并后的安装脚本
├── tests/                            # 测试目录
│   ├── test-utils.sh                 # 测试工具函数库
│   └── install-git/                  # Git 安装脚本测试
│       ├── 01-ok.sh                  # 基础单元测试
│       └── 02-integration.sh         # 集成测试
├── Makefile                          # Make 构建配置
├── README.md                         # 项目说明（英文）
└── README.zh-CN.md                   # 项目说明（中文）
```

## 目录详细说明

### 核心脚本目录

- **scripts/**: 存放源码安装脚本，每个脚本负责特定软件的安装
  - `__base.sh`: 提供通用的工具函数，供其他脚本使用
  - `install-git.sh`: Git 安装脚本示例
  
- **dist/**: 构建后的最终脚本，包含所有依赖，可独立运行
  - 通过 `tools/build.sh` 从 `scripts/` 目录生成
  - 合并了所有依赖的工具函数

### 测试相关目录

- **tests/**: 测试脚本目录，按安装脚本分组
  - `test-utils.sh`: 提供断言函数和测试工具
  - `install-*/`: 每个安装脚本对应的测试目录
    - `01-ok.sh`: 基础功能测试（语法、权限、基本功能）
    - `02-integration.sh`: 集成和兼容性测试（完整安装流程）

### Docker 测试环境

- **docker/**: Docker 配置目录
  - `Dockerfile.ubuntu22-04`: Ubuntu 22.04 测试镜像
  - `Dockerfile.ubuntu20-04`: Ubuntu 20.04 测试镜像
  - `Dockerfile.ubuntu24-04`: Ubuntu 24.04 测试镜像
  - `Dockerfile.debian11-9`: Debian 11.9 测试镜像
  - `Dockerfile.debian12-2`: Debian 12.2 测试镜像
  - `Dockerfile.fedora41`: Fedora 41 测试镜像
  - `Dockerfile.redhat8-10`: RedHat 8.10 测试镜像
  - `Dockerfile.redhat9-6`: RedHat 9.6 测试镜像
  - `docker-compose.yml`: 多环境测试编排
  - `.dockerignore`: Docker 构建优化

### 工具和自动化

- **tools/**: 工具脚本目录
  - `test-runner.sh`: 统一的测试运行器，支持运行单个测试或所有测试
  - `build.sh`: 脚本构建和合并工具
  - `demo.sh`: 快速演示和验证脚本

- **Makefile**: 简化常用操作（构建、测试、清理）
- **.github/workflows/**: CI/CD 自动化测试

### 文档目录

- **docs/**: 文档目录
  - `TESTING.md`: 详细的测试使用指南
  
- **README.md**: 项目概述和快速开始（英文）
- **README.zh-CN.md**: 项目说明（中文）
- **.github/instructions/**: 项目开发和维护说明
  - `directory-structure.instructions.md`: 本文档
  - `chat-context-record.md`: 开发上下文记录
  - `project-summary.md`: 项目实施总结

### 备份和历史

- **scripts-back/**: 存放备份或历史版本的脚本
  - 包含各种工具函数的历史实现
  - 可作为参考或回滚使用

## 开发工作流程

### 脚本开发流程

1. 在 `scripts/` 中编写新的安装脚本
2. 运行 `tools/build.sh` 合并脚本到 `dist/`
3. 在 `tests/` 中为新脚本创建测试
4. 使用 `tools/test-runner.sh` 运行测试
5. 通过 Docker 在多环境中验证

### 测试开发流程

```bash
# 快速测试
make test                    # Ubuntu 22.04 环境测试
make test-all               # 所有环境测试

# 开发测试
./tools/test-runner.sh --test tests/install-git/01-ok.sh
./tools/test-runner.sh --all
```

### 构建流程

```bash
# 构建脚本
make build-scripts

# 构建 Docker 镜像
make build
```

## 添加新脚本的标准流程

### 1. 创建安装脚本

```bash
# 在 scripts/ 目录创建新脚本
cat > scripts/install-nodejs.sh << 'EOF'
#!/bin/bash
source ./__base.sh

# Node.js 安装逻辑
install_nodejs() {
    log_info "开始安装 Node.js..."
    # 具体安装代码
}

main() {
    install_nodejs
}

main "$@"
EOF

chmod +x scripts/install-nodejs.sh
```

### 2. 构建脚本

```bash
bash build.sh
```

### 3. 创建测试

```bash
# 创建测试目录
mkdir -p tests/install-nodejs

# 创建基础测试
cat > tests/install-nodejs/01-ok.sh << 'EOF'
#!/bin/bash
source "$(dirname "$0")/../test-utils.sh"

SCRIPT_PATH="$(dirname "$0")/../../dist/install-nodejs.sh"

setup_test_env

test_info "开始测试 install-nodejs.sh 脚本"

# 基础检查
assert_file_exists "$SCRIPT_PATH" "脚本文件存在"
assert_success "bash -n '$SCRIPT_PATH'" "脚本语法正确"

# 功能测试
# 添加具体的测试逻辑...

show_test_summary
EOF

chmod +x tests/install-nodejs/01-ok.sh
```

### 4. 运行测试

```bash
./test-runner.sh --test tests/install-nodejs/01-ok.sh
```

## 最佳实践

### 脚本开发最佳实践

- 在 `scripts/` 中使用模块化设计
- 依赖 `__base.sh` 提供的通用函数
- 保持脚本的幂等性和错误处理
- 添加详细的日志输出
- 支持静默和交互模式

### 测试开发最佳实践

- 每个安装脚本至少包含基础测试和集成测试
- 使用 `tests/test-utils.sh` 提供的断言函数
- 测试应该独立运行，不依赖外部状态
- 测试环境要可重现和可清理
- 覆盖正常流程和异常情况

### Docker 使用最佳实践

- 使用 Docker 进行隔离测试
- 支持多个 Linux 发行版的兼容性测试
- 测试环境应该可重现和可清理
- 合理使用镜像缓存加速构建

## 维护和版本控制

### 文件权限管理

确保脚本具有正确的执行权限：

```bash
chmod +x build.sh test-runner.sh demo.sh
chmod +x scripts/*.sh tests/**/*.sh
chmod +x dist/*.sh
```

### 清理和重建

```bash
make clean          # 清理 Docker 资源
make build-scripts  # 重新构建脚本
make build          # 重新构建 Docker 镜像
```

### 代码质量保证

- 使用 `bash -n script.sh` 检查语法
- 使用 shellcheck 进行静态分析（如果可用）
- 确保所有测试通过后再提交代码
- 定期运行完整的测试套件

## 扩展指南

### 添加新的 Linux 发行版支持

1. 创建新的 Dockerfile（如 `Dockerfile.alpine`）
2. 在 `docker-compose.yml` 中添加新服务
3. 更新 `Makefile` 添加对应的测试目标
4. 在 CI/CD 配置中添加新环境

### 添加新的测试类型

1. 在测试工具库中添加新的断言函数
2. 创建新的测试模板
3. 更新测试运行器支持新类型
4. 更新文档说明新测试类型的使用

### 集成外部工具

1. 在 Dockerfile 中添加工具安装
2. 在测试工具库中添加集成函数
3. 更新构建脚本支持新工具
4. 添加相应的文档说明

这个目录结构设计支持项目的持续发展，易于维护和扩展。
