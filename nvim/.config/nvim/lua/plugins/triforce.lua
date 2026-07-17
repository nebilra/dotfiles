return {
  'gisketch/triforce.nvim',
  dependencies = {
    'nvzone/volt',
  },
  opts = {},
  keys = {
    {
      '<leader>tp',
      function()
        require('triforce').show_profile()
      end,
    },
  },
}
