# Dotfiles

Personal dotfiles for macOS. Every folder has a `setup.sh` that initialises its own domain (usually by symlinking its files into `~` or `~/.config`).

Everything can be run in one go through the root `bootstrap.sh`, which installs `packages/` first and then runs every other `setup.sh`. Shared helpers (`symlink`, `info`, `success`, ...) live in `scripts/functions.sh`.

Files are symlinked, so edits in this repo are live immediately. AGENTS do not push, only humans.

| Path | Contents |
| --- | --- |
| `asdf/` | Installs asdf and copies the global `.tool-versions` (terraform, golang) to `~`. |
| `bin/` | Small user scripts (`tat`, `bak`), symlinked into `~/bin/`. |
| `duti/` | Default-app associations: one file per app bundle ID listing the extensions it opens. `setup.sh` applies them with `duti`. |
| `fish/` | Fish shell configuration, including helper `functions/` and `completions/`. Symlinked into `~/.config/fish/`. |
| `git/` | `.gitconfig`, `.gitignore_global`, `.githelpers` and the commit template, symlinked into `~`. |
| `hammerspoon/` | Hammerspoon Lua config (hyper key, window management, lock screen, pomodoro). Has its own README. |
| `herdr/` | NOT IN USE - Herdr terminal multiplexer `config.toml`, a port of the tmux config. `NOTES.md` maps tmux bindings to Herdr. |
| `iterm2/` | NOT IN USE - iTerm2 preferences plist and the terminfo files for italics (`tic`). |
| `karabiner/` | Karabiner-Elements `karabiner.json` (Caps Lock as Ctrl, left Ctrl as F18 for Hammerspoon). |
| `key-mappings/` | `hidutil` LaunchAgent plist for low-level key remapping. No `setup.sh`, so `bootstrap.sh` does not apply it. |
| `macos/` | `setup.sh` only: a long list of `defaults write` macOS preferences. |
| `packages/` | `Brewfile` of Homebrew formulae and casks. Run first by `bootstrap.sh`. |
| `repos/` | `plugins.list` of git repos to clone, and a checkout of `infrastructure-argocd-apps`. |
| `scripts/` | `functions.sh`, the shared helpers sourced by every `setup.sh`. |
| `tmux/` | `.tmux.conf`, symlinked into `~`. |
| `TODO/` | `TODO.txt`, loose ideas for this repo. |
| `vim/` | `.vimrc` (Vundle, ALE, fzf) symlinked to `~`, and `nvim/` (lazy.nvim; plugin specs in `lua/plugins/`) symlinked to `~/.config/nvim`. |
| `vscode/` | VS Code `settings.json`, symlinked into the app's User folder. |

TODO remove iterm2 from bootstrap. Completely remove herdr and karabiner and repos. Add key-mappings to bootstrap. Review macos for anything out of date

Root files: `bootstrap.sh` (entry point), `hosts` (copied to `/etc/hosts` by bootstrap), `ut_aws.sh` (AWS shell setup for work), `.tool-versions`, `LICENSE`, `README.md` (usage and customisation).
