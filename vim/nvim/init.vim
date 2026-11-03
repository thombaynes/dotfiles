

set runtimepath^=~/.vim runtimepath+=~/.vim/after

let &packpath = &runtimepath

source ~/.vimrc

" Plugin manager (lazy.nvim); plugin specs live in lua/plugins/
lua require("config.lazy")
