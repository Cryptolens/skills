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
  "license-feature-gates"
  "license-subscriptions"
  "license-key-generation"
  "license-payment-automation"
)

relative_plugin_path() {
  local plugin_source_path="${MARKETPLACE_DEST}/plugins/devolens"

  if [[ "${plugin_source_path}" == "${HOME}/"* ]]; then
    plugin_source_path="./${plugin_source_path#"${HOME}/"}"
  fi

  printf '%s\n' "${plugin_source_path}"
}

write_devolens_marketplace_file() {
  local plugin_source_path="$1"

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
}

register_devolens_plugin() {
  local plugin_source_path
  plugin_source_path="$(relative_plugin_path)"

  mkdir -p "$(dirname -- "${USER_MARKETPLACE_FILE}")"

  if [[ ! -e "${USER_MARKETPLACE_FILE}" ]]; then
    write_devolens_marketplace_file "${plugin_source_path}"
    echo "Created Codex marketplace entry:"
    echo "  ${USER_MARKETPLACE_FILE}"
    return
  fi

  if ! command -v python3 >/dev/null 2>&1; then
    echo "User marketplace file already exists and python3 is unavailable, so it was left unchanged:"
    echo "  ${USER_MARKETPLACE_FILE}"
    echo
    echo "Add this Devolens plugin source manually if it does not appear in Codex Plugin Directory:"
    echo "  ${plugin_source_path}"
    return
  fi

  if ! python3 - "${USER_MARKETPLACE_FILE}" "${plugin_source_path}" <<'PY'
import json
import os
import shutil
import sys
import tempfile

marketplace_path, plugin_source_path = sys.argv[1], sys.argv[2]

entry = {
    "name": "devolens",
    "source": {
        "source": "local",
        "path": plugin_source_path,
    },
    "policy": {
        "installation": "AVAILABLE",
        "authentication": "ON_INSTALL",
    },
    "category": "Developer Tools",
}

with open(marketplace_path, "r", encoding="utf-8") as f:
    marketplace = json.load(f)

if not isinstance(marketplace, dict):
    raise SystemExit("marketplace.json must contain a JSON object")

plugins = marketplace.setdefault("plugins", [])
if not isinstance(plugins, list):
    raise SystemExit("marketplace.json field 'plugins' must be a list")

for plugin in plugins:
    if isinstance(plugin, dict) and plugin.get("name") == "devolens":
        print("Devolens plugin entry already exists in:")
        print(f"  {marketplace_path}")
        raise SystemExit(0)

plugins.append(entry)

backup_path = f"{marketplace_path}.bak"
counter = 1
while os.path.exists(backup_path):
    counter += 1
    backup_path = f"{marketplace_path}.bak.{counter}"

shutil.copy2(marketplace_path, backup_path)

directory = os.path.dirname(marketplace_path) or "."
fd, temp_path = tempfile.mkstemp(
    prefix=f"{os.path.basename(marketplace_path)}.",
    suffix=".tmp",
    dir=directory,
)

with os.fdopen(fd, "w", encoding="utf-8") as f:
    json.dump(marketplace, f, indent=2)
    f.write("\n")

os.replace(temp_path, marketplace_path)

print("Registered Devolens in existing Codex marketplace file:")
print(f"  {marketplace_path}")
print("Backup:")
print(f"  {backup_path}")
PY
  then
    echo "Could not update existing user marketplace file; leaving it unchanged:"
    echo "  ${USER_MARKETPLACE_FILE}"
    echo
    echo "Devolens marketplace file:"
    echo "  ${MARKETPLACE_DEST}/.agents/plugins/marketplace.json"
  fi
}

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

register_devolens_plugin

echo
echo "Install complete."
echo "Restart Codex, open Plugin Directory, then install Devolens Licensing."
