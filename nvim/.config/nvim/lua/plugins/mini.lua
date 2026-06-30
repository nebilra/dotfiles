return {
  'nvim-mini/mini.nvim',
  config = function()
    -- Better Around/Inside textobjects
    --
    -- Examples:
    --  - va)  - [V]isually select [A]round [)]paren
    --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
    --  - ci'  - [C]hange [I]nside [']quote
    require('mini.ai').setup { n_lines = 500 }

    -- Add/delete/replace surroundings (brackets, quotes, etc.)
    --
    -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
    -- - sd'   - [S]urround [D]elete [']quotes
    -- - sr)'  - [S]urround [R]eplace [)] [']
    require('mini.surround').setup {
      n_lines = 500,
      custom_surroundings = {
        t = {
          input = { '<(%w-)%f[^<%w][^<>]->.-</%1>', '^<.->().*()</[^/]->$' }, -- from https://github.com/echasnovski/mini.surround/blob/14f418209ecf52d1a8de9d091eb6bd63c31a4e01/lua/mini/surround.lua#LL1048C13-L1048C72
          output = function()
            local emmet = require('mini.surround').user_input 'Emmet'
            if not emmet then
              return nil
            end
            return require('configs.mini-emmet').totag(emmet)
          end,
        },
        d = {
          input = { '%$%{(.-)%}', '^.-%$%{()(.-)()%}.-$' },
          output = { left = '${', right = '}' },
        },
        p = {
          input = { '`%$%{(.-)%}`', '^.-`%$%{()(.-)()%}`.-$' },
          output = { left = '`${', right = '}`' },
        },
      },
    }

    require('mini.basics').setup {
      autocommands = {
        -- Basic autocommands (highlight on yank, start Insert in terminal, ...)
        basic = true,

        -- Set 'relativenumber' only in linewise and blockwise Visual mode
        relnum_in_visual_mode = false,
      },

      mappings = {
        move_with_alt = true,
        windows = true,
      },
    }

    require('mini.bracketed').setup()
    require('mini.move').setup()
  end,
}
-- vim: ts=2 sts=2 sw=2 et
