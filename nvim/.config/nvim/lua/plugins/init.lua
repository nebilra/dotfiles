-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  { 'NMAC427/guess-indent.nvim', opts = {} },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    ft = { 'markdown', 'opencode_output' },
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
      completions = { blink = { enabled = true } },
      file_types = { 'markdown', 'opencode_output' },
    },
  },
  {
    'chentoast/marks.nvim',
    event = 'BufReadPost',
    opts = {},
  },
  { 'wakatime/vim-wakatime', event = 'VeryLazy' },
  { 'dmmulroy/ts-error-translator.nvim', opts = {}, ft = { 'typescript', 'typescriptreact' } },
  {
    'unblevable/quick-scope',
    init = function()
      require 'configs.quick-scope'
    end,
    config = function() end,
  },
}
