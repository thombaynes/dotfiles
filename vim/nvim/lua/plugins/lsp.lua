return {
  {
    -- Ships the default server definitions
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "williamboman/mason.nvim", opts = {} },
      {
        "williamboman/mason-lspconfig.nvim",
        opts = {
          ensure_installed = { "ts_ls", "ruby_lsp" },
          automatic_enable = false,
        },
      },
    },
    config = function()
      vim.lsp.config("ruby_lsp", {
        init_options = {
          formatter = "standard",
          linters = { "standard" },
        },
      })

      vim.lsp.enable({ "ts_ls", "ruby_lsp" })

      -- Extras on top of the nvim 0.11+ defaults (K, grn, gra, grr, gri, gO, [d, ]d; see :help lsp-defaults).
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local function map(lhs, rhs, desc)
            vim.keymap.set("n", lhs, rhs, { buffer = args.buf, desc = desc })
          end

          map("gd", vim.lsp.buf.definition, "Go to definition")
          map("gD", vim.lsp.buf.type_definition, "Go to type definition")
          map("<leader>d", vim.diagnostic.open_float, "Line diagnostics")

          -- Replaces ALE's fix_on_save for Ruby (standardrb via ruby-lsp)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client and client.name == "ruby_lsp" then
            vim.api.nvim_create_autocmd("BufWritePre", {
              buffer = args.buf,
              callback = function() vim.lsp.buf.format({ bufnr = args.buf, id = client.id }) end,
            })
          end
        end,
      })
    end,
  },
  {
    -- Pops up the available keys after pressing <leader> (or any prefix) and pauses.
    "folke/which-key.nvim",
    event = "VeryLazy",
    keys = { { "<leader>?", function() require("which-key").show({ global = false }) end, desc = "Buffer keymaps" } },
    opts = {},
  },
}
