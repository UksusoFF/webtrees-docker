#!/bin/bash
set -e

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

cd "${SCRIPT_DIR}"

while read -r CONTAINER; do
  docker stop "$CONTAINER"
done < <(docker ps -q)
