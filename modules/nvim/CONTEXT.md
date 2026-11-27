# Neovim config

My Neovim configuration (symlinked to `~/.config/nvim`): a lazy.nvim setup.

## Keep it VERY FAST

Speed is a priority. Key repeat is set very fast (15ms), and holding a key must never leave nvim behind: if keystrokes queue up and keep landing after release, that is a bug. Treat anything that runs per keystroke or per cursor move as suspect: autocommands on `CursorMoved`, `TextChanged` or `InsertCharPre`, per-edit plugin work, and anything that spawns a process or waits on one.

- **Measuring:** drive a real nvim in a pty with `x` sent every 15ms and compare when the last key is processed (use `vim.on_key` to timestamp) with when the last one was sent. Bare `nvim -u NONE` has 0ms of lag, and so should this config. Bisect by removing plugin files from a copy of the config, or by setting options with `-c`.
- **Past culprit, the 20ms/15ms problem:** with `clipboard=unnamedplus`, nvim spawns `pbcopy` for every register write, and each spawn takes about 20ms. Holding `x` repeats every 15ms, so keys queued faster than they ran and kept landing for over a second after release. `lua/config/clipboard.lua` fixed that.

**GIVE BRIEF BUT NOT COMPLETE DESCRIPTIONS BELOW. NO KEYMAPS: they live in `shortcuts/neovim.md`.**
```
nvim/
├── CONTEXT.md           This file.
├── setup.sh             Symlinks this folder to `~/.config/nvim`.
├── init.lua             Entry point. Loads config/options, clipboard, keymaps and autocmds, then lazy.nvim.
├── lazy-lock.json       lazy.nvim's pinned plugin versions. Written by `:Lazy`; commit it, don't edit it.
└── lua/
    ├── config/          Editor behaviour that isn't plugin-specific.
    │   ├── options.lua    Sets mapleader first, then vim options.
    │   ├── clipboard.lua  Shares the system clipboard through a debounced pbcopy provider. See "Keep it VERY FAST" above.
    │   ├── keymaps.lua    Global key mappings, each with a desc for which-key.
    │   ├── autocmds.lua   Autocommands: resize splits, spell check commits, restore cursor, trim trailing whitespace, highlight yanks, reload files changed outside nvim.
    │   ├── helm.lua       Renders a Helm chart with `helm template` into a scratch split. Finds the chart by walking up to `Chart.yaml`, and passes a `values-*.yaml` from beside it (prompts if several). Needs `helm`.
    │   ├── mermaid.lua    Renders a mermaid block (or a whole `.mmd` file) to a PNG with `mmdc` and opens it in Preview. Needs mermaid-cli, plus a one-off headless Chrome install (see the file header).
    │   └── lazy.lua       Bootstraps lazy.nvim and imports every spec in lua/plugins/.
    └── plugins/         One lazy.nvim spec per file; a plugin's own keys live beside it.
        ├── beacon.lua     Flashes the cursor line after a jump.
        ├── blink.lua      blink.cmp completion. Off by default. Enable with <leader>c.
        ├── conform.lua    Formatting on save. Prettier only where the project has a prettier config (searches upwards); `xmllint` for XML. Ruby LSP used on save.
        ├── dropbar.lua    Breadcrumbs in the winbar (symbols only, from LSP with a treesitter fallback).
        ├── fugitive.lua   Git stuff via vim-fugitive, loaded on its commands.
        ├── fzf.lua        fzf-lua for file, text, buffer, recent-file and symbol lookups. See "fzf-lua" below.
        ├── gitsigns.lua   A bunch of useful git stuff in the window.
        ├── lualine.lua    Statusline (replaces airline).
        ├── lsp.lua        nvim-lspconfig with mason and blink's capabilities. See LSP section below.
        ├── neo-tree.lua   File tree with Files / Buffers / Git sources, each tinted differently. Follows the current file and watches the disk. Some customization for speed.
        ├── neotest.lua    neotest with neotest-rspec and neotest-vitest.
        ├── markdown-preview.lua  markdown-preview.nvim: live browser preview that renders mermaid. Needs node for its build step.
        ├── render-markdown.lua   render-markdown.nvim: in-buffer rendering. Off until toggled; mermaid stays as code.
        ├── tmux-navigator.lua  Moves between nvim splits and tmux panes. Pairs with the `is_vim` bindings in `modules/tmux/.tmux.conf`.
        ├── tokyonight.lua Colourscheme for nvim.
        ├── treesitter.lua Parsers for Ruby, JS/TS, JSON (needed by neotest) and markdown (needed by render-markdown), and treesitter highlighting for the non-markdown ones (nvim starts it for markdown itself). Needs `tree-sitter-cli` (Brewfile) to compile parsers.
        └── which-key.lua  Popup of available keys after a prefix, plus a buffer-local keymap list.
```

## LSP

Language servers come from `lua/plugins/lsp.lua`, installed by mason (`ensure_installed`) and enabled explicitly with `vim.lsp.enable`. Every server gets blink.cmp's capabilities. Supported languages:

- **Ruby:** `ruby_lsp` with standardrb for formatting and linting. Mason's ruby-lsp has a hardcoded shebang for whichever Ruby was active when it was installed, so the `cmd` is overridden to pick, in order: `bundle exec ruby-lsp` when the project's `Gemfile.lock` has ruby-lsp, `rbenv exec ruby-lsp` when the project's rbenv Ruby has the gem, then mason's copy. It runs with the project root as cwd so rbenv sees the `.ruby-version`.
- **JavaScript / TypeScript (including JSX and TSX):** `ts_ls`, plus `eslint` where the project has an eslint config. Prettier formats on save via conform, not the LSP.
- **Lua:** `lua_ls`, set up for LuaJIT with the `vim` global and the nvim runtime as its library. Telemetry is off.

## fzf-lua

fzf-lua (`lua/plugins/fzf.lua`) is a Lua front end that drives the `fzf` binary (Brewfile) inside nvim. It is loaded lazily, on `:FzfLua` or its keys.

- **File listing:** `files.cmd = vim.env.FZF_DEFAULT_COMMAND`. The shell's `fzf` runs with that, so the two stay in sync; change it in `modules/zsh/.zprofile` only.
- **Why an env var:** nvim runs commands through `sh`, which can't see shell aliases or functions, so only an exported variable reaches it. nvim has to be started from a shell that has it (zsh does).
- **Fallback:** if the variable is unset, `files.cmd` is nil and fzf-lua picks its own tool: `fd`, then `rg`, then `find`.
- **Text search:** uses `rg`. The preview opens below the list rather than beside it, because side by side the results are squeezed and the matching text is cut off.
- **Symbol search:** the workspace symbol lookup asks the LSP server (ruby-lsp for Ruby) for symbols matching what you type, so it uses neither `rg` nor `fd`. With no LSP client attached it reports "LSP: no client attached".
- **`:checkhealth fzf-lua`** looks for `fd`, `fdfind` or `find`, never `rg`. Without `fd` it falls back to BSD `find` and reports `find: illegal option -- --` because `find --version` isn't valid there. That is cosmetic, and `fd` is in the Brewfile to silence it.

Keyboard shortcuts are documented in `shortcuts/neovim.md` at the repo root.
