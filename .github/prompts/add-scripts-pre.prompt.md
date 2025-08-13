---
mode: 'agent'
model: Claude Sonnet 3.7
description: '添加脚本准备工作'
---

# 添加脚本准备工作

此命令时在添加脚本之前的准备工作，主要包括以下内容：

1. 读取 `.github/instructions` 路径下项目规范；
2. 读取 `scripts/*.sh` 已经存在的脚本文件；
3. 读取 `tests/**/*.sh` 已经存在的单元测试脚本；
4. 读取 `docs/overview/**/*.md` 已经存在的文档文件；

在准备完成后，请直接输出 “准备完成” 即可，请等待对于新增脚本的具体指令。

对于新增脚本的具体内容，请完成一下工作项：

1. 在 `scripts/` 目录下创建新的脚本文件；
2. 在 `tests/` 目录下创建对应的单元测试脚本；
3. 在 `docs/overview/scripts.zh-CN.md` 文档中添加对应的脚本示例；
4. 在 `docs/overview/scripts.md` 文档中添加对应的脚本示例；
