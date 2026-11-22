-- Yank and paste through the system clipboard (on macOS + and * are the same pasteboard).
--
-- Why a custom provider: nvim's built-in one spawns pbcopy for every register write, and each spawn takes
-- about 20ms. Holding x repeats every 15ms, so keys queued faster than they ran and kept landing for over a
-- second after release. This provider debounces the writes: a burst costs a single pbcopy.
vim.opt.clipboard = "unnamedplus"

local pending -- { lines, regtype } not yet written to the pasteboard
local timer = vim.uv.new_timer()

local function flush(wait)
  if not pending then
    return
  end
  local text = table.concat(pending[1], "\n")
  pending = nil
  local job = vim.system({ "pbcopy" }, { stdin = text })
  if wait then
    job:wait()
  end
end

local function copy(lines, regtype)
  pending = { lines, regtype }
  timer:start(100, 0, vim.schedule_wrap(function() flush() end))
end

local function paste()
  if pending then
    return pending
  end
  return { vim.fn.systemlist("pbpaste"), "" }
end

vim.g.clipboard = {
  name = "pbcopy-debounced",
  copy = { ["+"] = copy, ["*"] = copy },
  paste = { ["+"] = paste, ["*"] = paste },
  cache_enabled = 1, -- lets nvim restore the register type (line/block) that pbpaste can't carry
}

-- Don't lose a copy made in the last 100ms when quitting
vim.api.nvim_create_autocmd("VimLeavePre", { callback = function() timer:stop(); flush(true) end })
