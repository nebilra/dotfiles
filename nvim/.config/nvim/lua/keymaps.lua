---@module "snacks"

-- [[ Basic Keymaps ]]
local map = vim.keymap.set

-- Clear highlights on search when pressing <Esc> in normal mode
map('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
map('n', '<leader>dq', vim.diagnostic.setloclist, { desc = 'Open file diagnostic [Q]uickfix list' })
map('n', '<leader>dQ', vim.diagnostic.setqflist, { desc = 'Open Workspace diagnostic [Q]uickfix list' })

-- Lsp keymaps
map('n', 'gdj', '<cmd>belowright split | lua vim.lsp.buf.definition()<CR>', { desc = 'Open definition in a new horizontal split' })
map('n', 'gdl', '<cmd>vsplit | lua vim.lsp.buf.definition()<CR>', { desc = 'Open definition in a new vertical split' })
map('n', 'gdn', '<cmd>tab split | lua vim.lsp.buf.definition()<CR>', { desc = 'Open definition in a new tab' })

-- Terminal keymaps
map('t', '<Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
map('t', '<C-h>', '<cmd>wincmd h<cr>', { desc = 'Move focus to the left window in terminal mode' })
map('t', '<S-C-l>', '<cmd>wincmd l<cr>', { desc = 'Move focus to the right window in terminal mode' })
map('t', '<C-j>', '<cmd>wincmd j<cr>', { desc = 'Move focus to the lower window in terminal mode' })
map('t', '<C-k>', '<cmd>wincmd k<cr>', { desc = 'Move focus to the upper window in terminal mode' })
-- map('t', '<C-w>', '<C-\\><C-n><C-w>', { desc = 'Control current window in terminal mode' })

-- Window management keymaps
map('n', '<M-S-h>', '<C-w>H', { desc = 'Move window to the left' })
map('n', '<M-S-l>', '<C-w>L', { desc = 'Move window to the right' })
map('n', '<M-S-j>', '<C-w>J', { desc = 'Move window to the lower' })
map('n', '<M-S-k>', '<C-w>K', { desc = 'Move window to the upper' })

-- Search and replace
map('n', '<leader>ra', function()
  local search_term = vim.fn.getreg '/'
  Snacks.input({ prompt = "Replace '" .. search_term .. "' with: " }, function(replace_term)
    vim.cmd(':%s/' .. search_term .. '/' .. replace_term .. '/g')
  end)
end, { desc = 'Substitute last searched word with input' })
map('n', '<leader>rs', function()
  local search_term = vim.fn.getreg '/'
  Snacks.input({ prompt = "Replace '" .. search_term .. "' with: " }, function(replace_term)
    vim.cmd(':%s/' .. search_term .. '/' .. replace_term .. '/gc')
  end)
end, { desc = 'Substitute last searched word with input with confirmation' })

-- Toggle formatting keymaps
map('n', '<leader>tF', function()
  if vim.g.disable_autosort then
    vim.cmd ':ImportSortEnable'
    vim.notify 'Auto import sorting enabled'
  else
    vim.cmd ':ImportSortDisable'
    vim.notify 'Auto import sorting disabled'
  end
end, { desc = 'Toggle auto import sorting on save' })
map('n', '<leader>tf', function()
  if vim.g.disable_autoformat then
    vim.cmd ':FormatEnable'
    vim.notify 'Auto formatting enabled'
  else
    vim.cmd ':FormatDisable'
    vim.notify 'Auto formatting disabled'
  end
end, { desc = 'Toggle auto format on save' })

-- QoL keymaps
map({ 'n', 'v' }, ';', ':', { desc = 'CMD enter command mode' })
map({ 'n', 'v' }, ',', ';', { desc = 'Repeat last f or t command' })
map({ 'n', 'v' }, ':', ',', { desc = 'Execute the inverse of the last f or t command' })
map('n', 'ycc', '"pyygcc"pp', { remap = true, desc = 'Duplicate line and comment out original' })
map({ 'n', 'v', 'o' }, 'gH', 'g^', { desc = 'Go to the beginning of the line' })
map({ 'n', 'v', 'o' }, 'gL', 'g$', { desc = 'Go to the end of the line' })
map({ 'n', 'v', 'o' }, 'H', '^', { desc = 'Go to the beginning of the line' })
map({ 'n', 'v', 'o' }, 'L', '$', { desc = 'Go to the end of the line' })
map('n', '<CR>', 'm`o<Esc>``', { desc = 'Insert new line below in normal mode' })
map('n', '<S-CR>', 'm`O<Esc>``', { desc = 'Insert new line above in normal mode' })
map('v', '<leader>p', '"_dP', { desc = 'Paste previous to cursor and keep the paste value' })
map('v', '<leader>P', '"_dp', { desc = 'Paste next to cursor and keep the paste value' })
map('n', 'U', '<C-r>', { desc = 'Redo key' })
map({ 'n', 'v' }, '`', 'q', { desc = 'Start macro recording' })
map({ 'n', 'v' }, 'q', 'b', { desc = 'One word back' })
map({ 'n', 'v' }, 'b', '%', { desc = 'Complimenting bracket' })
map('n', '<C-S>', '<cmd>w<CR>', { desc = 'Save file' })
map('n', '<leader>wk', '<cmd>WhichKey<CR>', { desc = 'Open WhichKey dialog' })
map('n', '<leader>/', 'gcc', { desc = 'toggle comment', remap = true })
map('v', '<leader>/', 'gc', { desc = 'toggle comment', remap = true })
map('x', '/', '<Esc>/\\%V', { desc = 'Search within visually selected lines' })
map('n', 'x', '"_x', { desc = 'Remap x to use the _ register' })
map({ 'n', 'v' }, '+', '<C-a>', { desc = 'Increment value' })
map({ 'n', 'v' }, '-', '<C-x>', { desc = 'Decrement value' })
map({ 'n', 'v' }, 'g+', 'g<C-a>', { desc = 'Context aware increment value' })
map({ 'n', 'v' }, 'g-', 'g<C-x>', { desc = 'Context aware decrement value' })
map('n', '<C-a>', 'gg<S-v>G', { desc = 'Select entire file' })
map('n', '<leader>gp', '`[v`]', { desc = 'Select pasted text' })
map('n', '[/', '[<c-i>', { desc = 'Get first occurence of word' })

-- Go to next and previous error
map('n', ']e', function()
  vim.diagnostic.jump { severity = vim.diagnostic.severity.ERROR, wrap = true, float = true, count = 1 }
end, { desc = 'Error forward' })
map('n', '[e', function()
  vim.diagnostic.jump { severity = vim.diagnostic.severity.ERROR, wrap = true, float = true, count = -1 }
end, { desc = 'Error backward' })

-- Navigate to and from quotation marks of all kinds
map({ 'n', 'o', 'x' }, "]'", [[/\v("|'|`)[^"'`]*\1<CR><cmd>nohlsearch<CR>]], { desc = 'Jump forwards to the next pair of quotes' })
map({ 'n', 'o', 'x' }, "['", [[?\v("|'|`)[^"'`]*\1<CR><cmd>nohlsearch<CR>]], { desc = 'Jump backwards to the previous pair of quotes' })
map({ 'n', 'o', 'x' }, ']"', [[/\v("|'|`)[^"'`]*\zs\1<CR><cmd>nohlsearch<CR>]], { desc = 'Jump forwards to the next closing quote (", \', `)' })
map({ 'n', 'o', 'x' }, '["', [[?\v("|'|`)[^"'`]*\zs\1<CR><cmd>nohlsearch<CR>]], { desc = 'Jump backwards to the previous closing quote (", \', `)' })

-- Navigate Open Buffers
map('n', '<leader>x', '<cmd>bp<CR><cmd>bd#<CR>', { desc = 'buffer close' })
map('n', '<tab>', '<cmd>bn<CR>', { desc = 'buffer goto next' })
map('n', '<S-tab>', '<cmd>bp<CR>', { desc = 'buffer goto previous' })

-- Navigate Open Tabs
map('n', '<C-z>', '<cmd>tabclose<CR>', { desc = 'Tab close' })
map('n', '<C-n>', '<cmd>tab split<CR>', { desc = 'Tab create' })
map({ 'n', 't' }, '<M-C-j>', function()
  vim.cmd 'tabnext'
  if vim.bo.buftype == 'terminal' then
    vim.cmd 'startinsert'
  end
end, { desc = 'Tab goto next' })
map({ 'n', 't' }, '<M-C-k>', function()
  vim.cmd 'tabprevious'
  if vim.bo.buftype == 'terminal' then
    vim.cmd 'startinsert'
  end
end, { desc = 'Tab goto previous' })

-- Repeat last move from treesitter textobjects
-- local ts_repeat_move = require 'nvim-treesitter.textobjects.repeatable_move'
-- Repeat movement with ; and ,
-- ensure ; goes forward and , goes backward regardless of the last direction
-- map({ "n", "x", "o" }, ":", ts_repeat_move.repeat_last_move_next)
-- map({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)

-- vim way: ; goes to the direction you were moving.
-- map({ 'n', 'x', 'o' }, ',', ts_repeat_move.repeat_last_move, { desc = 'Next textobject forward' })
-- map({ 'n', 'x', 'o' }, ':', ts_repeat_move.repeat_last_move_opposite, { desc = 'Next textobject opposite' })

-- map({ 'n', 'x', 'o' }, 'f', ts_repeat_move.builtin_f_expr, { expr = true })
-- map({ 'n', 'x', 'o' }, 'F', ts_repeat_move.builtin_F_expr, { expr = true })
-- map({ 'n', 'x', 'o' }, 't', ts_repeat_move.builtin_t_expr, { expr = true })
-- map({ 'n', 'x', 'o' }, 'T', ts_repeat_move.builtin_T_expr, { expr = true })
