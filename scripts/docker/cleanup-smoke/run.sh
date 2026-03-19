#!/usr/bin/env bash
set -euo pipefail

cd /repo

export SYNTHIOS_STATE_DIR="/tmp/synthios-test"
export SYNTHIOS_CONFIG_PATH="${SYNTHIOS_STATE_DIR}/synthios.json"

echo "==> Build"
pnpm build

echo "==> Seed state"
mkdir -p "${SYNTHIOS_STATE_DIR}/credentials"
mkdir -p "${SYNTHIOS_STATE_DIR}/agents/main/sessions"
echo '{}' >"${SYNTHIOS_CONFIG_PATH}"
echo 'creds' >"${SYNTHIOS_STATE_DIR}/credentials/marker.txt"
echo 'session' >"${SYNTHIOS_STATE_DIR}/agents/main/sessions/sessions.json"

echo "==> Reset (config+creds+sessions)"
pnpm synthios reset --scope config+creds+sessions --yes --non-interactive

test ! -f "${SYNTHIOS_CONFIG_PATH}"
test ! -d "${SYNTHIOS_STATE_DIR}/credentials"
test ! -d "${SYNTHIOS_STATE_DIR}/agents/main/sessions"

echo "==> Recreate minimal config"
mkdir -p "${SYNTHIOS_STATE_DIR}/credentials"
echo '{}' >"${SYNTHIOS_CONFIG_PATH}"

echo "==> Uninstall (state only)"
pnpm synthios uninstall --state --yes --non-interactive

test ! -d "${SYNTHIOS_STATE_DIR}"

echo "OK"
