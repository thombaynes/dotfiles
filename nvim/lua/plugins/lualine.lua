return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  -- The mode is shown in the statusline, so hide the duplicate in the command line (see config/options.lua)
  opts = {
    sections = {
      -- No branch or diff (gitsigns covers the changes), and nothing in lualine_x (encoding, fileformat, filetype)
      lualine_b = { "diagnostics" },
      lualine_x = {},
    },
  },
}
