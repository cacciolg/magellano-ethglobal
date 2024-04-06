#!/bin/bash -ex

SOLC_VERSION="${SOLC_VERSION:-0.8.21}"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

docker build \
  --build-arg="SOLC_VERSION=${SOLC_VERSION}" \
  -f Dockerfile.mythril \
  -t solc-analyzers/mythril \
  $SCRIPT_DIR
