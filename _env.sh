#!/bin/bash
set -e

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
SOURCE_ROOT=$(cd "${SCRIPT_DIR}/../" && pwd)
ENV_FILE="${SCRIPT_DIR}/.env"

if [ ! -f "${ENV_FILE}" ]; then
  APP_KEY=$(LC_ALL=C cat /dev/urandom | LC_ALL=C tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)

  cp "${SCRIPT_DIR}/.env.example" "${ENV_FILE}"

  sed -i '' -e "
  s/APP_KEY=.*/APP_KEY=${APP_KEY}/;
  " "${ENV_FILE}"
fi

source "${ENV_FILE}"

if [ ! -f "${SCRIPT_DIR}/private/ssl.key" ]; then
  echo "Not found certificate. Start install..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  brew install mkcert
  brew install nss
  mkcert -install
  mkcert -key-file="${SCRIPT_DIR}/private/ssl.key" -cert-file="${SCRIPT_DIR}/private/ssl.crt" "${APP_DOMAIN}"
  cat "$(mkcert -CAROOT)/rootCA.pem" > "${SCRIPT_DIR}/private/mkcertCA.crt"
fi

if grep -q "${APP_DOMAIN}" /etc/hosts; then
    echo "Domain ${APP_DOMAIN} already exist in /etc/hosts"
else
    echo "Adding ${APP_DOMAIN} domain to /etc/hosts..."
    echo "127.0.0.1 ${APP_DOMAIN}" | sudo tee -a /etc/hosts
fi
