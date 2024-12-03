#!/bin/bash
set -e

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
SOURCE_ROOT=$(cd "${SCRIPT_DIR}/../" && pwd)
MODULES_DIR="${SOURCE_ROOT}/app/modules_v4"
ENV_FILE="${SCRIPT_DIR}/.env"

source "${ENV_FILE}"

rm -rf "${MODULES_DIR}/faces" && git clone https://github.com/UksusoFF/webtrees-faces "${MODULES_DIR}/faces"
rm -rf "${MODULES_DIR}/reminder" && git clone https://github.com/UksusoFF/webtrees-reminder "${MODULES_DIR}/reminder"
rm -rf "${MODULES_DIR}/mdi" && git clone https://github.com/UksusoFF/webtrees-mdi "${MODULES_DIR}/mdi"
rm -rf "${MODULES_DIR}/photos" && git clone https://github.com/UksusoFF/webtrees-photos "${MODULES_DIR}/photos"
