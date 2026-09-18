---@module "snacks"
return {
  'folke/snacks.nvim',
  lazy = false,
  ---@type snacks.Config
  opts = {
    picker = {
      matcher = {
        frecency = true,
      },
      formatters = {
        file = {
          truncate = 'left',
        },
      },
      actions = {},
      win = {
        input = {
          keys = {
            ['<c-l>'] = { 'preview_scroll_right', mode = { 'i', 'n' } },
            ['<c-h>'] = { 'preview_scroll_left', mode = { 'i', 'n' } },
            ['<a-l>'] = { 'cycle_win', mode = { 'i', 'n' } },
          },
        },
        list = {
          keys = {
            ['<c-l>'] = { 'preview_scroll_right', mode = { 'i', 'n' } },
            ['<c-h>'] = { 'preview_scroll_left', mode = { 'i', 'n' } },
            ['<a-l>'] = { 'cycle_win', mode = { 'i', 'n' } },
          },
        },
        preview = {
          keys = {
            ['<a-l>'] = { 'cycle_win', mode = { 'i', 'n' } },
          },
        },
      },
    },
    image = {},
    ---@type table<string, snacks.win.Config>
    styles = {
      scratch = {
        width = 160,
        height = 36,
        bo = { buftype = '', buflisted = false, bufhidden = 'hide', swapfile = false },
        minimal = false,
        noautocmd = false,
        -- position = "right",
        zindex = 20,
        wo = { winhighlight = 'NormalFloat:Normal' },
        border = 'rounded',
        title_pos = 'center',
        footer_pos = 'center',
      },
    },
    ---@class snacks.dashboard.Config
    ---@field enabled? boolean
    ---@field sections snacks.dashboard.Section
    ---@field formats table<string, snacks.dashboard.Text|fun(item:snacks.dashboard.Item, ctx:snacks.dashboard.Format.ctx):snacks.dashboard.Text>
    dashboard = {
      preset = {
        ---@type snacks.dashboard.Item[]
        keys = {
          { icon = ' ', key = 'f', desc = 'Find File', action = ":lua Snacks.dashboard.pick('files')" },
          { icon = ' ', key = 'g', desc = 'Find Text', action = ":lua Snacks.dashboard.pick('live_grep')" },
          { icon = ' ', key = 'r', desc = 'Recent Files', action = ":lua Snacks.dashboard.pick('oldfiles')" },
          { icon = ' ', key = 'l', desc = 'Leetcode Dashboard', action = ':Leet' },
          { icon = ' ', key = 'c', desc = 'Config', action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
          { icon = '󰦛 ', key = 's', desc = 'Restore Session', section = 'session' },
          {
            icon = '󰦛 ',
            key = 'S',
            desc = 'Restore Last Session',
            action = function()
              require('persistence').load { last = true }
            end,
          },
          { icon = '󰒲 ', key = 'L', desc = 'Lazy', action = ':Lazy', enabled = package.loaded.lazy ~= nil },
          { icon = ' ', key = 'q', desc = 'Quit', action = ':qa' },
        },
      },
    },
    notifier = {}, -- Snacks notification
    -- indent = {}, -- Visual indent lines to see the scope you are in
    terminal = {},
    scratch = {
      ft = function()
        if vim.bo.buftype == '' and vim.bo.filetype == 'lua' then
          return vim.bo.filetype
        end
        return 'markdown'
      end,
      filekey = {
        cwd = true,
        branch = false,
        count = true,
      },
      win_by_ft = {
        lua = {
          keys = {
            ['source'] = {
              '<cr>',
              function(self)
                local name = 'scratch.' .. vim.fn.fnamemodify(vim.api.nvim_buf_get_name(self.buf), ':e')
                Snacks.debug.run { buf = self.buf, name = name }
              end,
              desc = 'Source buffer',
              mode = { 'n', 'x' },
            },
          },
        },
      },
    }, -- Scratch buffers for todos and other docs
    input = {}, -- Better vim.input I believe
    bigfile = {
      notify = true, -- show notification when big file detected
      size = 1.5 * 1024 * 1024, -- 1.5MB
      line_length = 500, -- average line length (useful for minified files)
      -- Enable or disable features when big file detected
      ---@param ctx {buf: number, ft:string}
      setup = function(ctx)
        if vim.fn.exists ':NoMatchParen' ~= 0 then
          vim.cmd [[NoMatchParen]]
        end
        Snacks.util.wo(0, { foldmethod = 'manual', statuscolumn = '', conceallevel = 0 })
        vim.b.minianimate_disable = true
        vim.schedule(function()
          if vim.api.nvim_buf_is_valid(ctx.buf) then
            vim.bo[ctx.buf].syntax = ctx.ft
          end
        end)
      end,
    },
    statuscolumn = {
      left = { 'mark', 'sign', 'git' }, -- priority of signs on the left (high to low)
      right = { 'fold' }, -- priority of signs on the right (high to low)
      folds = {
        open = true, -- show open fold icons
        git_hl = false, -- use Git Signs hl for fold icons
      },
      git = {
        -- patterns to match Git signs
        patterns = { 'GitSign', 'MiniDiffSign' },
      },
      refresh = 50, -- refresh at most every 50ms
    }, -- Show a status column left of the numbers column for fold and signs
  },
  keys = {
    {
      '<leader>sh',
      function()
        Snacks.picker.help()
      end,
      desc = 'Snacks: [S]earch [H]elp',
    },
    {
      '_',
      function()
        Snacks.scratch.open()
      end,
      mode = 'n',
      desc = 'Snacks: Toggle scratch buffer instance',
    },
    {
      '<leader>ts',
      function()
        Snacks.scratch.open()
      end,
      mode = 'n',
      desc = 'Snacks: Toggle scratch buffer instance',
    },
    {
      '<leader>ss',
      function()
        Snacks.picker.scratch {
          win = {
            input = {
              keys = {
                ['<c-x>'] = { 'scratch_delete', mode = { 'n', 'i' } },
                ['<c-n>'] = { 'list_down', mode = { 'n', 'i' } },
                ['<cr>'] = { 'scratch_new', mode = { 'n', 'i' } },
              },
            },
          },
        }
      end,
      mode = 'n',
      desc = 'Snacks: Select from scratch instances',
    },
    {
      '<leader>sk',
      function()
        Snacks.picker.keymaps()
      end,
      desc = 'Snacks: [S]earch [K]eymaps',
    },
    {
      '<leader>sf',
      function()
        Snacks.picker.files()
      end,
      desc = 'Snacks: [S]earch [F]iles',
    },
    {
      '<leader>sS',
      function()
        Snacks.picker.pickers()
      end,
      desc = 'Snacks: [S]earch [S]elect Snacks Picker',
    },
    {
      '<leader>sw',
      function()
        Snacks.picker.grep_word()
      end,
      desc = 'Snacks: [S]earch current [W]ord',
    },
    {
      '<leader>sg',
      function()
        Snacks.picker.grep()
      end,
      desc = 'Snacks: [S]earch by [G]rep',
    },
    {
      '<leader>sd',
      function()
        Snacks.picker.diagnostics()
      end,
      desc = 'Snacks: [S]earch [D]iagnostics',
    },
    {
      '<leader>sr',
      function()
        Snacks.picker.resume()
      end,
      desc = 'Snacks: [S]earch [R]esume',
    },
    {
      '<leader>s.',
      function()
        Snacks.picker.recent()
      end,
      desc = 'Snacks: [S]earch Recent Files ("." for repeat)',
    },
    {
      '<leader><leader>',
      function()
        Snacks.picker.buffers()
      end,
      desc = 'Snacks: [S]earch existing buffers',
    },
    {
      '<leader>ty',
      function()
        Snacks.picker.colorschemes()
      end,
      desc = 'Change color scheme',
    },
    {
      '<leader>sb',
      function()
        Snacks.picker.lines()
      end,
      desc = 'Snacks: Fuzzily [S]earch in current [B]uffer',
    },
    {
      '<leader>s/',
      function()
        Snacks.picker.grep_buffers()
      end,
      desc = 'Snacks: [S]earch [/] in Open Files',
    },
    {
      '<leader>sn',
      function()
        Snacks.picker.files { cwd = vim.fn.stdpath 'config' }
      end,
      desc = 'Snacks: [S]earch [N]eovim files',
    },
    {
      '<leader>gl',
      function()
        Snacks.picker.git_log {
          -- layout = 'ivy_split',
        }
      end,
      desc = 'Git Log',
    },
    {
      '<leader>gb',
      function()
        Snacks.git.blame_line()
      end,
      desc = 'Git Blame Line',
    },
    {
      '<leader>gf',
      function()
        Snacks.picker.git_log_file {
          -- layout = 'ivy_split',
        }
      end,
      desc = 'Git Log File',
    },
    {
      '<leader>bd',
      function()
        Snacks.bufdelete()
      end,
      desc = 'Delete Buffer',
    },
    {
      '<leader>bo',
      function()
        Snacks.bufdelete.other()
      end,
      desc = 'Delete Other Buffers',
    },
    {
      '<leader>tn',
      function()
        Snacks.notifier.show_history()
      end,
      mode = 'n',
      desc = 'Snacks: Show snacks notification history',
    },
  },
}
