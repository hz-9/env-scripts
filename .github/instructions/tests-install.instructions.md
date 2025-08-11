---
applyTo: "tests/install-*/*.sh"
---

`tests/install-*/*.sh` 文件是用于测试安装脚本的测试脚本。这些测试脚本通常会依赖于 `tests/test-utils.sh` 中提供的断言函数，以确保测试过程的一致性和可重用性。

每个测试脚本均应支持 `.github/instructions/docker-file.instructions.md` 文件内的所有系统。

`scripts/install-*.sh` 的每个文件，均应在 `tests/install-*/` 目录下有对应的测试脚本。至少会存在 `01-ok.sh` 和 `02-install.sh` 两个测试脚本。

`tests/install-*/01-ok.sh` 需要进行以下测试内容：

- 检查点0: 检测是否支持此操作系统，如果不支持，则跳过测试。最终的测试结果应为 `Skip`。
- 检查点1: 检查脚本文件是否存在
- 检查点2: 检查脚本是否可执行
- 检查点3: 检查脚本语法
- 检查点4: 检测 `--help` 可以正常输出
- 检查点5: 输出一个 `--help` 信息

`tests/install-*/02-install.sh` 需要进行以下测试内容：

- 检查点0: 检测是否支持此操作系统，如果不支持，则跳过测试。最终的测试结果应为 `Skip`。
- 检查点1: 文件是否有正确运行
- 检查点2: 是否有正常安装
- 检查点3: 版本信息是否能正确获取？

**AI 进行单元测试时，优先使用 --network=in-china 参数**