# Testing Guide

## 🚀 Quick Test

``` bash
make test-all-single ENV=debian11-9
make test-all-single ENV=debian12-2
make test-all-single ENV=fedora41
make test-all-single ENV=redhat8-10
make test-all-single ENV=redhat9-6
make test-all-single ENV=ubuntu20
make test-all-single ENV=ubuntu22
make test-all-single ENV=ubuntu24

# Using China Network
make test-all-single ENV=debian11-9  NETWORK=in-china
make test-all-single ENV=debian12-2  NETWORK=in-china
make test-all-single ENV=fedora41    NETWORK=in-china
make test-all-single ENV=redhat8-10  NETWORK=in-china
make test-all-single ENV=redhat9-6   NETWORK=in-china
make test-all-single ENV=ubuntu20    NETWORK=in-china
make test-all-single ENV=ubuntu22    NETWORK=in-china
make test-all-single ENV=ubuntu24    NETWORK=in-chinaash
# Build scripts
make build-scripts

# Run all tests in all environments
make test-all

# Run all tests in all environments (China network)
make test-all NETWORK=in-china
```

## 🎯 Precise Test

### Single Environment Test

```bash
# Run all tests in the specified environment
make test-all-single ENV=debian11-9-test
make test-all-single ENV=debian12-2-test
make test-all-single ENV=fedora41-test
make test-all-single ENV=redhat8-10-test
make test-all-single ENV=redhat9-6-test
make test-all-single ENV=ubuntu20-test
make test-all-single ENV=ubuntu22-test
make test-all-single ENV=ubuntu24-test

# Use China network
make test-all-single ENV=debian11-9-test  NETWORK=in-china
make test-all-single ENV=debian12-2-test  NETWORK=in-china
make test-all-single ENV=fedora41-test    NETWORK=in-china
make test-all-single ENV=redhat8-10-test  NETWORK=in-china
make test-all-single ENV=redhat9-6-test   NETWORK=in-china
make test-all-single ENV=ubuntu20-test    NETWORK=in-china
make test-all-single ENV=ubuntu22-test    NETWORK=in-china
make test-all-single ENV=ubuntu24-test    NETWORK=in-china
```

### Single Test File

```bash
# Run the specified test in all environments
make test-single-all TEST=tests/install-git/01-ok.sh
make test-single-all TEST=tests/install-git/02-install.sh NETWORK=in-china

# Run the specified test in the specified environment (using China network)
make test-single ENV=debian11-9  NETWORK=in-china TEST=tests/install-git/01-ok.sh
make test-single ENV=debian12-2  NETWORK=in-china TEST=tests/install-git/01-ok.sh
make test-single ENV=fedora41    NETWORK=in-china TEST=tests/install-git/01-ok.sh
make test-single ENV=redhat8-10  NETWORK=in-china TEST=tests/install-git/01-ok.sh
make test-single ENV=redhat9-6   NETWORK=in-china TEST=tests/install-git/01-ok.sh
make test-single ENV=ubuntu20    NETWORK=in-china TEST=tests/install-git/01-ok.sh
make test-single ENV=ubuntu22    NETWORK=in-china TEST=tests/install-git/01-ok.sh
make test-single ENV=ubuntu24    NETWORK=in-china TEST=tests/install-git/01-ok.sh

make test-single ENV=debian11-9  NETWORK=in-china TEST=tests/install-git/02-install.sh
make test-single ENV=debian12-2  NETWORK=in-china TEST=tests/install-git/02-install.sh
make test-single ENV=fedora41    NETWORK=in-china TEST=tests/install-git/02-install.sh
make test-single ENV=redhat8-10  NETWORK=in-china TEST=tests/install-git/02-install.sh
make test-single ENV=redhat9-6   NETWORK=in-china TEST=tests/install-git/02-install.sh
make test-single ENV=ubuntu20    NETWORK=in-china TEST=tests/install-git/02-install.sh
make test-single ENV=ubuntu22    NETWORK=in-china TEST=tests/install-git/02-install.sh
make test-single ENV=ubuntu24    NETWORK=in-china TEST=tests/install-git/02-install.sh
```

## 🔧 Manual Debugging

### Build Environment

```bash
# Build a single environment
docker-compose -f docker/docker-compose.yml build debian11-9-test
docker-compose -f docker/docker-compose.yml build debian12-2-test
docker-compose -f docker/docker-compose.yml build fedora41-test
docker-compose -f docker/docker-compose.yml build redhat8-10-test
docker-compose -f docker/docker-compose.yml build redhat9-6-test
docker-compose -f docker/docker-compose.yml build ubuntu20-test
docker-compose -f docker/docker-compose.yml build ubuntu22
docker-compose -f docker/docker-compose.yml build ubuntu24-test
```

### Script Debugging

```bash
# Quickly debug scripts
bash ./tools/build.sh && docker-compose -f docker/docker-compose.yml run --rm ubuntu20-test   bash -c "bash dist/install-git.sh --help"
bash ./tools/build.sh && docker-compose -f docker/docker-compose.yml run --rm ubuntu20-test   bash -c "bash dist/install-git.sh --debug"
bash ./tools/build.sh && docker-compose -f docker/docker-compose.yml run --rm ubuntu20-test   bash -c "bash dist/install-git.sh --network=in-china --debug"

# Debug in other environments
bash ./tools/build.sh && docker-compose -f docker/docker-compose.yml run --rm fedora41-test   bash -c "bash dist/install-git.sh --network=in-china --debug"
bash ./tools/build.sh && docker-compose -f docker/docker-compose.yml run --rm debian12-2-test bash -c "bash dist/install-git.sh --network=in-china --debug"

bash ./tools/build.sh && docker-compose -f docker/docker-compose.yml run --rm redhat8-10-test   bash -c "bash dist/install-htop.sh --network=in-china --debug"
```

### Interactive Debugging

```bash
# Start interactive environment
make interactive

# Manually test in the container
docker-compose -f docker/docker-compose.yml run --rm ubuntu20-test bash
```

## 🛠️ Common Operations

### Clean Environment

```bash
make clean
```

### Get Help

```bash
make help
```

### Run Tests Directly

```bash
# Run a specific test directly
docker-compose -f docker/docker-compose.yml run --rm ubuntu20-test /app/tools/test-runner.sh --test tests/install-git/01-ok.sh
```
