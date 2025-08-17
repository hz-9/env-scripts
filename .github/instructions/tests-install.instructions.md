---
applyTo: "tests/install-*/*.sh"
---

`tests/install-*/*.sh` 文件是用于测试安装脚本的测试脚本。这些测试脚本通常会依赖于 `tests/test-utils.sh` 中提供的断言函数，以确保测试过程的一致性和可重用性。

每个测试脚本均应支持 `.github/instructions/docker-file.instructions.md` 文件内的所有系统。

`scripts/install-*.sh` 的每个文件，均应在 `tests/install-*/` 目录下有对应的测试脚本。至少会存在 `01-ok.sh` 和 `02-install.sh` 两个测试脚本。

`tests/install-*/01-ok.sh` 需要进行以下测试内容：

- 检查点1: Check if script file exists
- 检查点2: Check if script is executable
- 检查点3: Check script syntax
- 检查点4: Test --help can output normally
- 检查点0: Check if current OS is supported

`tests/install-*/02-install.sh` 需要进行以下测试内容：

- 检查点0: Check if current OS is supported
- 检查点1: Install script execution result
- 检查点2: Check if software is successfully installed
- 检查点3: Get and verify software version information

**AI 进行单元测试时，优先使用 --network=in-china 参数**