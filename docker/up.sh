#!/bin/bash
set -e

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

cd "${SCRIPT_DIR}"

source "${SCRIPT_DIR}/.env"

docker compose --file docker-compose.yml --project-name "${APP_NAME}" up -d

cd "${SCRIPT_DIR}"

#open "https://${APP_DOMAIN}"

echo "maildev available at: http://127.0.0.1:9080/"

if [ -z $(which winpty) ]; then
  docker exec --user "${APP_NAME}" -it "$(docker ps -f name=${APP_NAME}_backend -q)" /bin/bash
else
  winpty docker exec --user "${APP_NAME}" -it "$(docker ps -f name=${APP_NAME}_backend -q)" bash
fi
