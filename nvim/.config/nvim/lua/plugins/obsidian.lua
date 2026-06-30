return {
  'obsidian-nvim/obsidian.nvim',
  version = '*', -- use latest release, remove to use latest commit
  ---@module 'obsidian'
  ---@type obsidian.config
  opts = {
    legacy_commands = false, -- this will be removed in 4.0.0
    workspaces = {
      {
        name = 'personal',
        path = '~/Documents/notes/personal',
      },
      {
        name = 'work',
        path = '~/Documents/notes/work',
      },
    },
    ui = {
      enable = false,
    },
    templates = {
      folder = 'templates',
      date_format = '%Y-%m-%d',
      time_format = '%H:%M',
    },
    daily_notes = {
      folder = 'daily-notes',
      template = 'Daily Note Template.md',
    },
    note_id_func = function(title)
      if title ~= nil then
        return title:gsub(' ', '-'):gsub('[^A-Za-z0-9-]', ''):lower()
      else
        return tostring(math.random(1000, 9999))
      end
    end,
  },
  keys = {
    {
      '<leader>to',
      '<cmd>Obsidian<cr>',
      desc = 'Obsidian: Open Command Panel',
    },
  },
}
