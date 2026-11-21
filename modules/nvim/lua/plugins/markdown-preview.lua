return {
  -- Live preview in the browser, scroll-synced, with mermaid support. Needs node (nodenv) for its build step
  "iamcco/markdown-preview.nvim",
  ft = "markdown",
  cmd = { "MarkdownPreview", "MarkdownPreviewStop", "MarkdownPreviewToggle" },
  build = "cd app && npm install",
  keys = {
    { "<leader>mo", "<cmd>MarkdownPreviewToggle<cr>", ft = "markdown", desc = "Markdown open (in browser)" },
  },
}
