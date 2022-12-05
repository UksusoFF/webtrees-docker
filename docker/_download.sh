#!/bin/bash
set -e

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
SOURCE_ROOT=$(cd "${SCRIPT_DIR}/../" && pwd)
DATA_DIR="${SOURCE_ROOT}/data"
ENV_FILE="${SCRIPT_DIR}/.env"
CONF_FILE="${SOURCE_ROOT}/webtrees/data/config.ini.php"

source "${ENV_FILE}"

LATEST_RELEASE=$(curl -L -s -H 'Accept: application/json' https://github.com/fisharebest/webtrees/releases/latest)
LATEST_VERSION=$(echo $LATEST_RELEASE | sed -e 's/.*"tag_name":"\([^"]*\)".*/\1/')
ARTIFACT_URL="https://github.com/fisharebest/webtrees/releases/download/$LATEST_VERSION/webtrees-$LATEST_VERSION.zip"

echo $ARTIFACT_URL

#curl $ARTIFACT_URL --location --remote-header-name --output ${DATA_DIR}/webtrees.zip

echo ${DATA_DIR}/webtrees.zip

#unzip ${DATA_DIR}/webtrees.zip -d "${SOURCE_ROOT}"

if [ ! -f "${CONF_FILE}" ]; then
  cp "${SCRIPT_DIR}/config/config.ini.php" "${CONF_FILE}"

  sed -i '' -e "
  s/dbhost=.*/dbhost=\"${APP_NAME}_db\"/;
  s/dbuser=.*/dbuser=\"${APP_NAME}\"/;
  s/dbpass=.*/dbpass=\"${APP_NAME}\"/;
  s/dbname=.*/dbname=\"${APP_NAME}\"/;
  s/base_url=.*/base_url=\"https\:\/\/${APP_DOMAIN}\"/;
  " "${CONF_FILE}"
fi
