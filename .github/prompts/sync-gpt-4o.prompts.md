---
mode: 'agent'
model: GPT-4o
tools: ['githubRepo', 'codebase']
description: '基于 instructions 同步代码程序'
---

# 基于 instructions 同步代码程序

## 概述

本文档记录了根据 `.github/instructions` 目录下的指令文件，对仓库进行规范化同步的完整操作流程。

## 快捷执行命令

```markdown
请重新加载 .github/instructions 路径下的资料，查看当前仓库中哪些内容不符合要求，并进行修改。
```

## 核心操作步骤

### 1. 重新加载指令文件

读取所有指令文件，了解规范要求：

- docker-compose.instructions.md
- docker-file.instructions.md  
- scripts-base.instructions.md
- scripts-install.instructions.md
- tests-install.instructions.md

关键规范要点：

- 支持的操作系统：Ubuntu 20.04/22.04/24.04, Debian 11.9/12.2, Fedora 41, RedHat 8.10/9.6
- Dockerfile 文件命名规范：Dockerfile.ubuntu20-04（而非 Dockerfile.ubuntu20）
- 脚本必需参数：--help, --debug, --network, --*-version

### 2. 修复 Dockerfile 文件名规范

将 Ubuntu 相关 Dockerfile 重命名为标准格式：

```bash
cd docker
mv Dockerfile.ubuntu20 Dockerfile.ubuntu20-04
mv Dockerfile.ubuntu22 Dockerfile.ubuntu22-04  
mv Dockerfile.ubuntu24 Dockerfile.ubuntu24-04
```

### 3. 更新 docker-compose.yml 文件引用

修正所有对重命名 Dockerfile 的引用：

- Ubuntu 20.04 服务：dockerfile: docker/Dockerfile.ubuntu20-04
- Ubuntu 22.04 服务：dockerfile: docker/Dockerfile.ubuntu22-04
- Ubuntu 24.04 服务：dockerfile: docker/Dockerfile.ubuntu24-04
- interactive 服务：dockerfile: docker/Dockerfile.ubuntu22-04

### 4. 修正脚本参数规范

确保 install-git.sh 脚本包含所有必需参数：

- --help,-h : 显示帮助信息
- --debug : 启用调试模式  
- --network : 指定网络环境（如 'in-china'）
- --git-version : 指定软件版本

添加参数处理逻辑：

```bash
network=$(get_param '--network')
# 根据 network 参数确定是否使用中国源
inChina="false"
if [[ "$network" == "in-china" ]]; then
  inChina="true"
fi
```

### 5. 修正 Makefile 环境名处理

修复 test-all-single 命令的环境名处理逻辑：

- 问题：$(ENV)-test 导致环境名变成 ubuntu22-test-test
- 解决方案：改为 $(ENV) 直接使用

### 6. 更新相关文档

更新以下文件中的 Dockerfile 引用：

- docs/directory-structure.md
- .github/workflows/test.yml
- 其他相关文档

### 7. 验证修复结果

执行以下验证步骤：

构建脚本：make build-scripts

测试脚本参数：bash dist/install-git.sh --help

验证 Docker Compose 配置：docker-compose -f docker/docker-compose.yml config

测试文件存在性：ls -la docker/Dockerfile.*

## 模型差异性考虑

### 重要注意事项

1. **文件路径处理**
   - 始终使用完整的绝对路径
   - 确认工作目录正确

2. **命令执行顺序**  
   - 必须先重命名文件，再修改引用
   - 避免引用不存在的文件

3. **错误处理**
   - 检查文件是否存在
   - 验证语法正确性
   - 记录原始状态便于回滚

4. **批量操作**
   - 逐个修改文件，确保每步成功
   - 每个主要步骤后进行验证

### 常见问题排查

**问题1：文件不存在**

- 症状：mv 命令报错文件不存在
- 解决：先用 ls 确认文件名

**问题2：Docker Compose 配置错误**  

- 症状：docker-compose config 报错
- 解决：检查 Dockerfile 路径是否正确

**问题3：脚本参数不生效**

- 症状：--help 不显示新参数
- 解决：确保重新构建了脚本

**问题4：测试命令失败**

- 症状：make test-all-single 报错
- 解决：检查环境名是否正确

## 成功标准

完成所有操作后，以下验证应该全部通过：

- ls docker/Dockerfile.* 显示所有文件名符合规范
- bash dist/install-git.sh --help 显示包含 --network 参数
- docker-compose -f docker/docker-compose.yml config 无错误
- make test-all-single ENV=ubuntu22-test 能正常执行
- 所有文档引用的文件名已更新

## 执行时间估计

总计：10-16 分钟

- 指令加载：2-3 分钟
- 文件重命名：1-2 分钟
- 配置修改：3-5 分钟
- 文档更新：2-3 分钟
- 验证测试：2-3 分钟

## 最后检查清单

- [ ] 所有 Dockerfile 文件名符合规范
- [ ] docker-compose.yml 引用正确
- [ ] 脚本包含所有必需参数
- [ ] Makefile 逻辑正确
- [ ] 相关文档已更新
- [ ] 验证测试通过

---

**注意**：本指南基于 2025年8月6日 的仓库状态创建，如果仓库结构有重大变化，可能需要调整操作步骤。
