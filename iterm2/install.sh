#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="${SCRIPT_DIR}/config.json"
PREFERENCES_DOMAIN="com.googlecode.iterm2"
BACKUP_DIR="${HOME}/Library/Application Support/iTerm2/DotfilesBackups"
BACKUP_FILE="${BACKUP_DIR}/preferences-before-dotfiles.plist"

if [[ "$(uname -s)" != "Darwin" ]]; then
    echo "Skipping iTerm2 configuration: macOS is required."
    exit 0
fi

if [[ ! -d /Applications/iTerm.app && ! -d "${HOME}/Applications/iTerm.app" ]]; then
    echo "ERROR: iTerm2 is not installed." >&2
    exit 1
fi

if ! plutil -convert xml1 -o /dev/null "${CONFIG_FILE}"; then
    echo "ERROR: Invalid iTerm2 configuration: ${CONFIG_FILE}" >&2
    exit 1
fi

working_dir="$(mktemp -d)"
trap 'rm -rf "${working_dir}"' EXIT
preferences_file="${working_dir}/preferences.plist"

if ! defaults export "${PREFERENCES_DOMAIN}" "${preferences_file}" >/dev/null; then
    echo "ERROR: iTerm2 preferences are unavailable. Open iTerm2 once, then retry." >&2
    exit 1
fi

default_profile_guid="$(plutil -extract 'Default Bookmark Guid' raw -o - "${preferences_file}")"
profile_count="$(plutil -extract 'New Bookmarks' raw -o - "${preferences_file}")"
default_profile_index=""

for ((index = 0; index < profile_count; index++)); do
    profile_guid="$(plutil -extract "New Bookmarks.${index}.Guid" raw -o - "${preferences_file}")"
    if [[ "${profile_guid}" == "${default_profile_guid}" ]]; then
        default_profile_index="${index}"
        break
    fi
done

if [[ -z "${default_profile_index}" ]]; then
    echo "ERROR: Could not find the default iTerm2 profile." >&2
    exit 1
fi

set_string() {
    local key_path="$1"
    local value="$2"

    if plutil -type "${key_path}" "${preferences_file}" >/dev/null 2>&1; then
        plutil -replace "${key_path}" -string "${value}" "${preferences_file}"
    else
        plutil -insert "${key_path}" -string "${value}" "${preferences_file}"
    fi
}

set_bool() {
    local key_path="$1"
    local value="$2"

    if plutil -type "${key_path}" "${preferences_file}" >/dev/null 2>&1; then
        plutil -replace "${key_path}" -bool "${value}" "${preferences_file}"
    else
        plutil -insert "${key_path}" -bool "${value}" "${preferences_file}"
    fi
}

set_json() {
    local key_path="$1"
    local value="$2"

    if plutil -type "${key_path}" "${preferences_file}" >/dev/null 2>&1; then
        plutil -replace "${key_path}" -json "${value}" "${preferences_file}"
    else
        plutil -insert "${key_path}" -json "${value}" "${preferences_file}"
    fi
}

press_and_hold="$(plutil -extract 'Application.ApplePressAndHoldEnabled' raw -o - "${CONFIG_FILE}")"
normal_font="$(plutil -extract 'Profile.Normal Font' raw -o - "${CONFIG_FILE}")"
terminal_type="$(plutil -extract 'Profile.Terminal Type' raw -o - "${CONFIG_FILE}")"

set_bool 'ApplePressAndHoldEnabled' "${press_and_hold}"
set_string "New Bookmarks.${default_profile_index}.Normal Font" "${normal_font}"
set_string "New Bookmarks.${default_profile_index}.Terminal Type" "${terminal_type}"

if ! plutil -type 'GlobalKeyMap' "${preferences_file}" >/dev/null 2>&1; then
    plutil -insert 'GlobalKeyMap' -dictionary "${preferences_file}"
fi

key_mapping_count="$(plutil -extract 'KeyMappings' raw -o - "${CONFIG_FILE}")"
for ((index = 0; index < key_mapping_count; index++)); do
    key="$(plutil -extract "KeyMappings.${index}.Key" raw -o - "${CONFIG_FILE}")"
    value="$(plutil -extract "KeyMappings.${index}.Value" json -o - "${CONFIG_FILE}")"
    set_json "GlobalKeyMap.${key}" "${value}"
done

removed_key_mapping_count="$(plutil -extract 'RemovedKeyMappings' raw -o - "${CONFIG_FILE}")"
for ((index = 0; index < removed_key_mapping_count; index++)); do
    key="$(plutil -extract "RemovedKeyMappings.${index}" raw -o - "${CONFIG_FILE}")"
    plutil -remove "GlobalKeyMap.${key}" "${preferences_file}" 2>/dev/null || true
done

mkdir -p "${BACKUP_DIR}"
if [[ ! -f "${BACKUP_FILE}" ]]; then
    defaults export "${PREFERENCES_DOMAIN}" "${BACKUP_FILE}" >/dev/null
fi

defaults import "${PREFERENCES_DOMAIN}" "${preferences_file}"

echo "iTerm2 configuration installed. Restart iTerm2 to load the changes."
