# Neovim

Run `bash nvim/install.sh` from the dotfiles repository to install the configuration,
dependencies, plugins, and language servers for Lua, Python (`ty`), C/C++, Bash,
and Rust. Neovim 0.11 or newer must already be installed.

On Linux, the installer builds Tree-sitter CLI 0.27.0 with Cargo when the CLI is
missing. It installs a minimal Rust toolchain if Cargo is missing. The build
uses the installed system libraries and puts the CLI in `~/.local/bin`.
Add this directory to your shell's `PATH`. On macOS, the installer uses Homebrew.

The installer also installs `fd` for file searches. On Ubuntu and Debian, it
installs `fd-find` and links `~/.local/bin/fd` to `fdfind` if no `fd` exists.

The installer runs Mason after plugin synchronization and waits for the language
servers to finish installing. A failed server installation stops the script with
an error; rerun the installer after resolving it.

For an existing setup, install or retry all configured servers without navigating
the Mason menu:

```vim
:MasonInstall lua-language-server ty clangd bash-language-server rust-analyzer
```

Mason needs Node.js/npm for the Bash server and Python 3 with pip and venv for
`ty`. The installer provides these on macOS with Homebrew and Linux with apt.
On other systems, install these dependencies yourself. Use `:checkhealth mason`
to check dependencies and `:MasonLog` to inspect installation failures.
