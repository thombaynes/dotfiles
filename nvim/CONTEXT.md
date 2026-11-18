# Neovim config

My Neovim configuration (symlinked to `~/.config/nvim`): a lazy.nvim setup.

```
nvim/
├── CONTEXT.md           This file.
├── setup.sh             Symlinks this folder to `~/.config/nvim`.
├── init.lua             Entry point. Loads config/options, keymaps and autocmds, then lazy.nvim.
├── lazy-lock.json       lazy.nvim's pinned plugin versions. Written by `:Lazy`; commit it, don't edit it.
└── lua/
    ├── config/          Editor behaviour that isn't plugin-specific.
    │   ├── options.lua    Sets mapleader first, then vim options.
    │   ├── keymaps.lua    Global key mappings, each with a desc for which-key.
    │   ├── autocmds.lua   Autocommands: resize splits, spell check commits, restore cursor, trim trailing whitespace, highlight yanks, reload files changed outside nvim.
    │   └── lazy.lua       Bootstraps lazy.nvim and imports every spec in lua/plugins/.
    └── plugins/         One lazy.nvim spec per file; a plugin's own keys live beside it.
        ├── beacon.lua     Flashes the cursor line after a jump.
        ├── blink.lua      blink.cmp completion, off until `<leader>c` toggles it; `<C-space>` opens the menu by hand.
        ├── conform.lua    Prettier on save and `<leader>f`, only where a prettier config exists above the file.
        ├── dropbar.lua    Breadcrumbs in the winbar (symbols only, from LSP with a treesitter fallback).
        ├── fugitive.lua   vim-fugitive (`:Git`), loaded on its commands.
        ├── fzf.lua        fzf-lua; `<leader>p` finds files, `<leader>o` live-searches Ruby classes via LSP workspace symbols. See "fzf-lua" below.
        ├── gitsigns.lua   Git signs in the gutter, line blame, and `<leader>h` hunk maps.
        ├── lualine.lua    Statusline (replaces airline).
        ├── lsp.lua        nvim-lspconfig with mason (ts_ls, ruby_lsp, eslint), `gd`/`gD`, and Ruby format on save.
        ├── neo-tree.lua   File tree; `<leader>e` toggles it and dotfiles show by default.
        ├── neotest.lua    neotest with neotest-rspec and neotest-vitest; `<leader>t/s/l/a` run file, nearest, last, all specs.
        ├── markdown-preview.lua  markdown-preview.nvim; `<leader>mo` opens a live browser preview (renders mermaid). Needs node for its build.
        ├── render-markdown.lua   render-markdown.nvim; `<leader>mp` toggles in-buffer rendering (off by default; mermaid stays as code).
        ├── tmux-navigator.lua  `<C-h/j/k/l>` moves between nvim splits and tmux panes.
        ├── tokyonight.lua Colourscheme (moon variant); loaded first and sets `colorscheme tokyonight`.
        ├── treesitter.lua Parsers for Ruby, JS/TS, JSON (needed by neotest) and markdown (needed by render-markdown), and treesitter highlighting for the non-markdown ones (nvim starts it for markdown itself).
        └── which-key.lua  Popup of available keys after a prefix; `<leader>?` shows the buffer's keymaps.
```

## fzf-lua

fzf-lua (`lua/plugins/fzf.lua`) is a Lua front end that drives the `fzf` binary (Brewfile) inside nvim. It is loaded lazily, on `:FzfLua` or its two keys.

- **`<leader>p`** runs `files()`. The listing command is `files.cmd = vim.env.FZF_DEFAULT_COMMAND`, which `zsh/.zprofile` exports as `rg --files --hidden --glob '!.git'` (`fish/config.fish` exports the same for fish). The shell's `fzf` runs the same variable, so the two stay in sync; change it in the shell config only.
- **Why an env var:** nvim runs commands through `sh`, which can't see shell aliases or functions, so only an exported variable reaches it. nvim has to be started from a shell that has it (zsh and fish both do).
- **Fallback:** if the variable is unset, `files.cmd` is nil and fzf-lua picks its own tool: `fd`, then `rg`, then `find`.
- **`<leader>o`** runs `lsp_live_workspace_symbols()`. It asks the LSP server (ruby-lsp for Ruby) for symbols matching what you type, so it uses neither `rg` nor `fd`. With no LSP client attached it reports "LSP: no client attached".
- **`:checkhealth fzf-lua`** looks for `fd`, `fdfind` or `find`, never `rg`. Without `fd` it falls back to BSD `find` and reports `find: illegal option -- --` because `find --version` isn't valid there. That is cosmetic, and `fd` is in the Brewfile to silence it.

Keyboard shortcuts are documented in `shortcuts/neovim.md` at the repo root.
