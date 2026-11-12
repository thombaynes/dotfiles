-- Editor options, moved over from ~/.vimrc one section at a time.
local opt = vim.opt

-- Search: ignore case unless the pattern has a capital. hlsearch and incsearch are already on in nvim.
opt.ignorecase = true
opt.smartcase = true

-- Briefly jump to the matching bracket when one is typed (tenths of a second)
opt.showmatch = true
opt.matchtime = 2
