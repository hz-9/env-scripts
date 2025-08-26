# 测试指南

## 🚀 快速测试

```bash
# 构建脚本
make build-scripts

# 构建Docker镜像和脚本
make build

# 运行所有安装脚本的所有测试
make install-test-all

# 在中国网络环境下运行所有安装脚本的所有测试
make install-test-all NETWORK=in-china

# 运行所有数据库同步脚本的所有测试
make syncdb-test-all

# 在中国网络环境下运行所有数据库同步脚本的所有测试
make syncdb-test-all NETWORK=in-china
```

## 🎯 精确测试

### 安装脚本测试

#### 在所有环境中测试特定脚本

```bash
# 在所有环境中测试特定的安装脚本
make install-test-all-env SCRIPT=git
make install-test-all-env SCRIPT=docker
make install-test-all-env SCRIPT=node

# 在中国网络环境下测试
make install-test-all-env SCRIPT=git NETWORK=in-china
```

#### 在特定环境中测试所有脚本

```bash
# 在指定环境中运行所有安装脚本测试
make install-test-all-script ENV=debian11-9
make install-test-all-script ENV=debian12-2
make install-test-all-script ENV=fedora41
make install-test-all-script ENV=redhat8-10
make install-test-all-script ENV=redhat9-6
make install-test-all-script ENV=ubuntu20-04
make install-test-all-script ENV=ubuntu22-04
make install-test-all-script ENV=ubuntu24-04

# 使用中国网络
make install-test-all-script ENV=ubuntu22-04 NETWORK=in-china
```

#### 在特定环境中测试特定脚本

```bash
# 在特定环境中测试特定安装脚本
make install-test-single ENV=ubuntu22-04 SCRIPT=git
make install-test-single ENV=debian12-2 SCRIPT=docker NETWORK=in-china
```

#### 运行特定测试文件

```bash
# 在特定环境中运行特定测试文件
make install-test-file ENV=debian11-9 FILE=tests/install-git/01-ok.sh
make install-test-file ENV=ubuntu22-04 FILE=tests/install-docker/02-install.sh NETWORK=in-china
```

### 数据库同步脚本测试

#### 在所有环境中测试特定同步脚本

```bash
# 在所有环境中测试特定的数据库同步脚本
make syncdb-test-all-env SCRIPT=postgresql
make syncdb-test-all-env SCRIPT=mysql
make syncdb-test-all-env SCRIPT=mongo

# 在中国网络环境下测试
make syncdb-test-all-env SCRIPT=postgresql NETWORK=in-china
```

#### 在特定环境中测试所有同步脚本

```bash
# 在指定环境中运行所有数据库同步脚本测试
make syncdb-test-all-script ENV=debian11-9
make syncdb-test-all-script ENV=ubuntu22-04

# 使用中国网络
make syncdb-test-all-script ENV=ubuntu22-04 NETWORK=in-china
```

#### 在特定环境中测试特定同步脚本

```bash
# 在特定环境中测试特定数据库同步脚本
make syncdb-test-single ENV=ubuntu22-04 SCRIPT=postgresql
make syncdb-test-single ENV=debian12-2 SCRIPT=mysql NETWORK=in-china
make syncdb-test-single ENV=ubuntu24-04 SCRIPT=mongo NETWORK=in-china
```

#### 运行特定同步测试文件

```bash
# 在特定环境中运行特定同步测试文件
make syncdb-test-file ENV=debian11-9 FILE=tests/syncdb-postgresql/01-ok.sh
make syncdb-test-file ENV=ubuntu22-04 FILE=tests/syncdb-mysql/02-install.sh NETWORK=in-china
```

## 🛠️ 其他命令

```bash
# 交互式测试环境
make interactive

# 在容器中启动 shell
make shell

# 清理 Docker 镜像和容器
make clean

# 查看 Docker 日志
make logs

# 显示测试结果
make results
```

## 🌐 测试参数

所有测试命令支持以下参数：

- `NETWORK=in-china` - 使用中国网络环境配置，适用于中国内地用户
- `DEBUG=true` - 启用调试模式，显示详细输出

## 🖥️ 支持的测试环境

测试支持以下环境：

- **Ubuntu**: 20.04, 22.04, 24.04 (AMD64)
- **Debian**: 11.9, 12.2 (AMD64)
- **Fedora**: 41 (AMD64)
- **Red Hat Enterprise Linux**: 8.10, 9.6 (AMD64)

## 🧪 测试架构

测试框架使用 Docker 容器在隔离的环境中运行测试，确保测试结果的一致性和可重复性。测试流程包括：

1. 构建脚本和 Docker 镜像
2. 在指定环境中运行测试
3. 收集测试结果和日志
4. 生成测试报告

每个脚本都有两种基本的测试类型：

- **基本验证测试 (01-ok.sh)** - 检查脚本语法、帮助信息和操作系统兼容性
- **安装测试 (02-install.sh)** - 测试实际安装功能

## 📋 开发新测试

要为新脚本添加测试，请遵循以下步骤：

1. 在 `tests/` 目录下为脚本创建一个子目录（例如 `tests/install-TOOL` 或 `tests/syncdb-DATABASE`）
2. 添加至少两个测试文件：`01-ok.sh` 和 `02-install.sh`
3. 使用测试工具库中的断言函数来验证脚本行为
4. 运行测试以确保它们在所有支持的环境中都能正常工作
