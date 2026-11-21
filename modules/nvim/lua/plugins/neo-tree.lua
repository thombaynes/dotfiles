return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  keys = { { "<leader>e", "<cmd>Neotree toggle reveal<cr>", desc = "Toggle file tree" } },
  opts = {
    -- Quit nvim when the tree is the last window left, e.g. after :wq on the final file
    close_if_last_window = true,
    window = {
      mappings = {
        -- Space is the leader, so don't let the tree claim it (it toggles folders by default). `C` closes a folder.
        ["<space>"] = "none",
      },
    },
    filesystem = {
      -- Show dotfiles by default; gitignored files stay hidden. `H` toggles in the tree.
      filtered_items = { hide_dotfiles = false },
      -- Refresh the tree when files change on disk (new files, renames, git checkouts), not just on edits from inside nvim.
      use_libuv_file_watcher = true,
      -- Expand the folders down to the current file and highlight it, and keep following as you switch buffers.
      follow_current_file = { enabled = true, leave_dirs_open = true },
    },
  },
}
