" Editor config. Loaded first so mapleader is set before plugins define their keys.
lua require("config.options")
lua require("config.keymaps")
lua require("config.autocmds")

" Plugin manager (lazy.nvim); plugin specs live in lua/plugins/
lua require("config.lazy")

" Providers I don't use; skip them so :checkhealth stays quiet
let g:loaded_python3_provider = 0
let g:loaded_perl_provider = 0
