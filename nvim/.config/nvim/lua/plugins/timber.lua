return {
  'Goose97/timber.nvim',
  version = '2.3.0', -- Use for stability; omit to use `main` branch for the latest features
  event = 'VeryLazy',
  opts = {},
  keys = {
    {
      mode = 'n',
      'gls',
      function()
        require('timber.actions').search_log_statements()
      end,
      desc = 'Search for log statements',
    },
    {
      mode = 'n',
      'glc',
      function()
        require('timber.actions').clear_log_statements { global = false }
      end,
      desc = 'Clear log statements',
    },
    {
      mode = 'n',
      'glf',
      function()
        require('timber.buffers').open_float()
      end,
      desc = 'Show logs in a floating window',
    },
  },
}
