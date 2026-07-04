return {
  'nebilra/new-file.nvim',

  -- dir = '~/Documents/code/personal/new-file.nvim',
  enabled = true,
  opts = {},
  keys = {
    {
      '<leader>cp',
      function()
        require('new-file').open()
      end,
      mode = 'n',
      { desc = '[C]reate new file/folder/[P]ath in selected directory' },
    },
  },
}
