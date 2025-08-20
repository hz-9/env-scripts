---
applyTo: "tests/syncdb-*/*.sh"
---

`tests/syncdb-*/*.sh` 文件是用于测试安装脚本的测试脚本。这些测试脚本通常会依赖于 `tests/test-utils.sh` 中提供的断言函数，以确保测试过程的一致性和可重用性。

每个测试脚本均应支持 `.github/instructions/docker-file.instructions.md` 文件内的所有系统。

`scripts/syncdb-*.sh` 的每个文件，均应在 `tests/syncdb-*/` 目录下有对应的测试脚本。至少会存在 `01-ok.sh` 和 `02-install.sh` 两个测试脚本。

`tests/syncdb-*/01-ok.sh` 需要进行以下测试内容：

- 检查点1: Check if script file exists
- 检查点2: Check if script is executable
- 检查点3: Check script syntax
- 检查点4: Test --help can output normally
- 检查点0: Check if current OS is supported

`tests/syncdb-*/02-install.sh` 需要进行以下测试内容：

- 检查点0: Check if current OS is supported
- 检查点1: Pull DOcker Image
- 检查点2: Init Docker Container
- 检查点3: Init data
- 检查点4: Install script execution result
- 检查点5: Check Data

**AI 进行单元测试时，优先使用 --network=in-china 参数**