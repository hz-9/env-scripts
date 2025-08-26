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

每个 `Dockerfile` 文件都基于相应的官方基础镜像，并安装了必要的软件包和依赖项，以确保测试环境的一致性和可靠性。

除此之外，还会存在一个已经安装了 `Docker CE` 和 `Docker Compose` 的基础镜像，`Dockerfile` 文件名为 `Dockerfile.docker`。该镜像用于在测试环境中运行 Docker 容器。
