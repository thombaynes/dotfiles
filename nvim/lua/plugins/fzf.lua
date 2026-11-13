return {
  -- Needs the fzf brew package (see packages/Brewfile)
  "ibhagwan/fzf-lua",
  cmd = "FzfLua",
  opts = {},
  keys = {
    { "<leader>p", function() require("fzf-lua").files() end, desc = "Find files" },
    { "<leader>o", function() require("fzf-lua").lsp_live_workspace_symbols() end, desc = "Find symbols (classes)" },
  },
}
