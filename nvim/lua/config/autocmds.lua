-- Autocommands.
local autocmd = vim.api.nvim_create_autocmd
local group = vim.api.nvim_create_augroup("config", { clear = true })

autocmd("VimResized", {
  group = group,
  desc = "Equalise splits when the terminal is resized",
  command = "wincmd =",
})

autocmd({ "FocusGained", "BufEnter" }, {
  group = group,
  desc = "Reload files changed outside nvim (needs focus-events on in tmux)",
  command = "silent! checktime",
})

autocmd("TextYankPost", {
  group = group,
  desc = "Briefly highlight yanked text",
  callback = function() vim.hl.on_yank() end,
})

autocmd("FileType", {
  group = group,
  pattern = "gitcommit",
  desc = "Spell check commit messages (textwidth 72 is already the nvim default)",
  callback = function() vim.opt_local.spell = true end,
})

autocmd("BufReadPost", {
  group = group,
  desc = "Return to the last edit position",
  callback = function(args)
    local line = vim.api.nvim_buf_get_mark(args.buf, '"')[1]
    if line > 1 and line <= vim.api.nvim_buf_line_count(args.buf) then
      pcall(vim.api.nvim_win_set_cursor, 0, { line, 0 })
    end
  end,
})

autocmd("BufWritePre", {
  group = group,
  pattern = "*.*",
  desc = "Strip trailing whitespace on save",
  callback = function()
    local view = vim.fn.winsaveview()
    vim.cmd([[keeppatterns %s/\s\+$//e]])
    vim.fn.winrestview(view)
  end,
})
