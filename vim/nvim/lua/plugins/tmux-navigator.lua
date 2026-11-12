return {
  -- Pairs with the is_vim bindings in tmux/.tmux.conf
  "christoomey/vim-tmux-navigator",
  cmd = { "TmuxNavigateLeft", "TmuxNavigateDown", "TmuxNavigateUp", "TmuxNavigateRight" },
  keys = {
    { "<C-h>", "<cmd>TmuxNavigateLeft<cr>", desc = "Window / pane left" },
    { "<C-j>", "<cmd>TmuxNavigateDown<cr>", desc = "Window / pane down" },
    { "<C-k>", "<cmd>TmuxNavigateUp<cr>", desc = "Window / pane up" },
    { "<C-l>", "<cmd>TmuxNavigateRight<cr>", desc = "Window / pane right" },
  },
}
