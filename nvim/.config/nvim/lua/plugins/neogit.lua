return {
  'NeogitOrg/neogit',
  init = function()
    -- Shim codediff.ui.view.create for legacy Neogit integration schema
    local ok, view = pcall(require, 'codediff.ui.view')
    if ok and view.create then
      local original_create = view.create
      local path = require 'codediff.core.path'

      view.create = function(session_config, filetype, on_ready)
        if session_config.mode == 'explorer' and not session_config.panel then
          session_config.panel = {
            name = 'explorer',
            data = session_config.explorer_data or {},
          }
          session_config.original = session_config.original or path.empty()
          session_config.modified = session_config.modified or path.empty()
        end
        return original_create(session_config, filetype, on_ready)
      end
    end
  end,
  keys = {
    { '<leader>gi', mode = 'n', ':Neogit<CR>', noremap = true, desc = 'Neogit dashboard' },
  },
  opts = {
    graph_style = 'kitty',
    diff_viewer = 'codediff',
    signs = {
      item = { '', '' },
      section = { '', '' },
    },
    integrations = {
      telescope = false,
      snacks = true,
      codediff = true,
    },
  },
  dependencies = {
    'nvim-lua/plenary.nvim',
    'esmuellert/codediff.nvim',
  },
}
