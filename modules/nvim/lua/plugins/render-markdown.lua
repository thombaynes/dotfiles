return {
  -- Renders markdown in the buffer (headings, code blocks, tables, checkboxes). Off until `<leader>rm` toggles it.
  -- Needs the markdown and markdown_inline treesitter parsers (see treesitter.lua). Mermaid blocks stay as code;
  -- `<leader>rb` (markdown-preview.lua) draws them in the browser.
  "MeanderingProgrammer/render-markdown.nvim",
  ft = "markdown",
  dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
  opts = { enabled = false },
  keys = {
    { "<leader>rm", "<cmd>RenderMarkdown toggle<cr>", ft = "markdown", desc = "Markdown preview (in buffer)" },
  },
}
