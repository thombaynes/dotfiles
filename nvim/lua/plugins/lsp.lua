return {
  {
    -- Ships the default server definitions
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "saghen/blink.cmp",
      { "mason-org/mason.nvim", opts = {} },
      {
        "mason-org/mason-lspconfig.nvim",
        opts = {
          ensure_installed = { "ts_ls", "ruby_lsp", "eslint" },
          automatic_enable = false,
        },
      },
    },
    config = function()
      vim.lsp.config("*", { capabilities = require("blink.cmp").get_lsp_capabilities() })

      vim.lsp.config("ruby_lsp", {
        -- Mason's ruby-lsp runs on whichever Ruby is on PATH. When the project's Gemfile.lock has ruby-lsp, run
        -- it through bundler instead so it uses the project's own (rbenv-pinned) Ruby and gem versions.
        cmd = function(dispatchers, config)
          local cmd = { "ruby-lsp" }
          local lock = config.root_dir and (config.root_dir .. "/Gemfile.lock")
          if lock and vim.fn.filereadable(lock) == 1 and table.concat(vim.fn.readfile(lock), "\n"):find("ruby-lsp", 1, true) then
            cmd = { "bundle", "exec", "ruby-lsp" }
          end
          return vim.lsp.rpc.start(cmd, dispatchers, { cwd = config.cmd_cwd, env = config.cmd_env, detached = config.detached })
        end,
        init_options = {
          formatter = "standard",
          linters = { "standard" },
        },
      })

      -- eslint only starts where the project has an eslint config
      vim.lsp.enable({ "ts_ls", "ruby_lsp", "eslint" })

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
}
