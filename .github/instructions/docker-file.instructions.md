---
applyTo: "docker/Dockerfile.*"
---

本仓库，对于单元测试和集成测试的 Docker 环境，已经进行了镜像系统的规定。需要支持以下操作系统级版本：

| 操作系统 | 版本                |
| -------- | ------------------- |
| Debian   | 11.9, 12.2          |
| RedHat   | 8.10, 9.6           |
| Ubuntu   | 20.04, 22.04, 24.04 |
| Fedora   | 41                  |

`Debian 11.9` 版本的操作系统，`Dockerfile` 文件名为 `Dockerfile.debian11-9`，而 `Ubuntu 20.04` 版本的操作系统，`Dockerfile` 文件名为 `Dockerfile.ubuntu20-04`。
