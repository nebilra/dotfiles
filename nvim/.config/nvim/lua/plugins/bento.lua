return {
  -- 'serhez/bento.nvim',
  dir = '~/Documents/code/oss/bento',
  enabled = true,
  event = 'BufReadPost',
  opts = {
    main_keymap = '<C-;>',
    map_last_accessed = true,
    stable_labels = true,
    max_open_buffers = 10,
    ui = {
      floating = {
        position = 'top-right',
        offset_y = 2,
        minimal_menu = 'dashed',
      },
    },
  },
  keys = {
    {
      '<leader>bl',
      mode = 'n',
      function()
        require('bento').toggle_buffer_limit()
      end,
      desc = 'Toggle buffer limit',
    },
  },
}
