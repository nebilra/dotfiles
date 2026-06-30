-- autocmds
local autocmd = vim.api.nvim_create_autocmd
local usercmd = vim.api.nvim_create_user_command

-- Prefer LSP folding if client supports it
autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client:supports_method 'textDocument/foldingRange' then
      local win = vim.api.nvim_get_current_win()
      vim.api.nvim_set_option_value('foldexpr', 'v:lua.vim.lsp.foldexpr()', { win = win })
    end
  end,
})

autocmd('VimResized', {
  desc = 'Automatically resize splits, when terminal window is moved',
  command = 'wincmd =',
})

autocmd('FileType', {
  desc = 'Enable some settings on markdown files',
  pattern = 'markdown',
  callback = function()
    vim.wo.spell = true
    vim.wo.wrap = true
  end,
})

-- Set text width for markdown files to be 80
autocmd('BufWinEnter', {
  pattern = { '*.md' },
  callback = function()
    vim.opt.textwidth = 80
  end,
})

autocmd({ 'BufWinLeave' }, {
  pattern = { '*.md' },
  callback = function()
    vim.opt.textwidth = 120
  end,
})

-- Restore cursor to file position in previous editing session
autocmd('BufReadPost', {
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 0 and mark[1] <= line_count then
      vim.cmd 'normal! g`"zz'
    end
  end,
})

-- Open help window in a vertical split
autocmd('FileType', {
  desc = 'Automatically Split help Buffers to the right',
  pattern = 'help',
  command = 'wincmd L',
})

-- Remove the Enter remap in the quickfix window
autocmd('BufReadPost', {
  pattern = 'quickfix',
  desc = 'Remap enter to default in quickfix windows',
  group = vim.api.nvim_create_augroup('quickfix-remap', { clear = true }),
  callback = function()
    vim.api.nvim_buf_set_keymap(0, 'n', '<CR>', '<CR>', { noremap = true, silent = true })
  end,
})

-- Stop Neovim Daemons.
autocmd('ExitPre', {
  group = vim.api.nvim_create_augroup('StopNeovimDaemons', { clear = true }),
  desc = 'Stop Neovim Dameons (eslint_d, prettier_d etc.) upon exit',
  callback = function()
    vim.fn.jobstart(vim.fn.expand '$SCRIPTS' .. 'stop-nvim-daemons.sh', { detach = true })
  end,
})

-- Syntax highlighting for dotenv files
autocmd('BufRead', {
  group = vim.api.nvim_create_augroup('dotenv_ft', { clear = true }),
  pattern = { '.env', '.env.*' },
  callback = function()
    vim.bo.filetype = 'dosini'
  end,
})

-- Disable auto formatting
usercmd('FormatDisable', function(args)
  if args.bang then
    -- FormatDisable! will disable formatting just for this buffer
    vim.b.disable_autoformat = true
  else
    vim.g.disable_autoformat = true
  end
end, {
  desc = 'Disable autoformat-on-save',
  bang = true,
})

-- Enable auto formatting
usercmd('FormatEnable', function()
  vim.b.disable_autoformat = false
  vim.g.disable_autoformat = false
end, {
  desc = 'Re-enable autoformat-on-save',
})

-- Disable auto import sorting
usercmd('ImportSortDisable', function(args)
  if args.bang then
    -- FormatDisable! will disable formatting just for this buffer
    vim.b.disable_autosort = true
  else
    vim.g.disable_autosort = true
  end
end, {
  desc = 'Disable autoimportsorting-on-save',
  bang = true,
})

-- Enable auto import sorting
usercmd('ImportSortEnable', function()
  vim.b.disable_autosort = false
  vim.g.disable_autosort = false
end, {
  desc = 'Re-enable autoimportsorting-on-save',
})

-- -- No auto comment
-- autocmd('FileType', {
--   group = vim.api.nvim_create_augroup('no_auto_comment', {}),
--   callback = function()
--     vim.opt_local.formatoptions:remove { 'c', 'r', 'o' }
--   end,
-- })
--
