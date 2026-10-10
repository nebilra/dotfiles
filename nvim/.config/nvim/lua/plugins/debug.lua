return {
  'JarnDev/autodap.nvim',
  dependencies = {
    'mfussenegger/nvim-dap',
    'williamboman/mason.nvim',
    'igorlfs/nvim-dap-view',
  },
  config = function()
    require('autodap').setup {
      languages = { 'node' },
    }
    -- Change breakpoint icons
    vim.api.nvim_set_hl(0, 'DapBreak', { fg = '#e51400' })
    vim.api.nvim_set_hl(0, 'DapStop', { fg = '#ffcc00' })

    require('dap-view').setup {
      windows = {
        size = 0.5,
        position = 'right',
        terminal = {
          size = 0.5,
          position = 'below',
          -- List of debug adapters for which the terminal should be ALWAYS hidden
          -- Can also be set to "true" to never show the terminal
          hide = {},
        },
      },
      virtual_text = {
        enabled = true,
      },
    }

    local breakpoint_icons = vim.g.have_nerd_font
        and { Breakpoint = '', BreakpointCondition = '', BreakpointRejected = '', LogPoint = '', Stopped = '' }
      or { Breakpoint = '●', BreakpointCondition = '⊜', BreakpointRejected = '⊘', LogPoint = '◆', Stopped = '⭔' }

    for type, icon in pairs(breakpoint_icons) do
      local tp = 'Dap' .. type
      local hl = (type == 'Stopped') and 'DapStop' or 'DapBreak'
      vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
    end
  end,
  keys = {
    {
      '<F5>',
      mode = 'n',
      function()
        require('autodap').continue()
      end,
      desc = 'Start debug session',
    },
    {
      '<leader>dB',
      function()
        require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ')
      end,
      desc = 'Debug: Breakpoint Condition',
    },
    {
      '<leader>db',
      function()
        require('dap').toggle_breakpoint()
      end,
      desc = 'Debug: Toggle Breakpoint',
    },
    {
      '<leader>dc',
      function()
        require('dap').continue()
      end,
      desc = 'Debug: Run/Continue',
    },
    {
      '<leader>da',
      function()
        require('dap').continue { before = get_args }
      end,
      desc = 'Debug: Run with Args',
    },
    {
      '<leader>dC',
      function()
        require('dap').run_to_cursor()
      end,
      desc = 'Debug: Run to Cursor',
    },
    {
      '<leader>dg',
      function()
        require('dap').goto_()
      end,
      desc = 'Debug: Go to Line (No Execute)',
    },
    {
      '<leader>di',
      function()
        require('dap').step_into()
      end,
      desc = 'Debug: Step Into',
    },
    {
      '<leader>dj',
      function()
        require('dap').down()
      end,
      desc = 'Debug: Down',
    },
    {
      '<leader>dk',
      function()
        require('dap').up()
      end,
      desc = 'Debug: Up',
    },
    {
      '<leader>dl',
      function()
        require('dap').run_last()
      end,
      desc = 'Debug: Run Last',
    },
    {
      '<leader>do',
      function()
        require('dap').step_out()
      end,
      desc = 'Debug: Step Out',
    },
    {
      '<leader>dO',
      function()
        require('dap').step_over()
      end,
      desc = 'Debug: Step Over',
    },
    {
      '<leader>dP',
      function()
        require('dap').pause()
      end,
      desc = 'Debug: Pause',
    },
    {
      '<leader>ds',
      function()
        require('dap').session()
      end,
      desc = 'Debug: Session',
    },
    {
      '<leader>dx',
      function()
        require('dap').terminate()
      end,
      desc = 'Debug: Terminate',
    },
    {
      '<leader>dt',
      '<cmd>DapViewToggle<cr>',
      desc = 'Debug: UI',
    },
    {
      '<leader>dw',
      '<cmd>DapViewWatch<cr>',
      desc = 'Debug: Watch',
    },
  },
}
