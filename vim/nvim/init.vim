set runtimepath^=~/.vim runtimepath+=~/.vim/after

let &packpath = &runtimepath

" Editor config, moved over from ~/.vimrc a section at a time.
" Loaded before the vimrc so mapleader is set when its leader maps are defined.
lua require("config.options")
lua require("config.keymaps")
lua require("config.autocmds")

source ~/.vimrc

" Plugin manager (lazy.nvim); plugin specs live in lua/plugins/
lua require("config.lazy")

" Providers I don't use; skip them so :checkhealth stays quiet
let g:loaded_python3_provider = 0
let g:loaded_perl_provider = 0
