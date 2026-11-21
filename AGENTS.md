# Dotfiles

Personal dotfiles for macOS. Everything the `Makefile` runs lives in `modules/`. Each module is a folder with a `setup.sh` that initialises its own domain (usually by symlinking its files into `~` or `~/.config`). The other root folders are not modules: `scripts/` and `profiles/` are read by the module scripts, `shortcuts/` is generated with `make shortcuts` (no `setup.sh`, not part of `make all`), and `TODO/` is notes. The root `Makefile` runs the modules and reports their status (see Makefile below).

Make changes only if requested. Agents DO NOT commit - only humans do.

## Profiles

Because this repo is being used on at least two laptops, there are profiles to store the major difference between them. This prevents the need to hard code any usernames or install paths. Use values from the loaded profile whenever possible.

The profiles live in `profiles/<name>.sh`, which are plain shell assignments. The active one for the local environment is `~/.config/dotfiles/profile.sh`, a symlink outside the repo, so a pull never changes which profile a laptop uses. 

`load_profile` (in `scripts/functions.sh`) creates it on first run by asking, or switches it when given a name (`./bootstrap.sh personal`, `modules/git/setup.sh auros`, `make profile NAME=auros`), then sources it. brew only passes through `HOMEBREW_*` variables, so `modules/packages/setup.sh` hands the Brewfile `TERMINAL` as `HOMEBREW_TERMINAL`.

- Every `setup.sh` calls `profile_guard` right after sourcing `scripts/functions.sh`. It loads the profile, and when the profile's `SKIP_MODULES` lists the module it logs "Skipping <module> - not part of the <profile> profile." and exits.
- Setup scripts call `load_profile` when they need a value before the guard (`modules/git/setup.sh`, to switch profile first).
- `modules/zsh/.zprofile` sources it too and exports `HOME_REPO` and `SSH_KEY`.
- A new value goes in every profile.

## Folder Structure

The `modules/<name>/` rows are the modules the `Makefile` runs, in alphabetical order (the install order is in `MODULES` in the `Makefile`). The rows after them are the other folders at the root.

| Path | CONTEXT.md | Contents |
| --- | --- | --- |
| `modules/bin/` | ✅ | Small custom scripts, symlinked into `~/.local/bin/` (on the zsh `PATH`). Shell-independent commands go here as bash scripts, not as shell functions. |
| `modules/claude/` | ❌ | Claude Code status line. Symlinks into `~/.claude/` |
| `modules/duti/` | ❌ | Default-app associations: one file per app bundle ID listing the extensions it opens. `setup.sh` applies them with `duti`. |
| `modules/ghostty/` | ❌ | Ghostty `config.ghostty`, symlinked into `~/Library/Application Support/com.mitchellh.ghostty/`. The terminal for newer Macs. |
| `modules/git/` | ✅ | Git config and defaults, symlinked into `~`. `setup.sh` generates `~/.gitconfig-local` from the profile. |
| `modules/hammerspoon/` | ❌ | Hammerspoon Lua config. Has its own README. Used for making a global hyper key. |
| `modules/iterm2/` | ❌ | The terminal for older Macs. iTerm2 preferences plist (iTerm2 reads it from this folder) and a font copy step for the Nerd Font symbols. |
| `modules/key-mappings/` | ❌ | `hidutil` LaunchAgent plist for key remapping (left Ctrl as F18 for Hammerspoon, Escape as backtick). Caps Lock as Ctrl is not here: set it by hand in System Settings > Keyboard > Keyboard Shortcuts > Modifier Keys. `setup.sh` symlinks it into `~/Library/LaunchAgents`. |
| `modules/macos/` | ❌ | `setup.sh` only: a long list of `defaults write` macOS preferences. |
| `modules/nvim/` | ✅ | Neovim config, with the whole folder symlinked to `~/.config/nvim`. lazy.nvim with `config/` files (options keymaps and autocmds) and `plugins/` specs. See `modules/nvim/CONTEXT.md` for file map. Its `setup.sh` does the symlink. |
| `modules/packages/` | ❌ | `Brewfile` of Homebrew formulae and casks, and `Portlist`, the MacPorts equivalent. `setup.sh` uses the profile's `PACKAGE_MANAGER`, and the Brewfile installs only the profile's `TERMINAL`. |
| `modules/tmux/` | ❌ | `.tmux.conf`, symlinked into `~`.  `setup.sh` also clones tpm to `~/.tmux/plugins/tpm`. Plugins are declared in the conf and installed with `prefix + I`. |
| `modules/vscode/` | ❌ | VS Code `settings.json`, symlinked into the app's User folder. |
| `modules/zsh/` | ✅ | The login shell. `.zprofile` and `.zshrc`, symlinked into `~`, set up to feel like fish: abbreviations (`abbreviations.list`), autosuggestions, syntax highlighting, substring history search. `setup.sh` also sets zsh as the login shell. |
| `TODO/` | ❌ | `TODO.txt`, loose ideas for this repo. |
| `profiles/` | ❌ | One file of settings per kind of machine (`auros.sh`, `personal.sh`). `load_profile` links the active one. See Profiles above. |
| `scripts/` | ❌ | `functions.sh`, the shared helpers sourced by every `setup.sh`, including the dry run ones. `status.sh` runs each `setup.sh` in a dry run for `make status`. |
| `shortcuts/` | ✅ | One-stop keyboard shortcut cheat sheets (`neovim.md`, `tmux.md`, `zsh.md`, `claude.md`) in a two-column markdown table that prints nicely. Also `workflows.md`, a hand-written file of how-tos that combine them. No `setup.sh`: `make shortcuts` regenerates the sheets (it runs `shortcuts/generate.sh`), and it is not part of `make all` or `bootstrap.sh`. |

