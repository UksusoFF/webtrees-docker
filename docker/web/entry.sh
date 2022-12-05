#!/bin/bash
set -e

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

source "${SCRIPT_DIR}/.env"

db_ready() {
  curl "http://${APP_NAME}_db:5432/" 2>&1 | grep '52'
}

until db_ready; do
  >&2 echo "Waiting for database to become available..."
  sleep 1
done
>&2 echo "database is available"

service php7.4-fpm start
service nginx start

echo "Sleeping..."
# Spin until we receive a SIGTERM (e.g. from `docker stop`)
trap 'exit 143' SIGTERM # exit = 128 + 15 (SIGTERM)
tail -f /dev/null & wait ${!}
