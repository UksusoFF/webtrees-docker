#!/bin/bash
set -e

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

cd "${SCRIPT_DIR}"

source "${SCRIPT_DIR}/.env"

docker-compose --file docker-compose.yml --project-name "${APP_DOMAIN}" up -d

cd "${SCRIPT_DIR}"

open "https://${APP_DOMAIN}"

echo "maildev available at: http://127.0.0.1:9080/"

docker exec --user webtrees -it "$(docker ps -f name=${APP_DOMAIN}_web -q)" /bin/bash
