-- Helm: `<leader>rh` in a yaml file inside a Helm chart renders it with `helm template` into a split.
-- In templates/ it renders just that template; anywhere else in the chart (e.g. values.yaml) it renders the whole chart.
-- If the chart has per-env `values-*.yaml` next to Chart.yaml, it is passed with -f (you are prompted when there are several).
local group = vim.api.nvim_create_augroup("config_helm", { clear = true })

local function show(result)
  local out = result.code == 0 and result.stdout or (result.stderr ~= "" and result.stderr or result.stdout)
  vim.cmd("botright vnew")
  local buf = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(out, "\n", { trimempty = false }))
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].swapfile = false
  vim.bo[buf].filetype = result.code == 0 and "yaml" or "text"
  vim.bo[buf].modifiable = false
  vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = buf, desc = "Close helm render" })
end

local function render()
  local file = vim.api.nvim_buf_get_name(0)
  local chart_file = vim.fs.find("Chart.yaml", { upward = true, path = vim.fs.dirname(file) })[1]
  if not chart_file then
    vim.notify("Not inside a Helm chart (no Chart.yaml found)", vim.log.levels.WARN)
    return
  end
  if vim.fn.executable("helm") == 0 then
    vim.notify("helm is not installed", vim.log.levels.ERROR)
    return
  end

  local chart = vim.fs.dirname(chart_file)

  local cmd = { "helm", "template", "release", chart }
  local rel = file:sub(#chart + 2)
  if rel:match("^templates/") then
    vim.list_extend(cmd, { "--show-only", rel })
  end

  local function run(values)
    if values then
      vim.list_extend(cmd, { "-f", values })
    end
    local result = vim.system(cmd, { text = true }):wait()
    show(result)
  end

  local values = vim.fn.glob(chart .. "/values-*.yaml", false, true)
  if #values == 0 then
    run()
  elseif #values == 1 then
    run(values[1])
  else
    vim.ui.select(values, {
      prompt = "Helm values file:",
      format_item = function(v) return vim.fs.basename(v) end,
    }, function(choice)
      if choice then run(choice) end
    end)
  end
end

vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = { "yaml", "helm", "yaml.helm-values" },
  desc = "Helm render keymap",
  callback = function(args)
    vim.keymap.set("n", "<leader>rh", render, { buffer = args.buf, desc = "Helm template render" })
  end,
})
