---
mode: 'edit'
model: GPT-4.1
description: '同步仓库文档'
---

# 文档同步任务

- `docs/README.zh-CN.md` 与 `docs/README.md` 文档；
  - 以 `docs/README.zh-CN.md` 文档为主；
  - 读取 `docs/README.zh-CN.md` 文档内容，如果有疏漏或错误，进行修正；
  - 将 `docs/README.zh-CN.md` 文档翻译为英文，保存为 `docs/README.md` 文档；

- `docs/overview/testing.zh-CN.md` 与 `docs/overview/testing.md` 文档；
  - 以 `docs/overview/testing.zh-CN.md` 文档为主；
  - 读取 `docs/overview/testing.zh-CN.md` 文档内容，如果有疏漏或错误，进行修正；
  - 将 `docs/overview/testing.zh-CN.md` 文档翻译为英文，保存为 `docs/overview/testing.md` 文档；

- `docs/overview/directory-structure.zh-CN.md` 与 `docs/overview/directory-structure.md` 文档；
  - 以 `docs/overview/directory-structure.zh-CN.md` 文档为主；
  - 读取 `docs/overview/directory-structure.zh-CN.md` 文档内容，如果有疏漏或错误，进行修正；
  - 扫描当前项目目录结构，对 `docs/overview/directory-structure.zh-CN.md` 进行同步与升级；
  - 忽略 `.gitignore` 文件中的路径；
  - 将 `docs/overview/directory-structure.zh-CN.md` 文档翻译为英文，保存为 `docs/overview/directory-structure.md` 文档；

- `docs/overview/scripts.zh-CN.md` 与 `docs/overview/scripts.md` 文档；
  - 以 `docs/overview/scripts.zh-CN.md` 文档为主；
  - 读取 `docs/overview/scripts.zh-CN.md` 文档内容，如果有疏漏或错误，进行修正；
  - 扫描 `scripts/*.sh`，对 `docs/overview/scripts.zh-CN.md` 进行同步与升级；
  - 忽略 `scripts/__base.sh` 文件；
  - 将 `docs/overview/scripts.zh-CN.md` 文档翻译为英文，保存为 `docs/overview/scripts.md` 文档；
