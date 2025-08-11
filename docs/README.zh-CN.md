# 环境脚本

为不同系统提供开箱即用的开发环境安装脚本集合。

## 🎯 项目目的

本仓库提供位于 `dist/` 目录的**生产就绪安装脚本**。开发者可以直接下载并执行这些脚本来安装各种开发工具和环境。

## 📁 项目结构

| 目录        | 描述                                     |
| ----------- | ---------------------------------------- |
| `dist/`     | **最终生产脚本** - 可直接使用            |
| `scripts/`  | 开发用源脚本                            |
| `tools/`    | 构建和测试工具                          |
| `tests/`    | 综合测试套件                            |
| `docker/`   | 测试用Docker环境                        |
| `docs/`     | 文档                                    |

## 🚀 快速开始

### 直接使用（推荐）

直接从 `dist/` 目录下载并运行脚本：

```bash
# 安装Git
curl -o-   https://raw.githubusercontent.com/hz-9/env-scripts/master/dist/install-git.sh | bash

wget -qO-  https://raw.githubusercontent.com/hz-9/env-scripts/master/dist/install-git.sh | bash
```

点击这里查看所有支持的 [脚本](./overview/scripts.md)。

### 本地使用

```bash
# 克隆仓库
git clone https://github.com/hz-9/env-scripts.git
cd env-script

# 直接使用脚本
./dist/install-git.sh --help
./dist/install-git.sh --network=in-china
```

## 支持的系统

- Ubuntu 20.04/22.04/24.04 AMD64
- Debian 11.9/12.2 AMD64
- Fedora 41 AMD64
- Red Hat Enterprise Linux 8.10/9.6 AMD64

> 通常也支持所有的子版本号相同的系统，例如 Debian 11.8/12.1 等。

## 🛠️ 开发

### 构建脚本

`dist/` 中的脚本由 `scripts/` 源文件自动生成：

```bash
# 构建所有脚本
make build-scripts

# 或直接使用构建工具
./tools/build.sh
```

### 测试

使用Docker跨多个Linux发行版进行综合测试：

```bash
# 在所有环境中运行所有测试
make test-all

# 使用中国网络配置测试
make test-all NETWORK=in-china

# 在指定环境运行指定测试
make test-single ENV=ubuntu22-test TEST=tests/install-git/01-ok.sh

# 启动交互式测试环境
make interactive
```

更多测试使用说明请参见 [测试指南](./overview/testing.md)。

**可用测试环境：**

- Ubuntu 20.04/22.04/24.04
- Debian 11.9/12.2
- Fedora 41
- Red Hat Enterprise Linux 8.10/9.6

### 添加新脚本

1. 在 `scripts/` 目录创建源脚本
2. 在 `tests/` 中添加相应测试
3. 使用 `make build-scripts` 构建
4. 使用 `make test-all` 测试

## 📖 文档

- [测试指南](overview/testing.md) - 综合测试文档
- [目录结构](overview/directory-structure.md) - 详细项目结构

## 🌏 网络配置

所有脚本都支持 `--network=in-china` 参数，适用于中国用户：

- 使用华为云镜像源
- 优化下载速度
- 确保中国用户的可靠性

## 🤝 贡献

1. Fork 本仓库
2. 创建功能分支
3. 为新功能添加测试
4. 确保所有测试通过：`make test-all`
5. 提交Pull Request

## 📄 许可证

本项目采用 MIT 许可证。
