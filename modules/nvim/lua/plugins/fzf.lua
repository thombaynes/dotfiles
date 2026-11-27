return {
  -- Needs the fzf brew package (see packages/Brewfile)
  "ibhagwan/fzf-lua",
  cmd = "FzfLua",
  opts = {
    -- Defined in zsh/.zprofile so fzf and nvim stay in sync; fzf-lua would otherwise pick fd, then find
    files = { cmd = vim.env.FZF_DEFAULT_COMMAND },
    -- Preview below the list, not beside it: side by side the results are squeezed and the matching text is cut off
    grep = { winopts = { preview = { layout = "vertical", vertical = "down:50%" } } },
  },
  keys = {
    { "<leader>p", function() require("fzf-lua").files() end, desc = "Find files" },
    { "<leader>/", function() require("fzf-lua").live_grep() end, desc = "Search project text" },
    { "<leader>*", function() require("fzf-lua").grep_cword() end, desc = "Search project for word under cursor" },
    { "<leader>b", function() require("fzf-lua").buffers() end, desc = "Find open buffers" },
    { "<leader>.", function() require("fzf-lua").oldfiles() end, desc = "Find recent files" },
    { "<leader>'", function() require("fzf-lua").resume() end, desc = "Resume last fzf search" },
    { "<leader>o", function() require("fzf-lua").lsp_live_workspace_symbols() end, desc = "Find symbols (classes)" },
  },
}
