#!/bin/bash

# Generate documentation pages: build the VuePress docs site using @hz-9/docs-build.
#
# This script:
#   1. Cleans any previously generated files
#   2. Runs @hz-9/docs-build with the configuration file
#
# Reference: lint-nx/scripts/generate-pages.sh

set -e

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

echo ""
echo "=== 0. Preparation phase ==="

echo ""
echo "=== 1. Clearing history files ==="
# env-scripts has no packages to sync; only clean the generated VuePress src
rm -rf "$ROOT_DIR/docs/.vuepress/src"

echo ""
echo "=== 2. Building VuePress docs with docs-build ==="
npx @hz-9/docs-build -c "$ROOT_DIR/docs-build.config.json"

echo ""
echo "=== Done. VuePress project generated at docs/.vuepress/src ==="
