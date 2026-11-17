# Repo review (2026-11-16)

Not a full audit: the nvim, fish, hammerspoon and tmux contents were not read. Nothing here has been fixed yet.

## Real problems

1. **`claude/setup.sh` breaks on the MacPorts machine.** It runs `$(brew --prefix)/bin/bash`. With no brew, that resolves to `/bin/bash`, which is macOS's bash 3.2, so `CLAUDE_CODE_SHELL` is set to the shell it was meant to avoid. `bash` is also missing from `Portlist`. Detect the bash path with `command -v` instead, and add `bash` to `Portlist`.

## Inconsistencies

- **`scripts/functions.sh`:** the check `[[ $color =~ '^[0-9]$' ]]` has a quoted regex, so it matches the literal text and never numeric colours. It's harmless today because only named colours are used.

## Minor

- **Stale VS Code settings:**
  - `vscode/settings.json` uses `python.linting.*` and `eslint.validate` with `autoFix`. Both are long-deprecated and ignored by current VS Code.
- **`.ruby-lsp/`:** it sits in the repo root, untracked. It's ignored only because the `Gemfile` entries in `.gitignore` happen to match it.
