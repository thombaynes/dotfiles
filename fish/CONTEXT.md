# Fish config

Fish shell configuration, symlinked into `~/.config/fish/`. zsh is now the login shell (see `zsh/CONTEXT.md`); this config is kept working, and `conf.d/abbreviations.fish` is the abbreviation list that zsh reads too.

## Adding a command

Commands that should work in any shell go in `bin/` as bash scripts, not as fish functions (see `zsh/CONTEXT.md`). Only fish-specific helpers, such as an abbreviation's `--function`, belong in `functions/`: one `function <name>` per `functions/<name>.fish` (fish autoloads it by filename), linked by re-running `fish/setup.sh`.

Abbreviations: add an `abbr` line to `conf.d/abbreviations.fish`. zsh picks it up in new shells and it shows up in the cheat sheet automatically. An abbreviation with `--function` also needs a zsh function of the same name in `zsh/abbreviations.zsh`.

Environment variables, `PATH` and aliases go in `config.fish`, not in a function. Mirror them in `zsh/.zprofile` (environment, `PATH`) or `zsh/.zshrc` (aliases).

## Folder structure

```
fish/
├── conf.d/                      Run on every shell start, symlinked into `~/.config/fish/conf.d/`.
│   └── abbreviations.fish         Defines every abbreviation.
├── functions/                   One function per file, symlinked into `~/.config/fish/functions/`.
│   └── __abbr_grbm.fish           Expands abbr `grbm` to a rebase onto the repo's default branch (from `origin/HEAD`). zsh has its own copy.
├── config.fish                  Brew and MacPorts on the `PATH`, locale, `EDITOR`, `FZF_DEFAULT_COMMAND`, nodenv/rbenv init.
├── CONTEXT.md                   This file.
└── setup.sh                     Symlinks every `.fish` file into `~/.config/fish/`.
```
