## Keyboard Shortcuts

This folder is a one stop shop for most - but not all - of the keyboard shortcuts offered by this dotfiles repo.

When making changes maintain the two columns layout that separates the tools

```
shortcuts/
├── CONTEXT.md     This file.
├── generate.sh    Renders src/*.txt to the markdown files; `--check` lists bindings in the configs missing from src/.
├── claude.md      Generated cheat sheet for Claude Code.
├── neovim.md      Generated cheat sheet for Neovim.
├── tmux.md        Generated cheat sheet for tmux.
├── zsh.md         Generated cheat sheet for zsh, the login shell (abbreviations pulled from modules/zsh/abbreviations.list, plus the modules/bin/ scripts).
├── workflows.md   Hand-written how-tos that combine shortcuts (not generated, no src/ file).
└── src/           Hand-written sources (`key | action` lines). Edit these, not the generated .md files.
    ├── claude.txt
    ├── neovim.txt
    ├── tmux.txt
    └── zsh.txt
```
