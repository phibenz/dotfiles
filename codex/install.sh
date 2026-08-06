#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_RULES_DIR="${HOME}/.codex/rules"
SOURCE_PROFILE="${SCRIPT_DIR}/dotfiles.config.toml"
TARGET_PROFILE="${HOME}/.codex/dotfiles.config.toml"
TARGET_ZSH_LOCAL="${HOME}/.zshrc.local"
LEGACY_CODEX_ALIAS="alias codex='npx @openai/codex@latest'"
CODEX_ALIAS="alias codex='npx @openai/codex@latest --profile dotfiles'"

mkdir -p "${TARGET_RULES_DIR}"

installed=0
skipped=0

while IFS= read -r -d '' rule_file; do
  rule_name="$(basename "${rule_file}")"
  target_link="${TARGET_RULES_DIR}/${rule_name}"

  if [[ -e "${target_link}" && ! -L "${target_link}" ]]; then
    echo "Skipping ${rule_name}: ${target_link} exists and is not a symlink"
    skipped=$((skipped + 1))
    continue
  fi

  ln -sfn "${rule_file}" "${target_link}"
  echo "Linked ${rule_name} -> ${target_link}"
  installed=$((installed + 1))
done < <(find "${SCRIPT_DIR}/rules" -name '*.rules' -type f -print0)

if [[ -e "${TARGET_PROFILE}" && ! -L "${TARGET_PROFILE}" ]]; then
  echo "Skipping Codex profile: ${TARGET_PROFILE} exists and is not a symlink"
  skipped=$((skipped + 1))
else
  ln -sfn "${SOURCE_PROFILE}" "${TARGET_PROFILE}"
  echo "Linked Codex profile -> ${TARGET_PROFILE}"
  installed=$((installed + 1))
fi

touch "${TARGET_ZSH_LOCAL}"
if grep -Fqx "${CODEX_ALIAS}" "${TARGET_ZSH_LOCAL}"; then
  echo "Codex alias already installed in ${TARGET_ZSH_LOCAL}"
elif grep -Fqx "${LEGACY_CODEX_ALIAS}" "${TARGET_ZSH_LOCAL}"; then
  temp_zsh_local="$(mktemp "${TARGET_ZSH_LOCAL}.tmp.XXXXXX")"
  awk -v old="${LEGACY_CODEX_ALIAS}" -v new="${CODEX_ALIAS}" \
    '$0 == old { print new; next } { print }' \
    "${TARGET_ZSH_LOCAL}" > "${temp_zsh_local}"
  cp "${temp_zsh_local}" "${TARGET_ZSH_LOCAL}"
  rm "${temp_zsh_local}"
  echo "Updated Codex alias in ${TARGET_ZSH_LOCAL}"
else
  {
    printf '\n# Codex CLI\n'
    printf '%s\n' "${CODEX_ALIAS}"
  } >> "${TARGET_ZSH_LOCAL}"
  echo "Installed Codex alias in ${TARGET_ZSH_LOCAL}"
fi

echo "Done. Linked ${installed} Codex item(s), skipped ${skipped}."
