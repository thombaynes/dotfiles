-- Editor options, moved over from ~/.vimrc one section at a time.

-- Must be set before lazy.nvim loads any plugin, and before ~/.vimrc defines its leader maps
vim.g.mapleader = " "

local opt = vim.opt

-- Search: ignore case unless the pattern has a capital. hlsearch and incsearch are already on in nvim.
opt.ignorecase = true
opt.smartcase = true

-- Briefly jump to the matching bracket when one is typed (tenths of a second)
opt.showmatch = true
opt.matchtime = 2

-- Indentation: two spaces per level, never literal tabs. smarttab, autoindent and wrap are already on in nvim.
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.smartindent = true

-- Wrap long lines at word boundaries instead of mid-word
opt.linebreak = true

-- Files: no swap files or write-time backups, since everything is in git anyway. 'backup' is already off in nvim.
opt.swapfile = false
opt.writebackup = false

-- Display: show tabs and trailing whitespace, hybrid line numbers, a fold column for margin, context around the cursor
opt.list = true
opt.listchars = { tab = "• ", trail = "•", extends = "»", precedes = "«" }
opt.number = true
opt.relativenumber = true
opt.foldcolumn = "1"
opt.scrolloff = 7
opt.cmdheight = 2

-- Behaviour: quicker mapped-key timeout, h/l and the arrows wrap lines, shell-style command completion
opt.timeoutlen = 500
opt.whichwrap:append("<,>,h,l")
opt.wildmode = { "longest:full", "full" }

-- Yank and paste through the system clipboard (on macOS + and * are the same pasteboard)
opt.clipboard = "unnamedplus"

vim.cmd.colorscheme("desert")
