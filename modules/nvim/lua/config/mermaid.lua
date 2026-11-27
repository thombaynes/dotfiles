-- mermaid-cli
-- `<leader>rp` renders a mermaid diagram with `mmdc`  to a PNG and opens it in Preview.
-- In markdown it renders the ```mermaid block under the cursor
-- Prompts if the cursor is outside one and the file has several.
-- In a `.mmd` / `.mermaid` file it renders the whole buffer.
-- After installing or upgrading mermaid-cli, run `$(brew --prefix mermaid-cli)/libexec/lib/node_modules/@mermaid-js/mermaid-cli/node_modules/.bin/puppeteer browsers install chrome-headless-shell` (brew does not ship the browser).
local group = vim.api.nvim_create_augroup("config_mermaid", { clear = true })

-- Returns the lines of every ```mermaid block as { start = fence line, stop = closing fence line, lines = {...} }
local function find_mermaid_blocks(buf)
  local all = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  local blocks, open = {}, nil
  for i, line in ipairs(all) do
    if not open and line:match("^%s*```+%s*mermaid") then
      open = i
    elseif open and line:match("^%s*```+%s*$") then
      blocks[#blocks + 1] = { start = open, stop = i, lines = vim.list_slice(all, open + 1, i - 1) }
      open = nil
    end
  end
  return blocks
end

local function render_source(lines)
  if vim.fn.executable("mmdc") == 0 then
    vim.notify("mmdc is not installed (brew install mermaid-cli)", vim.log.levels.ERROR)
    return
  end
  local dir = vim.fn.tempname()
  vim.fn.mkdir(dir, "p")
  local src, out = dir .. "/diagram.mmd", dir .. "/diagram.png"
  vim.fn.writefile(lines, src)
  vim.notify("Rendering mermaid diagram...")
  vim.system({ "mmdc", "-i", src, "-o", out, "-b", "white", "-s", "2" }, { text = true }, vim.schedule_wrap(function(result)
    if result.code ~= 0 then
      local err = result.stderr ~= "" and result.stderr or result.stdout
      vim.notify("mmdc failed:\n" .. err, vim.log.levels.ERROR)
      return
    end
    vim.system({ "open", out })
  end))
end

local function render_markdown()
  local blocks = find_mermaid_blocks(0)
  if #blocks == 0 then
    vim.notify("No ```mermaid block in this buffer", vim.log.levels.WARN)
    return
  end
  local row = vim.api.nvim_win_get_cursor(0)[1]
  for _, b in ipairs(blocks) do
    if row >= b.start and row <= b.stop then
      return render_source(b.lines)
    end
  end
  if #blocks == 1 then
    return render_source(blocks[1].lines)
  end
  vim.ui.select(blocks, {
    prompt = "Mermaid block:",
    format_item = function(b) return ("line %d: %s"):format(b.start, b.lines[1] or "") end,
  }, function(choice)
    if choice then render_source(choice.lines) end
  end)
end

vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = "markdown",
  desc = "Mermaid render keymap",
  callback = function(args)
    vim.keymap.set("n", "<leader>rp", render_markdown, { buffer = args.buf, desc = "Mermaid diagram render (Preview)" })
  end,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = group,
  pattern = { "*.mmd", "*.mermaid" },
  desc = "Mermaid render keymap (standalone files)",
  callback = function(args)
    vim.keymap.set("n", "<leader>rp", function()
      render_source(vim.api.nvim_buf_get_lines(args.buf, 0, -1, false))
    end, { buffer = args.buf, desc = "Mermaid diagram render (Preview)" })
  end,
})
