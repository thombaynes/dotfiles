# Dotfiles

Personal dotfiles for macOS. Every folder has a `setup.sh` that initialises its own domain (usually by symlinking its files into `~` or `~/.config`), except `shortcuts/`, which is run by hand, and `profiles/`, which the other scripts read. The root `Makefile` runs them and reports their status (see Makefile below).

Make changes only if requested. Agents DO NOT commit - only humans do.

## Profiles

Because this repo is being used on at least two laptops, there are profiles to store the major difference between them. This prevents the need to hard code any usernames or install paths. Use values from the loaded profile whenever possible.

The profiles live in `profiles/<name>.sh`, which are plain shell assignments. The active one for the local environment is `~/.config/dotfiles/profile.sh`, a symlink outside the repo, so a pull never changes which profile a laptop uses. 

`load_profile` (in `scripts/functions.sh`) creates it on first run by asking, or switches it when given a name (`./bootstrap.sh personal`, `git/setup.sh auros`, `make profile NAME=auros`), then sources it. brew only passes through `HOMEBREW_*` variables, so `packages/setup.sh` hands the Brewfile `TERMINAL` as `HOMEBREW_TERMINAL`.

- Every `setup.sh` calls `profile_guard` right after sourcing `scripts/functions.sh`. It loads the profile, and when the profile's `SKIP_FOLDERS` lists the folder it logs "Skipping <folder> - not part of the <profile> profile." and exits.
- Setup scripts call `load_profile` when they need a value before the guard (`git/setup.sh`, to switch profile first).
- `zsh/.zprofile` sources it too and exports `HOME_REPO` and `SSH_KEY`.
- A new value goes in every profile.

## Folder Structure

| Path | CONTEXT.md | Contents |
| --- | --- | --- |
| `bin/` | ✅ | Small custom scripts, symlinked into `~/.local/bin/` (on the zsh and fish `PATH`). Shell-independent commands go here as bash scripts, not as shell functions. |
| `claude/` | ❌ | Claude Code status line. Symlinks into `~/.claude/` |
| `duti/` | ❌ | Default-app associations: one file per app bundle ID listing the extensions it opens. `setup.sh` applies them with `duti`. |
| `fish/` | ✅ | Fish shell configuration symlinked into `~/.config/fish/`. No longer the login shell, but `conf.d/abbreviations.fish` is the abbreviation list for both shells. `config.fish` puts brew and MacPorts on the `PATH` if present. |
| `ghostty/` | ❌ | Ghostty `config.ghostty`, symlinked into `~/Library/Application Support/com.mitchellh.ghostty/`. The terminal for newer Macs. |
| `git/` | ✅ | Git config and defaults, symlinked into `~`. `setup.sh` generates `~/.gitconfig-local` from the profile. |
| `hammerspoon/` | ❌ | Hammerspoon Lua config. Has its own README. Used for making a global hyper key. |
| `iterm2/` | ❌ | The terminal for older Macs. iTerm2 preferences plist (iTerm2 reads it from this folder) and a font copy step for the Nerd Font symbols. |
| `key-mappings/` | ❌ | `hidutil` LaunchAgent plist for key remapping (left Ctrl as F18 for Hammerspoon, Escape as backtick). Caps Lock as Ctrl is not here: set it by hand in System Settings > Keyboard > Keyboard Shortcuts > Modifier Keys. `setup.sh` symlinks it into `~/Library/LaunchAgents`. |
| `macos/` | ❌ | `setup.sh` only: a long list of `defaults write` macOS preferences. |
| `nvim/` | ✅ | Neovim config, with the whole folder symlinked to `~/.config/nvim`. lazy.nvim with `config/` files (options keymaps and autcmds) and `plugins/` specs. See `nvim/CONTEXT.md` for file map. Its `setup.sh` does the symlink. |
| `packages/` | ❌ | `Brewfile` of Homebrew formulae and casks, and `Portlist`, the MacPorts equivalent. `setup.sh` uses the profile's `PACKAGE_MANAGER`, and the Brewfile installs only the profile's `TERMINAL`. |
| `profiles/` | ❌ | One file of settings per kind of machine (`auros.sh`, `personal.sh`). `load_profile` links the active one. See Profiles above. |
| `scripts/` | ❌ | `functions.sh`, the shared helpers sourced by every `setup.sh`, including the dry run ones. `status.sh` runs each `setup.sh` in a dry run for `make status`. |
| `shortcuts/` | ✅ | One-stop keyboard shortcut cheat sheets (`neovim.md`, `tmux.md`, `zsh.md`, `fish.md`, `claude.md`) in a two-column markdown table that prints nicely. Also `workflows.md`, a hand-written file of how-tos that combine them. No `setup.sh`: it is run by hand and is not part of `bootstrap.sh`. |
| `tmux/` | ❌ | `.tmux.conf`, symlinked into `~`.  `setup.sh` also clones tpm to `~/.tmux/plugins/tpm`. Plugins are declared in the conf and installed with `prefix + I`. |
| `zsh/` | ✅ | The login shell. `.zprofile` and `.zshrc`, symlinked into `~`, set up to feel like fish: abbreviations (read from fish's list), autosuggestions, syntax highlighting, substring history search. `setup.sh` also sets zsh as the login shell. |
| `TODO/` | ❌ | `TODO.txt`, loose ideas for this repo. |
| `vscode/` | ❌ | VS Code `settings.json`, symlinked into the app's User folder. |

## Root files

Root files: `bootstrap.sh` (entry point on a new Mac, ends with `make all`), `Makefile` (day-to-day running and status, see below), `LICENSE`, `README.md` (usage and customisation).

## Makefile

`make help` lists the targets. `make <folder>` runs that folder's `setup.sh`, `make all` runs them all in the install order kept in `FOLDERS`, and `make profile` shows or switches the profile. bootstrap.sh stays the first step on a new Mac, because `make` needs the Command Line Tools that it installs.

`make status` is read-only. It runs each `setup.sh` in a dry run (`DOTFILES_DRY_RUN=1`) and prints one line per folder: in sync, the number of changes it would make, or skipped by the profile. `make status-<folder>` lists each change. It covers packages (`brew bundle check`, or missing ports), and every folder except `macos`, which has no dry run yet.

When asked about the state of part of this laptop's config (is something set up, out of date, or would a setup change anything), run `make status` or `make status-<folder>` rather than inspecting the files by hand.

A dry run depends on every change in a `setup.sh` going through the helpers in `scripts/functions.sh` (`symlink`, `make_dir`, `clear_broken_symlinks`), or being wrapped in `dry_run` with a `would "..."` report in its place. A plain command would run for real during `make status`.

## fzf, fzf-lua, ripgrep and nvim

`FZF_DEFAULT_COMMAND` in `zsh/.zprofile` (an `rg --files` command) is the single source of truth for file listing. The `fzf` binary runs it in the shell and nvim's fzf-lua reads it from the environment (`nvim/lua/plugins/fzf.lua`), so change it there. `fish/config.fish` exports the same value for fish sessions; keep the two in sync. See `nvim/CONTEXT.md` for the fzf-lua details.

## When making changes

When making changes in this repo look to see if anything being installed can be managed through brew. If so, then add it to the Brewfile, and add the MacPorts equivalent to the Portlist if there is one (port names often differ or are versioned, e.g. `terraform-1.17`; check with `port search`).

When adding new functionality not covered in other folders, make a new folder with a setup.sh and add it to the table above. The setup.sh calls `profile_guard` and supports dry run (see Makefile above), and the folder goes in `FOLDERS` in the `Makefile` at its place in the install order.

