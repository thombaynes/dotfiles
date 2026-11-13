return {
  -- Needs the fzf brew package (see packages/Brewfile)
  "ibhagwan/fzf-lua",
  cmd = "FzfLua",
  opts = {
    -- Defined in fish/config.fish so fzf and nvim stay in sync; fzf-lua would otherwise pick fd, then find
    files = { cmd = vim.env.FZF_FILES_COMMAND },
  },
  keys = {
    { "<leader>p", function() require("fzf-lua").files() end, desc = "Find files" },
    { "<leader>o", function() require("fzf-lua").lsp_live_workspace_symbols() end, desc = "Find symbols (classes)" },
  },
}
