

set runtimepath^=~/.vim runtimepath+=~/.vim/after

let &packpath = &runtimepath

source ~/.vimrc

" Editor options, moved over from ~/.vimrc a section at a time
lua require("config.options")

" Plugin manager (lazy.nvim); plugin specs live in lua/plugins/
lua require("config.lazy")

" Providers I don't use; skip them so :checkhealth stays quiet
let g:loaded_python3_provider = 0
let g:loaded_perl_provider = 0
