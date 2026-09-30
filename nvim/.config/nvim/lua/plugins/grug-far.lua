return {
  'MagicDuck/grug-far.nvim',
  opts = {
    -- help line config
    helpLine = {
      -- whether to show the help line at the top of the buffer
      enabled = false,
    },

    windowCreationCommand = 'tabnew',
    -- shortcuts for the actions you see at the top of the buffer
    -- set to '' or false to unset. Mappings with no normal mode value will be removed from the help header
    -- you can specify either a string which is then used as the mapping for both normal and insert mode
    -- or you can specify a table of the form { [mode] = <lhs> } (e.g. { i = '<C-enter>', n = '<leader>ugr'})
    -- it is recommended to use <leader>u though as that is more vim-ish
    -- see https://learnvimscriptthehardway.stevelosh.com/chapters/11.html#local-leader
    keymaps = {
      replace = { n = '<C-r>' },
      qflist = { n = '<C-q>' },
      syncLocations = { n = '<leader>us' },
      syncLine = { n = '<leader>ul' },
      close = { n = '<C-c>', i = '<C-c>', v = '<C-c>' },
      historyOpen = { n = '<leader>ut' },
      historyAdd = { n = '<leader>ua' },
      refresh = { n = '<leader>ur' },
      openLocation = { n = '<leader>uo' },
      openNextLocation = { n = '<down>' },
      openPrevLocation = { n = '<up>' },
      gotoLocation = { n = '<enter>' },
      pickHistoryEntry = { n = '<enter>' },
      abort = { n = '<leader>ub' },
      help = { n = 'g?' },
      toggleShowCommand = { n = '<leader>uw' },
      swapEngine = { n = '<leader>ue' },
      previewLocation = { n = '<leader>ui' },
      swapReplacementInterpreter = { n = '<leader>ux' },
      applyNext = { n = '<leader>uj' },
      applyPrev = { n = '<leader>uk' },
      syncNext = { n = '<leader>un' },
      syncPrev = { n = '<leader>up' },
      syncFile = { n = '<leader>uv' },
      nextInput = { n = '<tab>' },
      prevInput = { n = '<s-tab>' },
    },
  },
  cmd = { 'GrugFar', 'GrugFarWithin' },
}
