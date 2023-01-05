#!/bin/bash
set -e

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

source "${SCRIPT_DIR}/.env"

while ! mysqladmin ping -h "${APP_NAME}_db" --silent; do
  >&2 echo "Waiting for database to become available..."
  sleep 5
done
>&2 echo "database is available"

service php7.4-fpm start
service nginx start

echo "Sleeping..."
# Spin until we receive a SIGTERM (e.g. from `docker stop`)
trap 'exit 143' SIGTERM # exit = 128 + 15 (SIGTERM)
tail -f /dev/null & wait ${!}
