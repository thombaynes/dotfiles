# Neovim config

My Neovim configuration (symlinked to `~/.config/nvim`): a lazy.nvim setup.

```
nvim/
├── CONTEXT.md           This file.
├── setup.sh             Symlinks this folder to `~/.config/nvim`.
├── init.vim             Entry point. Loads config/options, keymaps and autocmds, then lazy.nvim.
├── lazy-lock.json       lazy.nvim's pinned plugin versions. Written by `:Lazy`; commit it, don't edit it.
└── lua/
    ├── config/          Editor behaviour that isn't plugin-specific.
    │   ├── options.lua    Sets mapleader first, then vim options and the colourscheme.
    │   ├── keymaps.lua    Global key mappings, each with a desc for which-key.
    │   ├── autocmds.lua   Autocommands: resize splits, spell check commits, restore cursor, trim trailing whitespace, reload files changed outside nvim.
    │   └── lazy.lua       Bootstraps lazy.nvim and imports every spec in lua/plugins/.
    └── plugins/         One lazy.nvim spec per file; a plugin's own keys live beside it.
        ├── fugitive.lua   vim-fugitive (`:Git`), loaded on its commands.
        ├── fzf.lua        fzf and fzf.vim; `<leader>p` finds files.
        ├── gitsigns.lua   Git signs in the gutter, line blame, and `<leader>h` hunk maps.
        ├── lualine.lua    Statusline (replaces airline).
        ├── lsp.lua        nvim-lspconfig with mason (ts_ls, ruby_lsp), `gd`/`gD`, and Ruby format on save.
        ├── neo-tree.lua   File tree; `<leader>e` toggles it and dotfiles show by default.
        ├── neotest.lua    neotest with neotest-rspec; `<leader>t/s/l/a` run file, nearest, last, all specs.
        ├── tmux-navigator.lua  `<C-h/j/k/l>` moves between nvim splits and tmux panes.
        ├── treesitter.lua Ruby parser (needed by neotest) and Ruby highlighting.
        └── which-key.lua  Popup of available keys after a prefix; `<leader>?` shows the buffer's keymaps.
```

Keyboard shortcuts are documented in `shortcuts/neovim.md` at the repo root.
