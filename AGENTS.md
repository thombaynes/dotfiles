# Dotfiles

Personal dotfiles for macOS. Every folder has a `setup.sh` that initialises its own domain (usually by symlinking its files into `~` or `~/.config`), except `shortcuts/`, which is run by hand.

Everything can be run in one go through the root `bootstrap.sh`, which installs `packages/` first and then runs every other `setup.sh`. Shared helpers (`symlink`, `info`, `success`, ...) live in `scripts/functions.sh`.

Files are symlinked, so edits in this repo are live immediately. AGENTS do not push, only humans.

## Folder Structure

| Path | Contents |
| --- | --- |
| `asdf/` | Installs asdf and copies the global `.tool-versions` (terraform, golang) to `~`. |
| `bin/` | Small user scripts (`tat`, `bak`), symlinked into `~/bin/`. |
| `claude/` | Claude Code status line (`statusline.sh`: model, directory, colour-coded context usage bar). `setup.sh` symlinks it into `~/.claude/` and merges the `statusLine` entry into `settings.json` with `jq`. |
| `duti/` | Default-app associations: one file per app bundle ID listing the extensions it opens. `setup.sh` applies them with `duti`. |
| `fish/` | Fish shell configuration, including helper `functions/` and `completions/`. Symlinked into `~/.config/fish/`. |
| `ghostty/` | Ghostty `config.ghostty`, symlinked into `~/Library/Application Support/com.mitchellh.ghostty/`. |
| `git/` | `.gitconfig`, `.gitignore_global`, `.githelpers` and the commit template, symlinked into `~`. |
| `hammerspoon/` | Hammerspoon Lua config (hyper key, window management, lock screen, pomodoro). Has its own README. |
| `iterm2/` | Kept alongside Ghostty for now - iTerm2 preferences plist and the terminfo files for italics (`tic`). |
| `key-mappings/` | `hidutil` LaunchAgent plist for low-level key remapping (Caps Lock as Ctrl, left Ctrl as F18 for Hammerspoon). `setup.sh` symlinks it into `~/Library/LaunchAgents` and loads it. |
| `macos/` | `setup.sh` only: a long list of `defaults write` macOS preferences. |
| `nvim/` | Neovim config, with the whole folder symlinked to `~/.config/nvim`: lazy.nvim with plugin specs in `lua/plugins/` and options, keymaps and autocmds in `lua/config/` (see `nvim/CONTEXT.md` for a map of its files). Its `setup.sh` does the symlink. |
| `packages/` | `Brewfile` of Homebrew formulae and casks. Run first by `bootstrap.sh`. |
| `scripts/` | `functions.sh`, the shared helpers sourced by every `setup.sh`. |
| `shortcuts/` | One-stop keyboard shortcut cheat sheets (`neovim.md`, `tmux.md`, `fish.md`, `claude.md`) in a two-column markdown table that prints nicely. Hand-written source lives in `src/<tool>.txt` (`key \| action` lines; fish abbreviations are pulled from `fish/functions/setup.fish`). `generate.sh` renders `src/` to markdown and `generate.sh --check` lists bindings found in the configs but missing from `src/`. No `setup.sh`: it is run by hand and is not part of `bootstrap.sh`. |
| `tmux/` | `.tmux.conf`, symlinked into `~`.  Plugins are declared in the conf and installed with `prefix + I`. tmuxinator project files live outside this repo in `~/foundry/tmuxinator` (`TMUXINATOR_CONFIG` is set in `fish/config.fish`). |
| `TODO/` | `TODO.txt`, loose ideas for this repo. |
| `vscode/` | VS Code `settings.json`, symlinked into the app's User folder. |

## Root files

Root files: `bootstrap.sh` (entry point), `hosts` (copied to `/etc/hosts` by bootstrap), `ut_aws.sh` (AWS shell setup for work), `.tool-versions`, `LICENSE`, `README.md` (usage and customisation).

## When making changes

When making changes in this repo look to see if anything being installed can be managed through brew. If so, then add it to the Brewfile.

When adding new functionality not covered in other folders, make a new folder with a setup.sh and add it to the table above.

