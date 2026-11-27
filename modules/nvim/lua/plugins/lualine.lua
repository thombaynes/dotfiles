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
      -- Relative path; once longer than 40 columns the folders shrink to their first letter (app/models/user/x.rb -> a/m/u/x.rb)
      lualine_c = {
        {
          "filename",
          path = 1,
          fmt = function(name)
            if #name > 40 then
              return vim.fn.pathshorten(name)
            end
            return name
          end,
        },
      },
    },
  },
}
