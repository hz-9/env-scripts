# 测试指南

## 🚀 快速测试

```bash
# 构建脚本
make build-scripts

# 在所有环境运行所有测试
make test-all

# 在所有环境运行所有测试（中国网络）
make test-all NETWORK=in-china
```

## 🎯 精确测试

### 单环境测试

```bash
# 在指定环境运行所有测试
make test-all-single ENV=debian11-9-test
make test-all-single ENV=debian12-2-test
make test-all-single ENV=fedora41-test
make test-all-single ENV=redhat8-10-test
make test-all-single ENV=redhat9-6-test
make test-all-single ENV=ubuntu20-test
make test-all-single ENV=ubuntu22-test
make test-all-single ENV=ubuntu24-test

# 使用中国网络
make test-all-single ENV=debian11-9-test  NETWORK=in-china
make test-all-single ENV=debian12-2-test  NETWORK=in-china
make test-all-single ENV=fedora41-test    NETWORK=in-china
make test-all-single ENV=redhat8-10-test  NETWORK=in-china
make test-all-single ENV=redhat9-6-test   NETWORK=in-china
make test-all-single ENV=ubuntu20-test    NETWORK=in-china
make test-all-single ENV=ubuntu22-test    NETWORK=in-china
make test-all-single ENV=ubuntu24-test    NETWORK=in-china
```

### 单测试文件

```bash
# 在所有环境运行指定测试
make test-single-all TEST=tests/install-git/01-ok.sh
make test-single-all TEST=tests/install-git/02-install.sh NETWORK=in-china

# 在指定环境运行指定测试 (使用中国网络)
make test-single ENV=debian11-9-test  NETWORK=in-china TEST=tests/install-git/01-ok.sh
make test-single ENV=debian12-2-test  NETWORK=in-china TEST=tests/install-git/01-ok.sh
make test-single ENV=fedora41-test    NETWORK=in-china TEST=tests/install-git/01-ok.sh
make test-single ENV=redhat8-10-test  NETWORK=in-china TEST=tests/install-git/01-ok.sh
make test-single ENV=redhat9-6-test   NETWORK=in-china TEST=tests/install-git/01-ok.sh
make test-single ENV=ubuntu20-test    NETWORK=in-china TEST=tests/install-git/01-ok.sh
make test-single ENV=ubuntu22-test    NETWORK=in-china TEST=tests/install-git/01-ok.sh
make test-single ENV=ubuntu24-test    NETWORK=in-china TEST=tests/install-git/01-ok.sh

make test-single ENV=debian11-9-test  NETWORK=in-china TEST=tests/install-git/02-install.sh
make test-single ENV=debian12-2-test  NETWORK=in-china TEST=tests/install-git/02-install.sh
make test-single ENV=fedora41-test    NETWORK=in-china TEST=tests/install-git/02-install.sh
make test-single ENV=redhat8-10-test  NETWORK=in-china TEST=tests/install-git/02-install.sh
make test-single ENV=redhat9-6-test   NETWORK=in-china TEST=tests/install-git/02-install.sh
make test-single ENV=ubuntu20-test    NETWORK=in-china TEST=tests/install-git/02-install.sh
make test-single ENV=ubuntu22-test    NETWORK=in-china TEST=tests/install-git/02-install.sh
make test-single ENV=ubuntu24-test    NETWORK=in-china TEST=tests/install-git/02-install.sh
```

## 🔧 手动调试

### 构建环境

```bash
# 构建单个环境
docker-compose -f docker/docker-compose.yml build debian11-9-test
docker-compose -f docker/docker-compose.yml build debian12-2-test
docker-compose -f docker/docker-compose.yml build fedora41-test
docker-compose -f docker/docker-compose.yml build redhat8-10-test
docker-compose -f docker/docker-compose.yml build redhat9-6-test
docker-compose -f docker/docker-compose.yml build ubuntu20-test
docker-compose -f docker/docker-compose.yml build ubuntu22-test
docker-compose -f docker/docker-compose.yml build ubuntu24-test
```

### 脚本调试

```bash
# 快速调试脚本
bash ./tools/build.sh && docker-compose -f docker/docker-compose.yml run --rm ubuntu20-test   bash -c "bash dist/install-git.sh --help"
bash ./tools/build.sh && docker-compose -f docker/docker-compose.yml run --rm ubuntu20-test   bash -c "bash dist/install-git.sh --debug"
bash ./tools/build.sh && docker-compose -f docker/docker-compose.yml run --rm ubuntu20-test   bash -c "bash dist/install-git.sh --network=in-china --debug"

# 其他环境调试
bash ./tools/build.sh && docker-compose -f docker/docker-compose.yml run --rm fedora41-test   bash -c "bash dist/install-git.sh --network=in-china --debug"
bash ./tools/build.sh && docker-compose -f docker/docker-compose.yml run --rm debian12-2-test bash -c "bash dist/install-git.sh --network=in-china --debug"

bash ./tools/build.sh && docker-compose -f docker/docker-compose.yml run --rm redhat8-10-test   bash -c "bash dist/install-htop.sh --network=in-china --debug"
```

### 交互式调试

```bash
# 启动交互式环境
make interactive

# 在容器中手动测试
docker-compose -f docker/docker-compose.yml run --rm ubuntu20-test bash
```

## 🛠️ 常用操作

### 清理环境

```bash
make clean
```

### 获取帮助

```bash
make help
```

### 直接运行测试

```bash
# 直接运行特定测试
docker-compose -f docker/docker-compose.yml run --rm ubuntu20-test /app/tools/test-runner.sh --test tests/install-git/01-ok.sh
```
