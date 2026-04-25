QWEN_OLLAMA_MODEL="${QWEN_OLLAMA_MODEL:-qwen3-coder:30b}"

function _strip_terminal_sequences() {
  perl -pe 's/\e\[[0-9;?]*[ -\/]*[@-~]//g; s/\e[@-Z\\-_]//g; s/[\x00-\x08\x0B\x0C\x0E-\x1F\x7F]//g'
}

function _ollama_run_prompt() {
  command -v ollama >/dev/null 2>&1 || {
    echo "ollama not found" >&2
    return 127
  }

  local model_name="$1"
  local prompt="$2"
  if [[ -n "$prompt" ]]; then
    local output exit_code
    output=$(TERM=dumb ollama run --hidethinking --nowordwrap "${model_name}" "$prompt")
    exit_code=$?
    (( exit_code == 0 )) || return $exit_code
    printf '%s' "$output" | _strip_terminal_sequences
  else
    ollama run "${model_name}"
  fi
}

function qwen() {
  local prompt=""

  if (( $# > 0 )); then
    prompt="$*"
  elif [[ ! -t 0 ]]; then
    prompt=$(cat)
  fi

  _ollama_run_prompt "${QWEN_OLLAMA_MODEL}" "$prompt"
}
