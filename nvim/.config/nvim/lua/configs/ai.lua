---@module "snacks"

local M = {}

local function buffer_path()
  local path = vim.fn.expand '%:p'
  if path == '' then
    path = vim.api.nvim_buf_get_name(0)
  end
  if path == '' then
    path = '[no name]'
  end
  return path
end

---Capture the current visual selection.
---Exits visual mode before reading marks (same approach as opencode.nvim).
---@return { from: integer[], to: integer[] }|nil
local function get_selection()
  local mode = vim.fn.mode()
  if not mode:match '^[vV\22]' then
    return nil
  end

  -- Exit visual mode for consistent marks
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<esc>', true, false, true), 'x', true)

  local from = vim.api.nvim_buf_get_mark(0, '<')
  local to = vim.api.nvim_buf_get_mark(0, '>')
  if from[1] > to[1] or (from[1] == to[1] and from[2] > to[2]) then
    from, to = to, from
  end

  return { from = from, to = to }
end

---Literal text of a buffer range.
---@param from integer[] { line, col } 1/0-based
---@param to integer[] { line, col } 1/0-based
local function range_text(from, to)
  local lines = vim.api.nvim_buf_get_lines(0, from[1] - 1, to[1], false)
  if #lines == 0 then
    return ''
  end
  lines[1] = string.sub(lines[1], from[2] + 1)
  if to[2] < 2147483647 then
    lines[#lines] = string.sub(lines[#lines], 1, to[2] + 1)
  end
  return table.concat(lines, '\n')
end

function M.ask()
  local selection = get_selection()

  local path = buffer_path()
  local current_line = vim.fn.line '.'

  Snacks.input({ prompt = 'AI Prompt: ' }, function(prompt)
    if not prompt or prompt == '' then
      return
    end

    local location
    local parts = { prompt, '' }
    if selection then
      local start_line, end_line = selection.from[1], selection.to[1]
      local line_range = start_line == end_line and tostring(start_line) or string.format('%d-%d', start_line, end_line)
      location = string.format('%s:%s', path, line_range)
      local text = range_text(selection.from, selection.to)
      if text ~= '' then
        local ft = vim.bo.filetype ~= '' and vim.bo.filetype or 'text'
        table.insert(parts, '```' .. ft)
        table.insert(parts, text)
        table.insert(parts, '```')
      end
    else
      location = string.format('%s:%d', path, current_line)
    end
    table.insert(parts, location)

    vim.fn.setreg('+', table.concat(parts, '\n'))
    vim.notify('AI prompt copied to clipboard', vim.log.levels.INFO, { title = 'AI' })
  end)
end

local severity_names = {
  [vim.diagnostic.severity.ERROR] = 'ERROR',
  [vim.diagnostic.severity.WARN] = 'WARN',
  [vim.diagnostic.severity.INFO] = 'INFO',
  [vim.diagnostic.severity.HINT] = 'HINT',
}

local function diagnostics_text(only_errors)
  local path = buffer_path()
  local diags = vim.diagnostic.get(0)
  if only_errors then
    diags = vim.tbl_filter(function(d)
      return d.severity == vim.diagnostic.severity.ERROR
    end, diags)
  end
  table.sort(diags, function(a, b)
    if a.lnum ~= b.lnum then
      return a.lnum < b.lnum
    end
    return a.col < b.col
  end)
  if #diags == 0 then
    return 'No diagnostics in ' .. path
  end
  local lines = {}
  for _, d in ipairs(diags) do
    local sev = severity_names[d.severity] or '?'
    local msg = d.message:gsub('\n', ' ')
    local src = d.source and (' (' .. d.source .. ')') or ''
    table.insert(lines, string.format('%s:%d:%d [%s] %s%s', path, d.lnum + 1, d.col + 1, sev, msg, src))
  end
  return table.concat(lines, '\n')
end

function M.ask_diagnostics(only_errors)
  local path = buffer_path()
  local current_line = vim.fn.line '.'
  local text = diagnostics_text(only_errors)

  Snacks.input({ prompt = 'AI Prompt: ' }, function(prompt)
    if not prompt or prompt == '' then
      return
    end

    local parts = { prompt, '', '```text', text, '```', string.format('%s:%d', path, current_line) }
    vim.fn.setreg('+', table.concat(parts, '\n'))
    vim.notify('AI diagnostics prompt copied to clipboard', vim.log.levels.INFO, { title = 'AI' })
  end)
end

vim.keymap.set('n', '<leader>ap', M.ask, { desc = 'AI: compose prompt with file context, copy to clipboard' })
vim.keymap.set('x', '<leader>ap', M.ask, { desc = 'AI: compose prompt with selection, copy to clipboard' })
vim.keymap.set('n', '<leader>ad', function()
  M.ask_diagnostics(false)
end, { desc = 'AI: compose prompt with file diagnostics, copy to clipboard' })
vim.keymap.set('n', '<leader>ae', function()
  M.ask_diagnostics(true)
end, { desc = 'AI: compose prompt with file errors, copy to clipboard' })

return M
