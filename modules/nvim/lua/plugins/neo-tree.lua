return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  keys = { { "<leader>e", "<cmd>Neotree toggle reveal<cr>", desc = "Toggle file tree" } },
  config = function(_, opts)
    require("neo-tree").setup(opts)

    -- Tint the sidebar per source so you can tell the modes apart at a glance. Each tint is the Normal background
    -- nudged towards a colour, so it adapts to the colourscheme.
    local tints = {
      filesystem = nil, -- browse: leave the plain background
      buffers = { 0, 40, 90 }, -- blue
      git_status = { 90, 40, 0 }, -- orange
    }
    local function blend(bg, tint, amount)
      local function chan(shift) return math.floor(((bg >> shift) & 0xff) * (1 - amount) + tint[shift == 16 and 1 or shift == 8 and 2 or 3] * amount) end
      return (chan(16) << 16) | (chan(8) << 8) | chan(0)
    end
    local function define_tints()
      local bg = vim.api.nvim_get_hl(0, { name = "Normal", link = false }).bg or 0x1e1e2e
      for source, tint in pairs(tints) do
        local colour = blend(bg, tint, 0.35)
        vim.api.nvim_set_hl(0, "NeoTreeTint_" .. source, { bg = colour })
      end
    end
    define_tints()
    vim.api.nvim_create_autocmd("ColorScheme", { callback = define_tints })

    require("neo-tree.events").subscribe({
      event = "neo_tree_buffer_enter",
      handler = function()
        local source = vim.b.neo_tree_source
        if source and tints[source] then
          local group = "NeoTreeTint_" .. source
          vim.wo.winhighlight = ("Normal:%s,NormalNC:%s,EndOfBuffer:%s,SignColumn:%s,CursorLine:NeoTreeCursorLine"):format(group, group, group, group)
        end
      end,
    })
  end,
  opts = {
    -- Quit nvim when the tree is the last window left, e.g. after :wq on the final file
    close_if_last_window = true,
    -- Tabs across the top of the tree (Files / Buffers / Git) with icons, so the current mode is obvious
    source_selector = {
      winbar = true,
      sources = {
        { source = "filesystem", display_name = " 󰉓 Files " },
        { source = "buffers", display_name = " 󰈙 Buffers " },
        { source = "git_status", display_name = " 󰊢 Git " },
      },
    },
    -- Replace the plain "GIT STATUS for <dir>" header with a git icon
    git_status = {
      components = {
        name = function(config, node, state)
          local result = require("neo-tree.sources.git_status.components").name(config, node, state)
          if node.type == "directory" and node:get_depth() == 1 then
            result.text = result.text:gsub("^GIT STATUS", "󰊢 Git status")
          end
          return result
        end,
      },
    },
    window = {
      width = 32,
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
