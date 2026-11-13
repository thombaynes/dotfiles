return {
  -- Needs the tree-sitter-cli brew package (see packages/Brewfile) to compile parsers
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter").install({ "ruby", "javascript", "typescript", "tsx", "json" })

    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "ruby", "javascript", "javascriptreact", "typescript", "typescriptreact", "json" },
      desc = "Highlight and indent with treesitter",
      callback = function(args)
        local lang = vim.treesitter.language.get_lang(args.match)
        local ok, err = pcall(vim.treesitter.start)
        if not ok then
          vim.notify(("treesitter: failed to start for %s: %s"):format(lang, err), vim.log.levels.WARN)
        elseif not vim.treesitter.query.get(lang, "highlights") then
          -- start() succeeds without a query and just highlights nothing; fix with :TSInstall! <lang>
          vim.notify(("treesitter: no highlights query for %s (try :TSInstall! %s)"):format(lang, lang), vim.log.levels.WARN)
        end
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })
  end,
}
