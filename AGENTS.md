# Dotfiles

Personal dotfiles for macOS. Every folder has a `setup.sh` that initialises its own domain (usually by symlinking its files into `~` or `~/.config`), except `shortcuts/`, which is run by hand.

Everything can be run in one go through the root `bootstrap.sh`, which installs `packages/` first and then runs every other `setup.sh`. Shared helpers (`symlink`, `info`, `success`, ...) live in `scripts/functions.sh`.

Files are symlinked, so edits in this repo are live immediately. AGENTS do not push, only humans.

The repo runs on two kinds of machine, so avoid hard-coding usernames or install paths (use `$HOME`, `$USER`, `command -v`):

- **Newer Macs** (the Apple silicon work laptop): Homebrew under `/opt/homebrew`, Ghostty.
- **Older Macs** (the 2015 MacBook Pro, which Ghostty doesn't support): MacPorts under `/opt/local`, iTerm2.

## Folder Structure

| Path | Contents |
| --- | --- |
| `bin/` | Small user scripts (`tat`, `bak`), symlinked into `~/bin/`. |
| `claude/` | Claude Code status line (`statusline.sh`: model, directory, colour-coded context usage bar). `setup.sh` symlinks it into `~/.claude/` and merges the `statusLine` entry into `settings.json` with `jq`. |
| `duti/` | Default-app associations: one file per app bundle ID listing the extensions it opens. `setup.sh` applies them with `duti`. |
| `fish/` | Fish shell configuration, including helper `functions/` and `completions/`. Symlinked into `~/.config/fish/`. `config.fish` puts brew and MacPorts on the `PATH` if present and sets `GPG_TTY` so gpg can prompt for a passphrase. `setup.sh` makes whichever fish is on the `PATH` the login shell. |
| `ghostty/` | Ghostty `config.ghostty`, symlinked into `~/Library/Application Support/com.mitchellh.ghostty/`. The terminal for newer Macs (e.g. the Apple silicon work laptop). |
| `git/` | `.gitconfig`, `.gitignore_global`, `.githelpers` and the commit template, symlinked into `~`. Machine-specific identity (name, email, signing key) lives in `.personal-gitconfig` and `.usertesting-gitconfig`; `setup.sh [personal\|usertesting]` symlinks one to `~/.gitconfig-local`, which `.gitconfig` includes. |
| `hammerspoon/` | Hammerspoon Lua config (hyper key, window management, lock screen, pomodoro). Has its own README. |
| `iterm2/` | The terminal for older Macs that Ghostty doesn't support (e.g. the 2015 MacBook Pro): iTerm2 preferences plist and the terminfo files for italics (`tic`). The plist is tuned for the 2015 MacBook Pro (user `thombaynes`, MacPorts fish at `/opt/local/bin/fish`). |
| `key-mappings/` | `hidutil` LaunchAgent plist for low-level key remapping (left Ctrl as F18 for Hammerspoon, Escape as backtick). Caps Lock as Ctrl is not here: set it by hand in System Settings > Keyboard > Keyboard Shortcuts > Modifier Keys. `setup.sh` symlinks it into `~/Library/LaunchAgents` and loads it. |
| `macos/` | `setup.sh` only: a long list of `defaults write` macOS preferences. |
| `nvim/` | Neovim config, with the whole folder symlinked to `~/.config/nvim`: lazy.nvim with plugin specs in `lua/plugins/` and options, keymaps and autocmds in `lua/config/` (see `nvim/CONTEXT.md` for a map of its files). Its `setup.sh` does the symlink. |
| `packages/` | `Brewfile` of Homebrew formulae and casks, and `Portlist`, the MacPorts equivalent (ports only, no casks). `setup.sh` uses whichever of brew or MacPorts is installed. It fails if neither is, or if MacPorts is installed alongside brew formulae (brew casks alone are fine, and MacPorts is used). Run first by `bootstrap.sh`. |
| `scripts/` | `functions.sh`, the shared helpers sourced by every `setup.sh`. |
| `shortcuts/` | One-stop keyboard shortcut cheat sheets (`neovim.md`, `tmux.md`, `fish.md`, `claude.md`) in a two-column markdown table that prints nicely. Hand-written source lives in `src/<tool>.txt` (`key \| action` lines; fish abbreviations are pulled from `fish/functions/setup.fish`). `generate.sh` renders `src/` to markdown and `generate.sh --check` lists bindings found in the configs but missing from `src/`. No `setup.sh`: it is run by hand and is not part of `bootstrap.sh`. |
| `tmux/` | `.tmux.conf`, symlinked into `~`.  Plugins are declared in the conf and installed with `prefix + I`. tmuxinator project files live outside this repo in `~/foundry/tmuxinator` (`TMUXINATOR_CONFIG` is set in `fish/config.fish`). |
| `TODO/` | `TODO.txt`, loose ideas for this repo. |
| `vscode/` | VS Code `settings.json`, symlinked into the app's User folder. |

## Root files

Root files: `bootstrap.sh` (entry point), `hosts` (copied to `/etc/hosts` by bootstrap), `ut_aws.sh` (AWS shell setup for work), `LICENSE`, `README.md` (usage and customisation).

## When making changes

When making changes in this repo look to see if anything being installed can be managed through brew. If so, then add it to the Brewfile, and add the MacPorts equivalent to the Portlist if there is one (port names often differ or are versioned, e.g. `terraform-1.17`; check with `port search`).

When adding new functionality not covered in other folders, make a new folder with a setup.sh and add it to the table above.

