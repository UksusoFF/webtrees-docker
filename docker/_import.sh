#!/bin/bash
set -e

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
SOURCE_ROOT=$(cd "${SCRIPT_DIR}/../" && pwd)
DATA_DIR="${SOURCE_ROOT}/data"
ENV_FILE="${SCRIPT_DIR}/.env"
PASSWORD="\$2y\$10\$GQdv24zxX1eAMK2pp5T33.YMeRLlZoS0pf/oE01u51exC4mZbGBi." # Encoded `webtrees`.

source "${ENV_FILE}"

docker exec -i "${APP_NAME}_db" mysql -uroot -p${APP_NAME} <<< "drop database IF EXISTS ${APP_NAME};"
docker exec -i "${APP_NAME}_db" mysql -uroot -p${APP_NAME} <<< "create database ${APP_NAME};"
docker exec -i "${APP_NAME}_db" mysql -uroot -p${APP_NAME} <<< "GRANT ALL PRIVILEGES ON *.* TO '${APP_NAME}'@'%';"
docker exec -i "${APP_NAME}_db" mysql -u${APP_NAME} -p${APP_NAME} ${APP_NAME} < ${DATA_DIR}/webtrees.backup.sql
docker exec -i "${APP_NAME}_db" mysql -u${APP_NAME} -p${APP_NAME} ${APP_NAME} <<< "UPDATE wt_user SET password = "\"$PASSWORD\"";"
