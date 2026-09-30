return {
  'akinsho/bufferline.nvim',
  event = 'BufEnter',
  enabled = false,
  version = '*',
  config = function()
    local bufferline = require 'bufferline'
    bufferline.setup {
      options = {
        indicator = {
          style = 'underline',
        },
        diagnostics = 'nvim_lsp',
        show_buffer_close_icons = false,
        style_preset = bufferline.style_preset.no_italic,
        always_show_bufferline = false,
        auto_toggle_bufferline = false,
        diagnostics_indicator = function(count, level, _, context)
          if context.buffer:current() then
            return ''
          end
          local icon = level:match 'error' and ' ' or ' '
          return ' ' .. icon .. count
        end,
      },
    }
  end,
  keys = {
    { 'gb', mode = 'n', '<cmd>BufferLinePick<cr>', desc = 'Pick a buffer' },
    { '<M-[>', mode = 'n', '<cmd>BufferLineMovePrev<cr>', desc = 'Move buffer to the left' },
    { '<M-]>', mode = 'n', '<cmd>BufferLineMoveNext<cr>', desc = 'Move buffer to the right' },
    {
      '<leader>tt',
      function()
        require('configs.bufferline').toggle_bufferline()
      end,
      mode = 'n',
      desc = 'Toggle bufferline',
    },
  },
}
