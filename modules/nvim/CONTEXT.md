# Neovim config

My Neovim configuration (symlinked to `~/.config/nvim`): a lazy.nvim setup.

## Keep it VERY FAST

Speed is a priority. Key repeat is set very fast (15ms), and holding a key must never leave nvim behind: if keystrokes queue up and keep landing after release, that is a bug. Treat anything that runs per keystroke or per cursor move as suspect: autocommands on `CursorMoved`, `TextChanged` or `InsertCharPre`, per-edit plugin work, and anything that spawns a process or waits on one.

- **Measuring:** drive a real nvim in a pty with `x` sent every 15ms and compare when the last key is processed (use `vim.on_key` to timestamp) with when the last one was sent. Bare `nvim -u NONE` has 0ms of lag, and so should this config. Bisect by removing plugin files from a copy of the config, or by setting options with `-c`.
- **Past culprit, the 20ms/15ms problem:** with `clipboard=unnamedplus`, nvim spawns `pbcopy` for every register write, and each spawn takes about 20ms. Holding `x` repeats every 15ms, so keys queued faster than they ran and kept landing for over a second after release. `lua/config/clipboard.lua` fixed that.

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
    │   ├── helm.lua       Helm rendering achieved via `helm template`.
    │   └── lazy.lua       Bootstraps lazy.nvim and imports every spec in lua/plugins/.
    └── plugins/         One lazy.nvim spec per file; a plugin's own keys live beside it.
        ├── beacon.lua     Flashes the cursor line after a jump.
        ├── blink.lua      Auto-complete via blink.cmp. Off by default.
        ├── conform.lua    Prettier on save and `<leader>f`. Needs formatting config per file type.
        ├── dropbar.lua    Breadcrumbs in the winbar (symbols only, from LSP with a treesitter fallback).
        ├── fugitive.lua   vim-fugitive (`:Git`), loaded on its commands.
        ├── fzf.lua        fzf-lua; `<leader>p` finds files, `<leader>o` live-searches Ruby classes via LSP workspace symbols. See "fzf-lua" below.
        ├── gitsigns.lua   Git signs in the gutter, line blame, and `<leader>h` hunk maps.
        ├── lualine.lua    Statusline (replaces airline).
        ├── lsp.lua        nvim-lspconfig with mason (ts_ls, ruby_lsp, eslint), `gd`/`gD`, and Ruby format on save.
        ├── neo-tree.lua   File tree; `<leader>e` toggles it and dotfiles show by default.
        ├── neotest.lua    neotest with neotest-rspec and neotest-vitest.
        ├── markdown-preview.lua  markdown-preview.nvim; `<leader>rb` opens a live browser preview (renders mermaid). Needs node for its build.
        ├── render-markdown.lua   render-markdown.nvim; `<leader>rm` toggles in-buffer rendering (off by default; mermaid stays as code).
        ├── tmux-navigator.lua  `<C-h/j/k/l>` moves between nvim splits and tmux panes.
        ├── tokyonight.lua Colourscheme for nvim.
        ├── treesitter.lua Parsers for Ruby, JS/TS, JSON (needed by neotest) and markdown (needed by render-markdown), and treesitter highlighting for the non-markdown ones (nvim starts it for markdown itself).
        └── which-key.lua  Learn available shortucts - Popup of available keys after `<leader>?`.
```

## fzf-lua

fzf-lua (`lua/plugins/fzf.lua`) is a Lua front end that drives the `fzf` binary (Brewfile) inside nvim. It is loaded lazily, on `:FzfLua` or its two keys.

- **`<leader>p`** runs `files()`. The listing command is `files.cmd = vim.env.FZF_DEFAULT_COMMAND`, which `modules/zsh/.zprofile` exports as `rg --files --hidden -G .git`. The shell's `fzf` runs the same variable, so the two stay in sync; change it in the shell config only.
- **Why an env var:** nvim runs commands through `sh`, which can't see shell aliases or functions, so only an exported variable reaches it. nvim has to be started from a shell that has it (zsh does).
- **Fallback:** if the variable is unset, `files.cmd` is nil and fzf-lua picks its own tool: `fd`, then `rg`, then `find`.
- **`<leader>o`** runs `lsp_live_workspace_symbols()`. It asks the LSP server (ruby-lsp for Ruby) for symbols matching what you type, so it uses neither `rg` nor `fd`. With no LSP client attached it reports "LSP: no client attached".
- **`:checkhealth fzf-lua`** looks for `fd`, `fdfind` or `find`, never `rg`. Without `fd` it falls back to BSD `find` and reports `find: illegal option -- --` because `find --version` isn't valid there. That is cosmetic, and `fd` is in the Brewfile to silence it.

Keyboard shortcuts are documented in `shortcuts/neovim.md` at the repo root.
