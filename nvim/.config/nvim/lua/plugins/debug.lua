return {
  'mfussenegger/nvim-dap',
  enabled = false,
  dependencies = {
    -- Installs the debug adapters for you
    'mason-org/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

    'igorlfs/nvim-dap-view',

    -- Add your own debuggers here
    'leoluz/nvim-dap-go',
    'mxsdev/nvim-dap-vscode-js',
  },
  config = function()
    local dap = require 'dap'

    require('mason-nvim-dap').setup {
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_installation = true,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        -- Update this to ensure that you have the debuggers for the langs you want
        'delve',
      },
    }

    -- Change breakpoint icons
    vim.api.nvim_set_hl(0, 'DapBreak', { fg = '#e51400' })
    vim.api.nvim_set_hl(0, 'DapStop', { fg = '#ffcc00' })

    local breakpoint_icons = vim.g.have_nerd_font
        and { Breakpoint = '', BreakpointCondition = '', BreakpointRejected = '', LogPoint = '', Stopped = '' }
      or { Breakpoint = '●', BreakpointCondition = '⊜', BreakpointRejected = '⊘', LogPoint = '◆', Stopped = '⭔' }

    for type, icon in pairs(breakpoint_icons) do
      local tp = 'Dap' .. type
      local hl = (type == 'Stopped') and 'DapStop' or 'DapBreak'
      vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
    end

    -- Install golang specific config
    require('dap-go').setup {
      delve = {
        detached = vim.fn.has 'win32' == 0,
      },
    }

    require('dap-vscode-js').setup {
      adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' }, -- which adapters to register in nvim-dap
    }

    for _, language in ipairs { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact' } do
      require('dap').configurations[language] = {
        {
          type = 'pwa-node',
          request = 'launch',
          name = 'Launch file',
          program = '${file}',
          cwd = '${workspaceFolder}',
        },
        {
          type = 'pwa-node',
          request = 'attach',
          name = 'Attach',
          processId = require('dap.utils').pick_process,
          cwd = '${workspaceFolder}',
        },
        -- {
        --   type = 'pwa-node',
        --   request = 'launch',
        --   name = 'Debug Jest Tests',
        --   -- trace = true, -- include debugger info
        --   runtimeExecutable = 'node',
        --   runtimeArgs = {
        --     './node_modules/jest/bin/jest.js',
        --     '--runInBand',
        --   },
        --   rootPath = '${workspaceFolder}',
        --   cwd = '${workspaceFolder}',
        --   console = 'integratedTerminal',
        --   internalConsoleOptions = 'neverOpen',
        -- },
      }
    end
  end,
  keys = {
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
      '<leader>dr',
      function()
        require('dap').repl.toggle()
      end,
      desc = 'Debug: Toggle REPL',
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
