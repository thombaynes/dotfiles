-- Prettier only runs where the project has a prettier config. conform searches upwards from the file,
-- so a config in a service's own folder is picked up in a monorepo.
local prettier_filetypes = {
  "javascript", "javascriptreact", "typescript", "typescriptreact", "json", "jsonc", "css",
}

local formatters_by_ft = {}
for _, ft in ipairs(prettier_filetypes) do
  formatters_by_ft[ft] = { "prettier" }
end

-- xmllint ships with macOS
formatters_by_ft.xml = { "xmllint" }

return {
  "stevearc/conform.nvim",
  event = "BufWritePre",
  cmd = "ConformInfo",
  -- By hand, fall back to the LSP where there is no formatter: ruby_lsp runs standardrb (same as its format on save, see lsp.lua)
  keys = { { "<leader>f", function() require("conform").format({ lsp_format = "fallback" }) end, desc = "Format file" } },
  opts = {
    formatters_by_ft = formatters_by_ft,
    formatters = { prettier = { require_cwd = true } },
    format_on_save = { timeout_ms = 2000, lsp_format = "never" },
  },
}
