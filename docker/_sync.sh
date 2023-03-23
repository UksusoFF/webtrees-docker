#!/bin/bash
set -e

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
SOURCE_ROOT=$(cd "${SCRIPT_DIR}/../" && pwd)
DATA_DIR="${SOURCE_ROOT}/data"
ENV_FILE="${SCRIPT_DIR}/.env"
CONF_FILE="${SOURCE_ROOT}/webtrees/data/config.ini.php"

source "${ENV_FILE}"

DB_NAME="${APP_NAME}"
DB_USER="${APP_NAME}"
DB_PASS="${APP_NAME}"
DB_HOST="${APP_NAME}_db"

ARC_FOLDER_NAME="${WEB_DAV_PREFIX}_$(date '+%F')_${WEB_DAV_SUFFIX}"

echo ${WEB_DAV_USER}:${WEB_DAV_PASS} ${WEB_DAV_URL}/${ARC_FOLDER_NAME}/${WEB_DAV_BASES}

curl --digest --user ${WEB_DAV_USER}:${WEB_DAV_PASS} ${WEB_DAV_URL}/${ARC_FOLDER_NAME}/${WEB_DAV_BASES} --output ${DATA_DIR}/${WEB_DAV_BASES}
curl --digest --user ${WEB_DAV_USER}:${WEB_DAV_PASS} ${WEB_DAV_URL}/${ARC_FOLDER_NAME}/${WEB_DAV_FILES} --output ${DATA_DIR}/${WEB_DAV_FILES}

gunzip -c ${DATA_DIR}/${WEB_DAV_BASES} > ${DATA_DIR}/db.sql
docker exec -i "${DB_HOST}" mysql -uroot -p${DB_PASS} <<< "drop database ${DB_NAME};"
docker exec -i "${DB_HOST}" mysql -uroot -p${DB_PASS} <<< "create database ${DB_NAME};"
docker exec -i "${DB_HOST}" mysql -uroot -p${DB_PASS} <<< "GRANT ALL PRIVILEGES ON *.* TO '${DB_USER}'@'%';"
docker exec -i "${DB_HOST}" mysql -u${DB_USER} -p${DB_PASS} ${DB_NAME} < ${DATA_DIR}/db.sql

tar -zxvf ${DATA_DIR}/${WEB_DAV_FILES} -C "${SOURCE_ROOT}/webtrees"

cp "${SCRIPT_DIR}/config/config.ini.php" "${CONF_FILE}"

sed -i "
s/dbname=.*/dbname=\"${DB_NAME}\"/;
s/dbuser=.*/dbuser=\"${DB_USER}\"/;
s/dbpass=.*/dbpass=\"${DB_PASS}\"/;
s/dbhost=.*/dbhost=\"${DB_HOST}\"/;
" "${CONF_FILE}"
