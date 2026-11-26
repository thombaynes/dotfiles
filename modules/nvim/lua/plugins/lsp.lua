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
        -- Mason's ruby-lsp has a hardcoded shebang for whichever Ruby was active when it was installed (it once
        -- ended up on truffleruby), so it ignores the project's .ruby-version. Prefer, in order:
        --   1. `bundle exec ruby-lsp` when the project's Gemfile.lock has ruby-lsp
        --   2. `rbenv exec ruby-lsp` when the project's rbenv Ruby has the ruby-lsp gem installed
        --   3. Mason's ruby-lsp as a last resort
        -- Everything runs with cwd = root_dir so rbenv resolves the project's .ruby-version.
        cmd = function(dispatchers, config)
          local root = config.root_dir
          local cmd = { "ruby-lsp" }
          local lock = root and (root .. "/Gemfile.lock")
          if lock and vim.fn.filereadable(lock) == 1 and table.concat(vim.fn.readfile(lock), "\n"):find("ruby-lsp", 1, true) then
            cmd = { "bundle", "exec", "ruby-lsp" }
          elseif root and vim.fn.executable("rbenv") == 1 and vim.system({ "rbenv", "which", "ruby-lsp" }, { cwd = root }):wait().code == 0 then
            cmd = { "rbenv", "exec", "ruby-lsp" }
          end
          return vim.lsp.rpc.start(cmd, dispatchers, { cwd = config.cmd_cwd or root, env = config.cmd_env, detached = config.detached })
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
          map("<leader>q", vim.diagnostic.setloclist, "Buffer diagnostics to location list")
          map("<leader>rn", vim.lsp.buf.rename, "Rename symbol")
          map("<leader>F", function() vim.lsp.buf.format({ bufnr = args.buf }) end, "Format buffer")
          map("<C-k>", vim.lsp.buf.signature_help, "Signature help")
          map("<leader>i", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = args.buf }), { bufnr = args.buf })
          end, "Toggle inlay hints")

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
