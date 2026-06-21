该仓库采用基于 Bash 的自定义控制台日志系统，主要服务于开发环境安装脚本和自动化测试基础设施。系统未引入第三方日志框架（如 log4j、zap 等），而是通过 `scripts/__base.sh` 中定义的 ANSI 转义码和格式化函数实现结构化输出。

### 1. 核心组件与文件
- **`scripts/__base.sh`**: 日志系统的核心定义文件。包含颜色常量（RED, GREEN, YELLOW, BLUE 等）和一系列 `console_*` 函数，用于统一输出格式。
- **`tests/__base.sh`**: 测试专用的日志与断言辅助文件，复用 `__base.sh` 中的基础日志功能，并扩展了测试用例的状态输出（如 Checkpoint 状态）。
- **`Makefile`**: 负责顶层测试执行的日志路由，使用 `tee` 命令将标准输出和错误输出同时写入 `logs/` 目录下的时间戳文件中。
- **`tools/test-runner.sh`** & **`tools/test-environment-manager.sh`**: 测试执行器，负责在 Docker 容器中运行测试并捕获输出，通过 `console_info_line` 等函数报告执行状态。

### 2. 日志级别与约定
系统定义了以下五种主要的日志级别/类型，均通过带颜色的前缀标识：
- **[INFO]** (`console_info_line`): 蓝色，用于常规流程信息。
- **[SUCCESS]** (`console_success_line`): 绿色，用于操作成功确认。
- **[WARNING]** (`console_warning_line`): 黄色，用于警告或非致命错误。
- **[ERROR]** (`console_error_line`): 红色，用于错误报告。
- **[DEBUG]** (`console_debug_line`): 无颜色或特定标识，仅在 `--debug` 参数启用时输出详细信息。

此外，还有针对模块生命周期的专用输出：
- `console_content_starting` / `console_content_complete`: 用于标记耗时操作的开始与结束，并自动计算耗时（秒）。
- `console_module_title`: 用于划分不同的执行阶段或模块。

### 3. 输出路由与持久化
- **控制台实时输出**: 所有脚本默认将日志输出到 stdout/stderr，利用 ANSI 颜色码提升可读性。
- **文件持久化**: 通过 `Makefile` 中的 `tee` 命令，所有测试执行过程（包括 `install-test-*` 和 `syncdb-test-*` 目标）都会被完整记录到 `logs/` 目录下，文件名格式为 `<task>.<YYYYMMDD-HHMMSS>.log`。
- **调试模式控制**: 系统支持 `--debug` 参数。在非调试模式下，部分冗长的安装命令输出会被重定向到 `/dev/null`（通过 `console_redirect_output` 函数实现），仅保留关键的开始/结束状态；在调试模式下，则展示完整输出。

### 4. 开发者规范
- **统一入口**: 所有脚本应 `source scripts/__base.sh` 以获取日志函数。
- **避免裸 echo**: 除非是简单的字符串拼接，否则应使用 `console_info_line` 等专用函数，以确保日志风格一致且支持颜色高亮。
- **敏感信息处理**: 当前系统主要通过 `--debug` 开关控制详细程度，开发者在编写脚本时应注意不要在 INFO 级别日志中打印敏感凭证。