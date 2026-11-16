# Dotfiles

Personal dotfiles for macOS. Every folder has a `setup.sh` that initialises its own domain (usually by symlinking its files into `~` or `~/.config`), except `shortcuts/`, which is run by hand.

Everything can be run in one go through the root `bootstrap.sh`, which installs `packages/` first and then runs every other `setup.sh`. Shared helpers (`symlink`, `info`, `success`, ...) live in `scripts/functions.sh`.

Files are symlinked, so edits in this repo are live immediately. AGENTS do not push, only humans.

The repo runs on two kinds of machine, so avoid hard-coding usernames or install paths (use `$HOME`, `$USER`, `command -v`):

- **Newer Macs** (the Apple silicon work laptop): Homebrew under `/opt/homebrew`, Ghostty.
- **Older Macs** (the 2015 MacBook Pro, which Ghostty doesn't support): MacPorts under `/opt/local`, iTerm2.

## Folder Structure

| Path | CONTEXT.md | Contents |
| --- | --- | --- |
| `bin/` | ❌ | Small custom scripts, symlinked into `~/bin/`. |
| `claude/` | ❌ | Claude Code status line. Symlinks into `~/.claude/` |
| `duti/` | ❌ | Default-app associations: one file per app bundle ID listing the extensions it opens. `setup.sh` applies them with `duti`. |
| `fish/` | ✅ | Fish shell configuration symlinked into `~/.config/fish/`. `config.fish` puts brew and MacPorts on the `PATH` if present. |
| `ghostty/` | ❌ | Ghostty `config.ghostty`, symlinked into `~/Library/Application Support/com.mitchellh.ghostty/`. The terminal for newer Macs. |
| `git/` | ✅ | Git config and defaults, symlinked into `~`. |
| `gnupg/` | ❌ | `gpg-agent.conf` (long passphrase cache). `setup.sh` copies it to `~/.gnupg` and appends `pinentry-program` pointing at `pinentry-mac` wherever brew or MacPorts put it, then restarts the agent. |
| `hammerspoon/` | ❌ | Hammerspoon Lua config. Has its own README. Used for making a global hyper key. |
| `iterm2/` | ❌ | The terminal for older Macs. iTerm2 preferences plist and the terminfo files for italics (`tic`). |
| `key-mappings/` | ❌ | `hidutil` LaunchAgent plist for key remapping (left Ctrl as F18 for Hammerspoon, Escape as backtick). Caps Lock as Ctrl is not here: set it by hand in System Settings > Keyboard > Keyboard Shortcuts > Modifier Keys. `setup.sh` symlinks it into `~/Library/LaunchAgents`. |
| `macos/` | ❌ | `setup.sh` only: a long list of `defaults write` macOS preferences. |
| `nvim/` | ✅ | Neovim config, with the whole folder symlinked to `~/.config/nvim`. lazy.nvim with `config/` files (options keymaps and autcmds) and `plugins/` specs. See `nvim/CONTEXT.md` for file map. Its `setup.sh` does the symlink. |
| `packages/` | ❌ | `Brewfile` of Homebrew formulae and casks, and `Portlist`, the MacPorts equivalent. `setup.sh` uses whichever of brew or MacPorts is installed. |
| `scripts/` | ❌ | `functions.sh`, the shared helpers sourced by every `setup.sh`. |
| `shortcuts/` | ✅ | One-stop keyboard shortcut cheat sheets (`neovim.md`, `tmux.md`, `fish.md`, `claude.md`) in a two-column markdown table that prints nicely. No `setup.sh`: it is run by hand and is not part of `bootstrap.sh`. |
| `tmux/` | ❌ | `.tmux.conf`, symlinked into `~`.  Plugins are declared in the conf and installed with `prefix + I`. |
| `TODO/` | ❌ | `TODO.txt`, loose ideas for this repo. |
| `vscode/` | ❌ | VS Code `settings.json`, symlinked into the app's User folder. |

## Root files

Root files: `bootstrap.sh` (entry point), `hosts` (copied to `/etc/hosts` by bootstrap), `ut_aws.sh` (AWS shell setup for work), `LICENSE`, `README.md` (usage and customisation).

## fzf, fzf-lua, ripgrep and nvim

`FZF_DEFAULT_COMMAND` in `fish/config.fish` (an `rg --files` command) is the single source of truth for file listing. The `fzf` binary runs it in the shell and nvim's fzf-lua reads it from the environment (`nvim/lua/plugins/fzf.lua`), so change it in fish only. See `nvim/CONTEXT.md` for the fzf-lua details.

## When making changes

When making changes in this repo look to see if anything being installed can be managed through brew. If so, then add it to the Brewfile, and add the MacPorts equivalent to the Portlist if there is one (port names often differ or are versioned, e.g. `terraform-1.17`; check with `port search`).

When adding new functionality not covered in other folders, make a new folder with a setup.sh and add it to the table above.

