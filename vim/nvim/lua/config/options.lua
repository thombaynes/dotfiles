-- Editor options, moved over from ~/.vimrc one section at a time.
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
