该仓库是一个基于 Bash 的开发环境脚本与测试基础设施，其错误处理机制主要依赖于 **Bash 内置的退出码（Exit Codes）**、**`set -e` 严格模式**以及**自定义的控制台输出函数**。没有使用复杂的异常捕获框架或中间件，而是通过标准化的脚本结构和测试断言来管理错误。

### 1. 核心策略：退出码与严格模式

*   **退出码约定**：
    *   `0`: 成功。
    *   `1`: 通用错误（如参数缺失、不支持的操作系统、安装失败）。
    *   `2`: 跳过（Skip）。在测试脚本中，如果当前操作系统不受支持，测试会返回 `2`，表示该测试被跳过而非失败。
*   **`set -e` 的使用**：
    *   部分工具脚本（如 `tools/test-runner.sh`, `scripts/generate-pages.sh`）在文件头部声明 `set -e`，确保任何命令执行失败时立即终止脚本。
    *   在安装脚本（如 `scripts/install-docker.sh`）中，通常不全局开启 `set -e`，而是通过手动检查命令返回值或使用 `eval ... || true` 来处理非关键步骤的失败。

### 2. 错误呈现：控制台模块 (`scripts/__base.sh`)

仓库定义了一套统一的颜色编码输出函数，用于标准化错误信息的呈现：
*   `console_error_line "msg"`: 输出红色的 `[ERROR]` 前缀消息。
*   `console_content_error "msg"`: 输出详细的错误原因，通常配合 `exit 1` 使用。
*   `console_warning_line "msg"`: 输出黄色的 `[WARNING]` 消息。
*   `console_info_line "msg"`: 输出蓝色的 `[INFO]` 消息。

### 3. 测试框架中的错误处理 (`tests/__base.sh`)

测试基础设施采用“检查点（Checkpoint）”模式来处理错误：
*   **断言函数**：提供 `assert_success`, `assert_file_exists`, `assert_contains` 等函数，这些函数通过返回 `0` 或 `1` 来表示断言是否通过。
*   **检查点逻辑**：
    *   `checkpoint_staring`: 开始一个测试检查点。
    *   `checkpoint_complete`: 标记检查点成功，增加通过计数。
    *   `checkpoint_error`: 标记检查点失败，增加失败计数，并输出红色状态。
    *   `checkpoint_skip`: 标记检查点被跳过（例如 OS 不支持）。
*   **清理机制**：使用 `trap cleanup_test_env EXIT` 确保无论测试成功或失败，临时目录都会被清理。

### 4. 开发规范与建议

*   **参数校验**：所有脚本应在执行核心逻辑前校验必需参数。如果缺失，调用 `console_error_line` 提示并 `exit 1`。
*   **OS 兼容性检查**：脚本应首先调用 `os_parse_info_with_after` 解析系统信息，并通过 `SUPPORT_OS_LIST` 检查兼容性。如果不支持，应输出错误并退出。
*   **错误日志记录**：在 Makefile 和测试运行器中，错误输出通常通过 `tee` 重定向到 `logs/` 目录下的时间戳文件中，便于后续排查。
*   **避免静默失败**：在执行关键系统命令（如 `apt-get install`）时，应检查返回值。如果失败，应立即调用 `console_content_error` 并退出，而不是让脚本继续执行导致不可预知的状态。