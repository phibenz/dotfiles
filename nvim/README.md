# Neovim

Run `bash nvim/install.sh` from the dotfiles repository to install the configuration,
dependencies, plugins, and language servers for Lua, Python (`ty`), C/C++, Bash,
and Rust. Neovim 0.11 or newer must already be installed.

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
