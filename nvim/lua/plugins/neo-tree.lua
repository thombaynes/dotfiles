return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  keys = { { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Toggle file tree" } },
  opts = {
    filesystem = {
      -- Show dotfiles by default; gitignored files stay hidden. `H` toggles in the tree.
      filtered_items = { hide_dotfiles = false },
      -- Refresh the tree when files change on disk (new files, renames, git checkouts), not just on edits from inside nvim.
      use_libuv_file_watcher = true,
    },
  },
}
