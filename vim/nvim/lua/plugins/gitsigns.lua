return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    -- Show the git state of each line in the sign column: added, changed, removed.
    signcolumn = true,
    -- Also tint the line numbers, so the markers stay visible next to `relativenumber`.
    numhl = true,
    -- Show who last changed the current line (author, age, summary) as virtual text.
    current_line_blame = true,
    current_line_blame_opts = { delay = 300 },
    on_attach = function(bufnr)
      local gs = require("gitsigns")
      local function map(lhs, rhs, desc)
        vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = desc })
      end

      map("]c", function() gs.nav_hunk("next") end, "Next git hunk")
      map("[c", function() gs.nav_hunk("prev") end, "Previous git hunk")
      map("<leader>hp", gs.preview_hunk, "Preview hunk")
      map("<leader>hb", gs.toggle_current_line_blame, "Toggle line blame")
    end,
  },
}
