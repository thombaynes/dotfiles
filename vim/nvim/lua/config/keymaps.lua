-- Key mappings, moved over from ~/.vimrc. Plugin keys live next to their plugin in lua/plugins/.
local map = vim.keymap.set

map("n", "<leader>-", "<C-w>_<C-w>|", { desc = "Maximise window" })
map("n", "<leader>=", "<C-w>=", { desc = "Equalise windows" })
map("n", "<leader>ss", "<cmd>setlocal spell!<cr>", { desc = "Toggle spell check" })
