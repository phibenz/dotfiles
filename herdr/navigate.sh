#!/usr/bin/env bash
# Forward distinct prefix-navigation keys to Neovim; focus Herdr panes elsewhere.

set -euo pipefail

direction="${1:?usage: navigate.sh <left|right>}"
herdr="${HERDR_BIN_PATH:-herdr}"
# Shell shortcuts provide the active pane; direct calls can use their own pane.
pane="${HERDR_ACTIVE_PANE_ID:-${HERDR_PANE_ID:?Herdr pane context is required}}"

case "${direction}" in
    left) key="ctrl+h"; nvim_key="f6" ;;
    right) key="ctrl+l"; nvim_key="f7" ;;
    *) echo "Unknown direction: ${direction}" >&2; exit 2 ;;
esac

# Preserve Vim navigation while giving Neovim a separate key for the prefix.
editor="$("${herdr}" pane process-info --pane "${pane}" | jq -r '
    [.result.process_info.foreground_processes[]?.name
     | ascii_downcase
     | select(test("^g?(view|l?n?vim?x?)(diff)?$"))][0] // ""
')"

if [[ "${editor}" == *nvim* ]]; then
    exec "${herdr}" pane send-keys "${pane}" "${nvim_key}"
elif [[ -n "${editor}" ]]; then
    exec "${herdr}" pane send-keys "${pane}" "${key}"
else
    exec "${herdr}" pane focus --direction "${direction}" --pane "${pane}"
fi
