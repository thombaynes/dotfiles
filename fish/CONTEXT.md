# Fish config

Fish shell configuration, symlinked into `~/.config/fish/`.

## Adding a function

1. Create `functions/<name>.fish` containing a single `function <name>` of the same name (fish autoloads it by filename). Start with `#!/usr/bin/env fish` and a comment saying what it does.
2. **Link it.** `setup.sh` symlinks each `.fish` file individually, so a new file is not live until you re-run `fish/setup.sh`, or link it by hand: `ln -s ~/tdot/fish/functions/<name>.fish ~/.config/fish/functions/<name>.fish`. Open a new shell (or `exec fish`) afterwards.
3. Add it to the Functions section of `shortcuts/src/fish.txt`, then run `shortcuts/generate.sh`. Never edit `shortcuts/fish.md` directly.
4. Add the file to the folder structure below.

Abbreviations are different: add an `abbr` line to `functions/setup.fish` (run `setup` to reload them). They show up in the cheat sheet automatically.

Environment variables, `PATH` and aliases go in `config.fish`, not in a function.

## Folder structure

```
fish/
├── completions/                 Custom completions, symlinked into `~/.config/fish/completions/`.
│   ├── bundle.fish                Completions for bundler.
│   └── gem.fish                   Completions for rubygems' `gem`.
├── functions/                   One function per file, symlinked into `~/.config/fish/functions/`.
│   ├── abbrex.fish                Expands an abbreviation (`abbrex gs` prints `git status`).
│   ├── emptytrash.fish            Empties the Trash, Apple system logs and the download quarantine history.
│   ├── fisher.fish                Fisher, the fish plugin manager (vendored, v3.2.8).
│   ├── kyverno-policy-reporter.fish  Port-forwards Kyverno Policy Reporter UI to `localhost:9090` and opens it in the browser (abbr `kpr`).
│   ├── local-branches.fish        Lists each repo in `~/foundry/repos` with its branch, default-branch and dirty state (abbr `lb`).
│   ├── pubkey.fish                Copies `~/.ssh/id_rsa.pub` to the clipboard.
│   ├── setup.fish                 Defines every abbreviation. Run `setup` to reload them.
│   └── week.fish                  Prints the current week number.
├── config.fish                  Brew and MacPorts on the `PATH`, locale, `EDITOR`, `FZF_DEFAULT_COMMAND`, nodenv/rbenv init, GPG_TTY.
├── fishfile                     Fisher plugin list.
├── CONTEXT.md                   This file.
└── setup.sh                     Symlinks every `.fish` file and `fishfile` into `~/.config/fish/`, sets fish as the login shell, then runs `setup`.
```
