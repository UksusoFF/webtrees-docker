#!/bin/bash
set -e

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

cd "${SCRIPT_DIR}"

bash "${SCRIPT_DIR}/_env.sh"

docker-compose --file docker-compose.yml --project-name "${APP_DOMAIN}" build --no-cache

cd "${SCRIPT_DIR}"

bash "${SCRIPT_DIR}/_run.sh"
