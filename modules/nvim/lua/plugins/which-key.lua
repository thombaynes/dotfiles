return {
  -- Pops up the available keys after pressing <leader> (or any prefix) and pauses.
  "folke/which-key.nvim",
  event = "VeryLazy",
  keys = { { "<leader>?", function() require("which-key").show({ global = false }) end, desc = "Buffer keymaps" } },
  opts = {},
}
