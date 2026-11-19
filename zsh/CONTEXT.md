# zsh config

The login shell, set up to feel like fish. `.zprofile` and `.zshrc` are symlinked into `~` and `starship.toml` into `~/.config`; `.zshrc` finds the rest of this folder through its real path.

## What makes it feel like fish

- **Abbreviations** (`abbreviations.zsh`): Space or Enter expands `gs` to `git status` in command position, so history holds the full command. Ctrl-Space inserts a plain space. The list is read from `fish/conf.d/abbreviations.fish` on every shell start, so there is one list for both shells and the cheat sheet. An `abbr x --function f` line calls the zsh function `f`, which must be defined in `abbreviations.zsh` (currently only `__abbr_grbm`).
- **Plugins**, from brew or MacPorts (`packages/`), each skipped if not installed: zsh-autosuggestions (grey history suggestion, → accepts), zsh-syntax-highlighting (with a regexp rule so typed abbreviations show as valid), zsh-history-substring-search (↑/↓ match what's typed anywhere in the line; without it ↑/↓ fall back to zsh's built-in prefix search).
- **Prompt**: starship, configured in `starship.toml`
- **Completion**: an arrow-key menu, case-insensitive, grouped under descriptions.
- **Keys**: emacs mode (set explicitly: zsh would pick vi mode because `EDITOR` is nvim), Alt-E edits the line in `$EDITOR`, Alt-S prepends `sudo`, Alt-Left/Right move by word.

## Adding things

- **Abbreviation**: add an `abbr` line to `fish/conf.d/abbreviations.fish`, then open a new shell.
- **Command**: a bash script in `bin/` (re-run `bin/setup.sh` to link it), so it works in every shell. Add it to the Scripts section of `shortcuts/src/zsh.txt` and run `shortcuts/generate.sh`.
- **Environment variable or `PATH` entry**: `.zprofile`. It runs for login shells, which is every terminal tab and tmux pane on macOS. It is not `.zshenv` because macOS's `/etc/zprofile` reorders `PATH` after `.zshenv`.
- **Alias, option, key binding**: `.zshrc`. Bindings must come before the plugins are loaded, because zsh-syntax-highlighting wraps the widgets that exist when it loads.
- **Machine-specific settings** (work tools and the like): `~/.zprofile.local` or `~/.zshrc.local`, sourced last and not in the repo. `setup.sh` moves an existing `~/.zprofile` or `~/.zshrc` there before linking.

## Folder structure

```
zsh/
├── .zprofile            Login shells: brew and MacPorts on the `PATH`, `~/.local/bin`, locale, `EDITOR`, `FZF_DEFAULT_COMMAND`, and `HOME_REPO`/`SSH_KEY` from the profile.
├── .zshrc               Interactive shells: history, options, nodenv/rbenv, completion, key bindings, starship, plugins.
├── abbreviations.zsh    Reads fish's abbreviation list and binds Space/Enter to expand it. Sourced by `.zshrc`.
├── CONTEXT.md           This file.
├── starship.toml        Prompt config (full path in the directory module). Symlinked to `~/.config/starship.toml`.
└── setup.sh             Symlinks `.zprofile` and `.zshrc` into `~` and `starship.toml` into `~/.config`, and makes `/bin/zsh` the login shell.
```

