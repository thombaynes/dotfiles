# Repo review (2026-11-16)

Not a full audit: the nvim, fish, hammerspoon and tmux contents were not read. Nothing here has been fixed yet.

## Real problems

1. **`claude/setup.sh` breaks on the MacPorts machine.** It runs `$(brew --prefix)/bin/bash`. With no brew, that resolves to `/bin/bash`, which is macOS's bash 3.2, so `CLAUDE_CODE_SHELL` is set to the shell it was meant to avoid. `bash` is also missing from `Portlist`. Detect the bash path with `command -v` instead, and add `bash` to `Portlist`.
2. **`Brewfile` has `brew "gotask"` and `cask "go-task"`.** `gotask` has no comment and looks like a mistake. `Portlist` only has `go-task`.
3. **`packages/setup.sh` runs a bare `sudo -v` and `brew bundle`.** `bootstrap.sh` has already asked for sudo, and `macos/setup.sh` asks again. The `Portlist` loop also runs `sudo port install` once per package.
4. **`duti/` is out of date:**
   - `duti` fails quietly for apps that aren't installed (VLC, Pages, Numbers).
   - `duti/setup.sh` doesn't quote `$fn` or `$ext`.
   - The extension list has odd entries (`.class`, `.lock`, `.log`, `.sample`, `.list`, `.config`). These now open in VS Code, and `.class` is binary.
   - Pages and Numbers aren't in the packages list. They're App Store apps and could go through `mas`.

## Inconsistencies

- `Portlist` lists `mas`, but its "no port" comments also list `mas`, `tap`, `brew` and `cask`. Those last three look like leftovers.
- `Brewfile` has `tap "homebrew/bundle"`, which is deprecated and no longer needed.
- `Portlist` is missing `nodenv`, `node-build` and `postgresql`, and `nodenv` is only mentioned in a comment. The Brewfile has them, so the two machines drift.
- **`README.md`:** it says "Install Homebrew and git", but one of the two machines uses MacPorts. It still has "Notes from the original authour" with the original author's blog links.
- **`ut_aws.sh`:**
  - It's a zsh script that writes to `~/.zshrc`, but the login shell is fish.
  - It's not hooked into `bootstrap.sh`.
  - `AGENTS.md` lists it, but not what it does.
- **Typos:** "Configuraing git" in `git/setup.sh`, "FInished" in `macos/setup.sh`, and the mixed spelling "authour".
- **`.gitignore`:** it says "Nothing yet" at the top, then has real entries.
- **`macos/setup.sh`:** the header says it was taken from `.osx`, and the sudo keepalive loop duplicates the one in `bootstrap.sh`.
- **`scripts/functions.sh`:** the check `[[ $color =~ '^[0-9]$' ]]` has a quoted regex, so it matches the literal text and never numeric colours. It's harmless today because only named colours are used.

## Minor

- **Stale VS Code settings:**
  - `vscode/settings.json` uses `python.linting.*` and `eslint.validate` with `autoFix`. Both are long-deprecated and ignored by current VS Code.
  - Its first comment line is still the default "Place your settings in this file".
- **`.ruby-lsp/`:** it sits in the repo root, untracked. It's ignored only because the `Gemfile` entries in `.gitignore` happen to match it.
- **`git/setup.sh`:** profile names `personal` and `usertesting` are hardcoded in the prompt and the error message.
- **Single-machine paths:** `fish/config.fish` hardcodes `/opt/homebrew/bin/brew`. That's fine because it's guarded with `test -x`.
