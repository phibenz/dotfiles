# Pi configuration

- `settings.json` stores the shared theme, provider, model, and package list.
- `install.sh` links settings to `~/.pi/agent/settings.json` and shared instructions
  from `../agents/AGENTS.md` to `~/.pi/agent/AGENTS.md`.
- Existing settings get a unique `settings.json.backup.*` file before replacement.
  Existing local instructions remain unchanged. Repeated installs keep correct links.

## Install on another machine

1. Install Node.js 22.19.0 or newer and npm. With nvm, use `nvm install 24`.
2. Install Pi: `npm install -g --ignore-scripts @earendil-works/pi-coding-agent`.
3. From this repository, run `bash pi/install.sh`.
4. Start `pi` and use `/login` to sign in on that machine.

Pi reads global settings from `~/.pi/agent/settings.json`. See the
[Pi settings documentation](https://github.com/earendil-works/pi/blob/main/packages/coding-agent/docs/settings.md).
Settings saved by Pi also update the linked repository file.

Keep `auth.json`, `models-store.json`, `trust.json`, `sessions/`, and downloaded
files local in `~/.pi/agent`. The installer does not copy or link these files.
The OpenAI login remains local to each machine.

Run `bash agents/install.sh` separately to install shared skills.
