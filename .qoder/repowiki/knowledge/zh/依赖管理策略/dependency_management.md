该仓库的依赖管理主要集中在文档构建子系统（`docs/.vuepress`）中，采用 **pnpm** 作为包管理器，并配合 **Lockfile** 进行版本锁定。核心业务脚本（Shell scripts）和测试基础设施（Docker）不依赖传统的代码级包管理器，而是通过 Docker 镜像和系统包管理器（apt/dnf/yum）在运行时环境中间接管理依赖。

### 1. 文档子系统依赖管理
- **包管理器**: 使用 `pnpm`。证据包括 `docs/.vuepress/pnpm-lock.yaml` 和 `package.json` 中的脚本 `pnpm dlx vp-update`。
- **版本锁定**: 同时存在 `pnpm-lock.yaml` (lockfileVersion: '9.0') 和 `package-lock.json` (lockfileVersion: 3)。这表明项目可能从 npm 迁移至 pnpm，或为了兼容性保留了两种锁文件，但实际开发推荐使用 pnpm 以确保依赖树的一致性和磁盘空间效率。
- **Node.js 版本控制**: 根目录和 `docs/.vuepress` 下均包含 `.nvmrc` 文件，指定 Node.js 版本为 `v20.20.2`，确保开发环境的一致性。
- **依赖范围**: 主要依赖 VuePress 2.0 (RC版本) 及其主题 `vuepress-theme-hope`，以及相关的构建工具如 Vite 和 Sass。

### 2. 环境与系统依赖管理
- **Docker 化环境**: 通过 `docker/docker-compose.yml` 和多个 `Dockerfile.*` 定义测试环境。依赖（如 git, curl, docker-ce 等）在 Docker 构建阶段通过各发行版的系统包管理器安装。
- **脚本化安装**: `scripts/` 目录下的 Shell 脚本（如 `install-node.sh`, `install-docker.sh`）提供了在宿主机或容器中安装特定工具的逻辑，这些脚本是环境依赖管理的执行载体。
- **无代码级依赖**: 核心功能由 Shell 脚本实现，因此不存在 `go.mod`, `requirements.txt` 或 `Cargo.toml` 等语言特定的依赖清单。

### 3. 开发者规范
- **文档开发**: 在 `docs/.vuepress` 目录下操作时，必须使用 `pnpm install` 安装依赖，并使用 `pnpm run docs:dev` 启动服务。
- **环境一致性**: 建议使用 `nvm use` 切换到 `.nvmrc` 指定的 Node.js 版本。
- **锁文件维护**: 更新文档依赖后，应提交 `pnpm-lock.yaml` 以锁定新版本。