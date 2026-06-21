该仓库没有传统意义上的应用运行时配置文件（如 `application.properties`、`.env` 或集中式配置中心）。其“配置”主要体现在**构建/测试环境的驱动参数**、**Docker 容器环境变量**以及**脚本内部的默认值与 OS 适配逻辑**上。整体采用“约定优于配置” + “命令行参数覆盖”的模式。

### 1. 核心配置来源与分层

- **第一层：Makefile 入口参数**
  - `Makefile` 是主要的使用入口，通过环境变量形式接收用户配置，如 `NETWORK=in-china`、`DEBUG=true`、`OUTPUT=path`、`ENV=ubuntu22-04`、`SCRIPT=git` 等。
  - 这些变量在 Make target 中被拼接为长参数字符串（如 `--network=$(NETWORK) --debug`），传递给 `tools/test-environment-manager.sh`。

- **第二层：测试环境管理器参数解析**
  - `tools/test-environment-manager.sh` 使用 `scripts/__base.sh` 中的 `parse_user_param_for_short_params` 和 `get_user_param` 解析来自 Makefile 的参数。
  - 关键配置项包括：
    - `--mode`: 测试范围（`all`, `all-env`, `all-script`, `single`）。
    - `--scope`: 业务范畴（`install` 或 `syncdb`）。
    - `--env`: 指定 Docker 服务名（如 `ubuntu22-04`）。
    - `--network`: 网络镜像源策略（`default` 或 `in-china`）。
    - `--debug`: 是否开启详细日志输出。
    - `--docker-image-quick-check`: 针对数据库同步测试的快速检查标志。

- **第三层：Docker Compose 环境定义**
  - `docker/docker-compose.yml` 定义了所有受支持的 OS 环境（Ubuntu, Debian, Fedora, RedHat）。
  - **环境变量注入**：每个服务都注入了 `TEST_ENV=docker`，Debian/Ubuntu 系列还注入了 `DEBIAN_FRONTEND=noninteractive`。
  - **卷挂载配置**：将宿主机的 `scripts/`, `tests/`, `tools/`, `dist/` 挂载到容器内 `/app/` 对应目录，实现了代码与环境的解耦配置。
  - **缓存持久化配置**：通过挂载 `temp/.docker/<os>/apt-lists` 等目录，配置了包管理器的缓存持久化策略，加速重复构建。

- **第四层：脚本内部默认配置与 OS 适配**
  - `scripts/__base.sh` 是配置逻辑的核心库。
  - **OS 自动探测**：通过读取 `/etc/os-release` 自动识别 `OS_NAME`, `OS_VERS`, `OS_ARCH`，并据此设置 `USE_APT_GET_INSTALL` 或 `USE_DNF_INSTALL` 布尔标志。
  - **镜像源动态配置**：根据 `--network` 参数和识别出的 OS 版本，动态生成并写入 `/etc/apt/sources.list` 或 `/etc/yum.repos.d/*.repo`，切换至华为云等国内镜像源。
  - **参数默认值**：在 `print_default_param` 中定义了全局默认参数，如 `--help` (默认 false), `--debug` (默认 false)。

### 2. 关键文件与职责

| 文件路径 | 职责描述 |
| :--- | :--- |
| `Makefile` | 顶层配置入口，定义用户可传入的环境变量及其向底层脚本的映射规则。 |
| `docker/docker-compose.yml` | 基础设施配置，定义多 OS 测试环境的容器化参数、环境变量及卷挂载。 |
| `scripts/__base.sh` | 配置解析引擎，提供参数解析、OS 识别、镜像源切换逻辑及默认值管理。 |
| `tools/test-environment-manager.sh` | 配置路由中心，接收上层参数并决定在哪些 Docker 环境中执行哪些测试。 |
| `docs-build.config.json` | 文档站点配置，独立于运行环境，用于 VuePress 站点的导航与多语言设置。 |

### 3. 开发规范与约束

- **参数传递规范**：所有配置应通过命令行参数（`--key=value` 或 `--key`）传递，避免硬编码。脚本必须兼容 `__base.sh` 中的参数解析框架。
- **环境无关性**：脚本不应依赖宿主机的特定路径或状态，所有依赖应通过 Docker 卷挂载或容器内初始化逻辑（如 `apt_setup_mirrors`）解决。
- **网络适配**：涉及网络下载的脚本必须支持 `--network` 参数，以便在受限网络环境下自动切换镜像源。
- **调试开关**：所有脚本应尊重 `--debug` 标志，在非调试模式下抑制冗余输出（通过 `console_redirect_output` 实现）。
