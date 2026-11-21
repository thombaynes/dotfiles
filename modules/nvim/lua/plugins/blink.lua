return {
  "saghen/blink.cmp",
  version = "1.*",
  event = "InsertEnter",
  -- Autocomplete is off until toggled, so a popup never appears unless asked for
  init = function() vim.g.autocomplete = false end,
  keys = { { "<leader>c", function() vim.g.autocomplete = not vim.g.autocomplete; vim.notify("Autocomplete " .. (vim.g.autocomplete and "on" or "off")) end, desc = "Toggle autocomplete" } },
  opts = {
    -- Default preset: <C-space> opens the menu by hand, <C-y> accepts, <C-n>/<C-p> select, <C-e> hides.
    keymap = { preset = "default" },
    completion = {
      -- With autocomplete off the menu only opens via <C-space>
      menu = { auto_show = function() return vim.g.autocomplete end },
    },
  },
}
