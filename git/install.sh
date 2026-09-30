#!/usr/bin/env bash

# Configure missing global Git identity and HTTPS credential settings.
set -euo pipefail

if ! command -v git >/dev/null 2>&1; then
    echo "ERROR: Git is not installed." >&2
    exit 1
fi

configure_identity() {
    local key="$1" prompt="$2" value

    if git config --global --get "$key" >/dev/null; then
        printf '%s is already set; keeping it.\n' "$key"
        return
    fi

    while true; do
        if ! IFS= read -r -p "$prompt" value; then
            printf '\nERROR: No value entered for %s.\n' "$key" >&2
            return 1
        fi
        if [[ "$value" =~ [^[:space:]] ]]; then
            break
        fi
        echo "Please enter a non-empty value." >&2
    done

    git config --global "$key" "$value"
}

configure_identity user.name 'Git user name: '
configure_identity user.email 'Git email: '

if git config --global --get-all credential.helper >/dev/null; then
    echo "credential.helper is already set; keeping it."
else
    git config --global credential.helper 'cache --timeout=3600'
fi

echo "Global Git configuration is ready."
