return {
  'nvim-lualine/lualine.nvim',
  event = 'VeryLazy',
  opts = function()
    return require 'configs.lualine'
  end,
}
