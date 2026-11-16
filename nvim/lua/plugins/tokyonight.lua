return {
  -- Colourscheme. Loaded at startup and ahead of other plugins so everything else picks up its highlight groups.
  -- Variants: storm (default), moon, night, day. Set `style` below to switch.
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  opts = { style = "moon" },
  config = function(_, opts)
    require("tokyonight").setup(opts)
    vim.cmd.colorscheme("tokyonight")
  end,
}
