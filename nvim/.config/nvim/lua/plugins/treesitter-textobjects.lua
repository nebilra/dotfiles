return {
  'nvim-treesitter/nvim-treesitter-textobjects',
  enabled = true,
  branch = 'main',
  event = { 'BufReadPost', 'BufNewFile' },
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  config = function()
    require('nvim-treesitter-textobjects').setup {
      move = {
        set_jumps = true,
      },
      select = {
        lookahead = true,
        selection_modes = {
          ['@function.outer'] = 'V',
        },
      },
    }

    local select = require 'nvim-treesitter-textobjects.select'
    local move = require 'nvim-treesitter-textobjects.move'

    -- a/i textobject keymaps (visual + operator-pending)
    local textobjects = {
      ['af'] = '@function.outer',
      ['if'] = '@function.inner',
      ['aC'] = '@class.outer',
      ['iC'] = '@class.inner',
      ['ac'] = '@conditional.outer',
      ['ic'] = '@conditional.inner',
      ['ae'] = '@block.outer',
      ['ie'] = '@block.inner',
      ['aL'] = '@loop.outer',
      ['iL'] = '@loop.inner',
      ['as'] = '@statement.outer',
      ['is'] = '@statement.inner',
      ['am'] = '@call.outer',
      ['im'] = '@call.inner',
    }

    for key, capture in pairs(textobjects) do
      vim.keymap.set({ 'x', 'o' }, key, function()
        select.select_textobject(capture)
      end, { desc = 'Select ' .. capture:sub(2) })
    end

    -- Move to next/previous textobject (normal + visual + operator-pending)
    -- goto_next_start
    vim.keymap.set({ 'n', 'x', 'o' }, ']c', function()
      move.goto_next_start '@conditional.outer'
    end, { desc = 'Next conditional start' })
    vim.keymap.set({ 'n', 'x', 'o' }, ']p', function()
      move.goto_next_start '@loop.outer'
    end, { desc = 'Next loop start' })
    vim.keymap.set({ 'n', 'x', 'o' }, ']f', function()
      move.goto_next_start '@function.outer'
    end, { desc = 'Next function start' })

    -- goto_next_end
    vim.keymap.set({ 'n', 'x', 'o' }, ']C', function()
      move.goto_next_end '@conditional.outer'
    end, { desc = 'Next conditional end' })
    vim.keymap.set({ 'n', 'x', 'o' }, ']P', function()
      move.goto_next_end '@loop.outer'
    end, { desc = 'Next loop end' })
    vim.keymap.set({ 'n', 'x', 'o' }, ']F', function()
      move.goto_next_end '@function.outer'
    end, { desc = 'Next function end' })

    -- goto_previous_start
    vim.keymap.set({ 'n', 'x', 'o' }, '[c', function()
      move.goto_previous_start '@conditional.outer'
    end, { desc = 'Previous conditional start' })
    vim.keymap.set({ 'n', 'x', 'o' }, '[p', function()
      move.goto_previous_start '@loop.outer'
    end, { desc = 'Previous loop start' })
    vim.keymap.set({ 'n', 'x', 'o' }, '[f', function()
      move.goto_previous_start '@function.outer'
    end, { desc = 'Previous function start' })

    -- goto_previous_end
    vim.keymap.set({ 'n', 'x', 'o' }, '[C', function()
      move.goto_previous_end '@conditional.outer'
    end, { desc = 'Previous conditional end' })
    vim.keymap.set({ 'n', 'x', 'o' }, '[P', function()
      move.goto_previous_end '@loop.outer'
    end, { desc = 'Previous loop end' })
    vim.keymap.set({ 'n', 'x', 'o' }, '[F', function()
      move.goto_previous_end '@function.outer'
    end, { desc = 'Previous function end' })

    -- Incremental selection via treesitter built-in API (C-space/bs from old config)
    vim.keymap.set({ 'x', 'o', 'n' }, '<C-space>', function()
      require('vim.treesitter._select').select_parent(vim.v.count1)
    end, { desc = 'Select parent node' })

    vim.keymap.set({ 'x', 'o', 'n' }, '<bs>', function()
      require('vim.treesitter._select').select_child(vim.v.count1)
    end, { desc = 'Select child node' })
  end,
}
