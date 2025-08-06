---
applyTo: "scripts/install-*.sh"
---

`scripts/install-*.sh` 文件是用于安装各种软件的脚本。这些脚本通常会依赖于 `scripts/__base.sh` 中提供的通用函数，以确保安装过程的一致性和可重用性。

每个脚本均应支持 `.github/instructions/docker-file.instructions.md` 文件内的所有系统。

`SUPPORT_OS_LIST` 变量会定义此脚本支持的操作系统列表。需要保证该列表与 `.github/instructions/docker-file.instructions.md` 文件内的操作系统版本一致。

`PARAMTERS` 中，至少包含以下参数：

- `--help`: 显示帮助信息
- `--debug`: 启用调试模式
- `--network`: 指定网络环境（如 `in-china`）。默认为 `default`。
- `--*-version`: 指定软件的安装版本。默认为 `default`。

`--*-version` 参数在 `install-git.sh` 脚本中为 `--git-version`，用于指定 Git 的版本。

`scripts/install-*.sh` 的每个文件，均应在 `tests/install-*/` 目录下有对应的测试脚本。具体要求以 `.github/instructions/tests-install.instructions.md` 文件为准。
