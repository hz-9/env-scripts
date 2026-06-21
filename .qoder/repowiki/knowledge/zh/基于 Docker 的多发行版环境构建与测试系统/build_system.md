该项目采用 **Makefile + Docker Compose + Bash** 的混合构建体系，专注于跨 Linux 发行版（Ubuntu, Debian, Fedora, RHEL）的环境脚本自动化测试与分发。

### 1. 核心构建流程
*   **脚本打包 (`build-scripts`)**：通过 `tools/build.sh` 将 `scripts/` 目录下的源文件进行依赖合并（处理 `source` 指令），生成独立的、可分发的 Shell 脚本至 `dist/` 目录。此过程会自动添加 Shebang 并移除内部工具引用。
*   **镜像构建 (`build-images`)**：利用 `docker/docker-compose.yml` 定义的多阶段服务，为 8 种不同的 Linux 发行版版本构建专用的 Docker 镜像。镜像分为基础版和包含 Docker CE 的 `-docker` 版。
*   **统一入口**：执行 `make build` 可串行触发脚本打包与镜像构建。

### 2. 自动化测试架构
项目设计了分层级的测试执行器，支持在隔离的容器环境中验证脚本行为：
*   **环境管理器 (`test-environment-manager.sh`)**：作为测试调度中心，根据 `--mode`（如 `all`, `single`, `all-env`）和 `--scope`（`install` 或 `syncdb`）参数，动态调用 Docker Compose 在指定容器中运行测试。
*   **测试运行器 (`test-runner.sh`)**：在容器内部执行具体的单元测试文件（位于 `tests/` 目录），捕获输出并解析退出码（0: 成功, 2: 跳过, 其他: 失败）。
*   **矩阵测试**：支持通过 `NETWORK=in-china` 等环境变量模拟不同网络条件，并通过 `DEBUG=true` 开启详细日志。

### 3. CI/CD 与发布
*   **文档自动化**：`.github/workflows/generate-pages.yml` 配置了 GitHub Actions，在推送到 `master` 分支时自动使用 VuePress 构建文档并发布至 GitHub Pages。
*   **日志管理**：所有测试执行结果均会按时间戳归档至 `logs/` 目录，便于追溯跨环境的兼容性问题。

### 4. 开发规范
*   **脚本命名**：生产脚本位于 `scripts/`，测试用例位于 `tests/<script-name>/`，且测试文件通常以数字前缀（如 `01-ok.sh`）定义执行顺序。
*   **环境隔离**：严禁在宿主机直接运行安装脚本进行测试，必须通过 `make install-test-*` 或 `make syncdb-test-*` 系列命令在容器中执行。
*   **依赖处理**：源脚本中若需引用公共函数，应使用 `source __base.sh`，构建工具会自动将其内联到最终的分发文件中。