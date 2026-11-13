return {
  -- Breadcrumbs in the winbar (e.g. Class > method), from LSP symbols with a treesitter fallback
  "Bekaboo/dropbar.nvim",
  event = { "BufReadPost", "BufNewFile" },
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    bar = {
      -- Symbols only: the file path is already in the statusline
      sources = function()
        local sources = require("dropbar.sources")
        return { require("dropbar.utils").source.fallback({ sources.lsp, sources.treesitter }) }
      end,
    },
  },
}
