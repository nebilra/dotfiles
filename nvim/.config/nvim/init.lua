-- Set <space> as the leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

if vim.env.TERM == 'xterm-kitty' then
  vim.cmd [[autocmd UIEnter * if v:event.chan ==# 0 | call chansend(v:stderr, "\x1b[>1u") | endif]]
  vim.cmd [[autocmd UILeave * if v:event.chan ==# 0 | call chansend(v:stderr, "\x1b[<1u") | endif]]
end

-- [[ Setting options ]]
require 'options'

-- [[ Setting autocmds ]]
require 'autocmds'

-- [[ Install `lazy.nvim` plugin manager ]]
require 'lazy-bootstrap'

-- [[ Configure and install plugins ]]
require 'lazy-plugins'

-- [[ Basic Keymaps ]]
require 'keymaps'

-- [[ AI workflow ]]
require 'configs.ai'

-- [[ Load Theme ]]
require 'ui.theme'

-- vim: ts=2 sts=2 sw=2 et
