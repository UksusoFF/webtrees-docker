#!/bin/bash
set -e

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

cd "${SCRIPT_DIR}"

while read -r CONTAINER; do
  docker kill "$CONTAINER"
done < <(docker ps -q)
docker system prune -a --force
docker-compose down --remove-orphans
rm -rf "${SCRIPT_DIR}"/data/db/*
rm -rf "${SCRIPT_DIR}"/data/logs/*
