# Dotfiles

Personal dotfiles for macOS. Every folder has a `setup.sh` that initialises its own domain (usually by symlinking its files into `~` or `~/.config`), except `shortcuts/`, which is run by hand, and `profiles/`, which the other scripts read.

Make changes only if requested. Agents DO NOT commit - only humans do.

## Profiles

Because this repo is being used on at least two laptops, there are profiles to store the major difference between them. This prevents the need to hard code any usernames or install paths. Use values from the loaded profile whenever possible.

The profiles live in `profiles/<name>.sh`, which are plain shell assignments. The active one for the local environment is `~/.config/dotfiles/profile.sh`, a symlink outside the repo, so a pull never changes which profile a laptop uses. 

`load_profile` (in `scripts/functions.sh`) creates it on first run by asking, or switches it when given a name (`./bootstrap.sh personal`, `git/setup.sh auros`), then sources it. brew only passes through `HOMEBREW_*` variables, so `packages/setup.sh` hands the Brewfile `TERMINAL` as `HOMEBREW_TERMINAL`.

- Setup scripts call `load_profile` when they need a value.
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
| `scripts/` | ❌ | `functions.sh`, the shared helpers sourced by every `setup.sh`. |
| `shortcuts/` | ✅ | One-stop keyboard shortcut cheat sheets (`neovim.md`, `tmux.md`, `zsh.md`, `fish.md`, `claude.md`) in a two-column markdown table that prints nicely. Also `workflows.md`, a hand-written file of how-tos that combine them. No `setup.sh`: it is run by hand and is not part of `bootstrap.sh`. |
| `tmux/` | ❌ | `.tmux.conf`, symlinked into `~`.  `setup.sh` also clones tpm to `~/.tmux/plugins/tpm`. Plugins are declared in the conf and installed with `prefix + I`. |
| `zsh/` | ✅ | The login shell. `.zprofile` and `.zshrc`, symlinked into `~`, set up to feel like fish: abbreviations (read from fish's list), autosuggestions, syntax highlighting, substring history search. `setup.sh` also sets zsh as the login shell. |
| `TODO/` | ❌ | `TODO.txt`, loose ideas for this repo. |
| `vscode/` | ❌ | VS Code `settings.json`, symlinked into the app's User folder. |

## Root files

Root files: `bootstrap.sh` (entry point), `LICENSE`, `README.md` (usage and customisation).

## fzf, fzf-lua, ripgrep and nvim

`FZF_DEFAULT_COMMAND` in `zsh/.zprofile` (an `rg --files` command) is the single source of truth for file listing. The `fzf` binary runs it in the shell and nvim's fzf-lua reads it from the environment (`nvim/lua/plugins/fzf.lua`), so change it there. `fish/config.fish` exports the same value for fish sessions; keep the two in sync. See `nvim/CONTEXT.md` for the fzf-lua details.

## When making changes

When making changes in this repo look to see if anything being installed can be managed through brew. If so, then add it to the Brewfile, and add the MacPorts equivalent to the Portlist if there is one (port names often differ or are versioned, e.g. `terraform-1.17`; check with `port search`).

When adding new functionality not covered in other folders, make a new folder with a setup.sh and add it to the table above.