## Root files

Root files: `bootstrap.sh` (entry point on a new Mac, ends with `make all`), `Makefile` (day-to-day running and status, see below), `LICENSE`, `README.md` (usage and customisation).

## Makefile

`make help` lists the targets. `make <module>` runs that module's `setup.sh`, `make all` runs them all in the install order kept in `MODULES`, and `make profile` shows or switches the profile. bootstrap.sh stays the first step on a new Mac, because `make` needs the Command Line Tools that it installs.

`make status` is read-only. It runs each `setup.sh` in a dry run (`DOTFILES_DRY_RUN=1`) and prints one line per module: in sync, the number of changes it would make, or skipped by the profile. `make status-<module>` lists each change. It covers packages (`brew bundle check`, or missing ports), and every module except `macos`, which has no dry run yet.

When asked about the state of part of this laptop's config (is something set up, out of date, or would a setup change anything), run `make status` or `make status-<module>` rather than inspecting the files by hand.

A dry run depends on every change in a `setup.sh` going through the helpers in `scripts/functions.sh` (`symlink`, `make_dir`, `clear_broken_symlinks`), or being wrapped in `dry_run` with a `would "..."` report in its place. A plain command would run for real during `make status`.

## fzf, fzf-lua, ripgrep and nvim

`FZF_DEFAULT_COMMAND` in `modules/zsh/.zprofile` (an `rg --files` command) is the single source of truth for file listing. The `fzf` binary runs it in the shell and nvim's fzf-lua reads it from the environment (`modules/nvim/lua/plugins/fzf.lua`), so change it there. See `modules/nvim/CONTEXT.md` for the fzf-lua details.

## When making changes

When making changes in this repo look to see if anything being installed can be managed through brew. If so, then add it to `modules/packages/Brewfile`, and add the MacPorts equivalent to `modules/packages/Portlist` if there is one (port names often differ or are versioned, e.g. `terraform-1.17`; check with `port search`).

When adding new functionality not covered in other modules, make a new folder in `modules/` with a setup.sh and add it to the table above. The setup.sh sources `../../scripts/functions.sh`, calls `profile_guard` and supports dry run (see Makefile above), and the module goes in `MODULES` in the `Makefile` at its place in the install order.

