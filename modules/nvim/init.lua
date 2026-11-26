-- Editor config. Loaded first so mapleader is set before plugins define their keys.
require("config.options")
require("config.clipboard")
require("config.keymaps")
require("config.autocmds")
require("config.helm")

-- Plugin manager (lazy.nvim); plugin specs live in lua/plugins/
require("config.lazy")

-- Providers I don't use; skip them so :checkhealth stays quiet
vim.g.loaded_python3_provider = 0
vim.g.loaded_perl_provider = 0
