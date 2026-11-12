return {
  -- Needs the fzf brew package (see packages/Brewfile)
  "junegunn/fzf",
  dependencies = { "junegunn/fzf.vim" },
  cmd = { "FZF", "Files", "Rg", "Buffers" },
  keys = { { "<leader>p", "<cmd>FZF<cr>", desc = "Find files" } },
}
