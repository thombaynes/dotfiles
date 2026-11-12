return {
  -- Needs the tree-sitter-cli brew package (see packages/Brewfile) to compile parsers
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter").install({ "ruby" })

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "ruby",
      desc = "Highlight and indent Ruby with treesitter",
      callback = function()
        pcall(vim.treesitter.start)
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })
  end,
}
