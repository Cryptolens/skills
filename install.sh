#!/usr/bin/env bash
set -euo pipefail

REPO_SLUG="${DEVOLENS_SKILLS_REPO:-Cryptolens/skills}"
REPO_REF="${DEVOLENS_SKILLS_REF:-main}"
SOURCE_DIR="${DEVOLENS_SKILLS_SOURCE_DIR:-}"

if [[ -n "${SOURCE_DIR}" ]]; then
  exec bash "${SOURCE_DIR%/}/scripts/install_codex_marketplace.sh"
fi

require_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Missing required command: $1" >&2
    exit 1
  fi
}

require_command curl
require_command find
require_command mktemp
require_command tar

TMP_DIR="$(mktemp -d)"

cleanup() {
  rm -rf "${TMP_DIR}"
}

trap cleanup EXIT

ARCHIVE_URL="https://github.com/${REPO_SLUG}/archive/refs/heads/${REPO_REF}.tar.gz"
ARCHIVE_PATH="${TMP_DIR}/devolens-skills.tar.gz"

echo "Downloading Devolens Codex marketplace:"
echo "  ${ARCHIVE_URL}"

curl -fsSL "${ARCHIVE_URL}" -o "${ARCHIVE_PATH}"
tar -xzf "${ARCHIVE_PATH}" -C "${TMP_DIR}"

mapfile -t extracted_dirs < <(find "${TMP_DIR}" -mindepth 1 -maxdepth 1 -type d)

if [[ "${#extracted_dirs[@]}" -ne 1 ]]; then
  echo "Failed to uniquely identify the extracted Devolens bundle." >&2
  exit 1
fi

INSTALLER_PATH="${extracted_dirs[0]}/scripts/install_codex_marketplace.sh"

if [[ ! -f "${INSTALLER_PATH}" ]]; then
  echo "Failed to find Codex marketplace installer in downloaded archive." >&2
  exit 1
fi

echo "Launching Devolens Codex marketplace installer..."
exec bash "${INSTALLER_PATH}"
