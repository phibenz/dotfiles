# Pi configuration

- `settings.json` stores the shared theme, default model, and package list.
- `editor-cursor.json` configures `pi-editor-cursor` with a `❯` input prefix.
- `web-search.json` enables direct Exa and Gemini API access.
- `install.sh` links Pi configuration into `~/.pi/agent`, links shared
  instructions from `../agents/AGENTS.md`, and installs default packages.
- Existing managed JSON files get unique `.backup.*` files before replacement.
  Existing local instructions remain unchanged. Repeated installs keep correct links.

## Install on another machine

1. Install Node.js 22.19.0 or newer and npm. With nvm, use `nvm install 24`.
2. Install Pi: `npm install -g --ignore-scripts @earendil-works/pi-coding-agent`.
3. Add the web-search keys to the local `~/.zshrc.local` file:

   ```sh
   export EXA_API_KEY="exa-..."
   export GEMINI_API_KEY="AIza..."
   ```

4. Reload the file with `source ~/.zshrc.local`.
5. From this repository, run `bash pi/install.sh`.
6. Start `pi` and use `/login` for providers that require interactive sign-in.

Pi reads global settings from `~/.pi/agent/settings.json`. See the
[Pi settings documentation](https://github.com/earendil-works/pi/blob/main/packages/coding-agent/docs/settings.md).
Settings saved by Pi also update the linked repository file.

Keep `auth.json`, `models-store.json`, `trust.json`, `sessions/`, and downloaded
files local in `~/.pi/agent`. The installer does not copy or link these files.
Keep API keys in `~/.zshrc.local`; do not add them to this repository.
The OpenAI login remains local to each machine.

Run `bash agents/install.sh` separately to install shared skills.
