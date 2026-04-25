#!/usr/bin/env bash

set -euo pipefail

QWEN_CODER_MODEL="qwen3-coder:30b"

echo "Installing Ollama..."

if ! command -v curl >/dev/null 2>&1; then
    echo "ERROR: curl is required to install Ollama."
    exit 1
fi

if ! command -v ollama >/dev/null 2>&1; then
    curl -fsSL https://ollama.com/install.sh | sh
else
    echo "Ollama already installed."
fi

if ! command -v ollama >/dev/null 2>&1; then
    echo "ERROR: Ollama is not available after installation."
    exit 1
fi

echo "Downloading ${QWEN_CODER_MODEL}..."
ollama pull "${QWEN_CODER_MODEL}"

echo "Done."
