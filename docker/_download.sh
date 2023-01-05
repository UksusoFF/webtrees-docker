#!/bin/bash
set -e

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
SOURCE_ROOT=$(cd "${SCRIPT_DIR}/../" && pwd)
DATA_DIR="${SOURCE_ROOT}/data"
ENV_FILE="${SCRIPT_DIR}/.env"
CONF_FILE="${SOURCE_ROOT}/webtrees/data/config.ini.php"

source "${ENV_FILE}"

LATEST_RELEASE=$(wget -qO- --header 'Accept: application/json' https://github.com/fisharebest/webtrees/releases/latest)
LATEST_VERSION=$(echo $LATEST_RELEASE | sed -e 's/.*"tag_name":"\([^"]*\)".*/\1/')
echo "Downloading version: ${LATEST_VERSION}"
ARTIFACT_URL="https://github.com/fisharebest/webtrees/releases/download/${LATEST_VERSION}/webtrees-${LATEST_VERSION}.zip"

echo $ARTIFACT_URL

#wget "${ARTIFACT_URL}" -O "${DATA_DIR}/webtrees.zip"

echo ${DATA_DIR}/webtrees.zip

#unzip ${DATA_DIR}/webtrees.zip -d "${SOURCE_ROOT}"

if [ ! -f "${CONF_FILE}" ]; then
  cp "${SCRIPT_DIR}/config/config.ini.php" "${CONF_FILE}"

  # If sed error: https://stackoverflow.com/a/57766728
  sed -i -e "
  s/dbhost=.*/dbhost=\"${APP_NAME}_db\"/;
  s/dbuser=.*/dbuser=\"${APP_NAME}\"/;
  s/dbpass=.*/dbpass=\"${APP_NAME}\"/;
  s/dbname=.*/dbname=\"${APP_NAME}\"/;
  s/base_url=.*/base_url=\"https\:\/\/${APP_DOMAIN}\"/;
  " "${CONF_FILE}"
fi

docker exec -i "${APP_NAME}_db" mysql -uroot -p${APP_NAME} <<< "drop database IF EXISTS ${APP_NAME};"
docker exec -i "${APP_NAME}_db" mysql -uroot -p${APP_NAME} <<< "create database ${APP_NAME};"
docker exec -i "${APP_NAME}_db" mysql -uroot -p${APP_NAME} <<< "GRANT ALL PRIVILEGES ON *.* TO '${APP_NAME}'@'%';"
