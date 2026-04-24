#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd -- "${SCRIPT_DIR}/.." && pwd)"

CODEX_HOME="${CODEX_HOME:-${HOME}/.codex}"
MARKETPLACE_NAME="devolens"
MARKETPLACE_PARENT="${CODEX_HOME}/marketplaces"
MARKETPLACE_DEST="${DEVOLENS_CODEX_MARKETPLACE_DIR:-${MARKETPLACE_PARENT}/${MARKETPLACE_NAME}}"
USER_MARKETPLACE_FILE="${DEVOLENS_USER_MARKETPLACE_FILE:-${HOME}/.agents/plugins/marketplace.json}"

require_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Missing required command: $1" >&2
    exit 1
  fi
}

require_command cp
require_command dirname
require_command mkdir
require_command mktemp
require_command mv

SOURCE_MARKETPLACE="${REPO_ROOT}/.agents/plugins/marketplace.json"
SOURCE_PLUGIN="${REPO_ROOT}/plugins/devolens"
SOURCE_SKILLS="${REPO_ROOT}/skills"
SKILLS=(
  "cryptolens-sdk-common"
  "cryptolens-dotnet"
  "cryptolens-java"
  "cryptolens-python"
  "license-offline"
  "license-key-verification"
  "license-floating"
  "license-trials"
)

if [[ ! -f "${SOURCE_MARKETPLACE}" ]]; then
  echo "Missing Codex marketplace metadata: ${SOURCE_MARKETPLACE}" >&2
  exit 1
fi

if [[ ! -f "${SOURCE_PLUGIN}/.codex-plugin/plugin.json" ]]; then
  echo "Missing Codex plugin manifest: ${SOURCE_PLUGIN}/.codex-plugin/plugin.json" >&2
  exit 1
fi

for skill in "${SKILLS[@]}"; do
  if [[ ! -f "${SOURCE_SKILLS}/${skill}/SKILL.md" ]]; then
    echo "Missing source skill: ${SOURCE_SKILLS}/${skill}/SKILL.md" >&2
    exit 1
  fi
done

DEST_PARENT="$(dirname -- "${MARKETPLACE_DEST}")"
mkdir -p "${DEST_PARENT}"

if [[ -e "${MARKETPLACE_DEST}" ]]; then
  echo "Devolens Codex marketplace already exists; leaving it unchanged:"
  echo "  ${MARKETPLACE_DEST}"
else
  STAGE_PARENT="$(mktemp -d "${DEST_PARENT}/.devolens-install.XXXXXX")"
  STAGED_MARKETPLACE="${STAGE_PARENT}/${MARKETPLACE_NAME}"

  mkdir -p "${STAGED_MARKETPLACE}/.agents/plugins"
  mkdir -p "${STAGED_MARKETPLACE}/plugins"
  cp "${SOURCE_MARKETPLACE}" "${STAGED_MARKETPLACE}/.agents/plugins/marketplace.json"
  cp -R "${SOURCE_PLUGIN}" "${STAGED_MARKETPLACE}/plugins/devolens"
  mkdir -p "${STAGED_MARKETPLACE}/plugins/devolens/skills"

  for skill in "${SKILLS[@]}"; do
    cp -R "${SOURCE_SKILLS}/${skill}" "${STAGED_MARKETPLACE}/plugins/devolens/skills/${skill}"
  done

  echo "Installing Devolens Codex marketplace:"
  echo "  ${MARKETPLACE_DEST}"

  if ! mv "${STAGED_MARKETPLACE}" "${MARKETPLACE_DEST}"; then
    echo "Failed to install Devolens Codex marketplace." >&2
    echo "Staged files remain at: ${STAGE_PARENT}" >&2
    exit 1
  fi
fi

mkdir -p "$(dirname -- "${USER_MARKETPLACE_FILE}")"

if [[ -e "${USER_MARKETPLACE_FILE}" ]]; then
  echo "User marketplace file already exists; leaving it unchanged:"
  echo "  ${USER_MARKETPLACE_FILE}"
  echo
  echo "Devolens marketplace file:"
  echo "  ${MARKETPLACE_DEST}/.agents/plugins/marketplace.json"
else
  plugin_source_path="${MARKETPLACE_DEST}/plugins/devolens"
  if [[ "${plugin_source_path}" == "${HOME}/"* ]]; then
    plugin_source_path="./${plugin_source_path#"${HOME}/"}"
  fi

  cat >"${USER_MARKETPLACE_FILE}" <<JSON
{
  "name": "devolens",
  "interface": {
    "displayName": "Devolens"
  },
  "plugins": [
    {
      "name": "devolens",
      "source": {
        "source": "local",
        "path": "${plugin_source_path}"
      },
      "policy": {
        "installation": "AVAILABLE",
        "authentication": "ON_INSTALL"
      },
      "category": "Developer Tools"
    }
  ]
}
JSON
  echo "Created Codex marketplace entry:"
  echo "  ${USER_MARKETPLACE_FILE}"
fi

echo
echo "Install complete."
echo "Restart Codex, open Plugin Directory, then install Devolens Licensing."
