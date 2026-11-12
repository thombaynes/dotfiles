return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "olimorris/neotest-rspec",
    "marilari88/neotest-vitest",
  },
  keys = {
    { "<leader>t", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run spec file" },
    { "<leader>s", function() require("neotest").run.run() end, desc = "Run nearest spec" },
    { "<leader>l", function() require("neotest").run.run_last() end, desc = "Run last spec" },
    { "<leader>a", function() require("neotest").run.run(vim.fn.getcwd()) end, desc = "Run all specs" },
    { "<leader>o", function() require("neotest").output.open({ enter = true }) end, desc = "Spec output" },
    { "<leader>S", function() require("neotest").summary.toggle() end, desc = "Spec summary" },
  },
  config = function()
    require("neotest").setup({
      adapters = { require("neotest-rspec"), require("neotest-vitest") },
    })
  end,
}
