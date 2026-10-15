local custom_icons = {
  mode = '',
  git_branch = '',
  error = ' ',
  warn = ' ',
  info = ' ',
  hint = ' ',
  added = ' ',
  modified = '󰝤 ',
  modified_simple = '~ ',
  removed = ' ',
  lock = '',
  touched = '●',
}

return {
  options = {
    theme = 'nightfly',
    component_separators = '',
    always_divide_middle = true,
    always_show_tabline = false,
    section_separators = { left = '', right = '' },
    -- section_separators = { left = ' ', right = ' ' },
    disabled_filetypes = {
      'alpha',
      'Outline',
      'dapui_watches',
      'dapui_breakpoints',
      'dapui_scopes',
      'dapui_console',
      'dapui_stacks',
      'dap-repl',
      'codediff',
      'codediff-view',
      'codediff-explorer',
      'log',
    },
  },
  tabline = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {
      { 'tabs', mode = 0 },
    },
  },
  sections = {
    lualine_a = {
      { 'mode', separator = { left = '', right = '' }, padding = { left = 1, right = 1 } },
    },
    lualine_b = {
      {
        'filetype',
        icon_only = true,
        padding = { left = 1, right = 0 },
        cond = function()
          return vim.fn.empty(vim.fn.expand '%:t') ~= 1
        end,
      },
      {
        'filename',
        path = 4,
        symbols = {
          modified = custom_icons.touched,
          readonly = custom_icons.lock,
          unnamed = '[No Name]',
          newfile = '[New]',
        },
      },
    },
    lualine_c = {},
    lualine_x = {
      {
        'diagnostics',
        symbols = { error = ' ', warn = ' ', info = ' ', hint = ' ' },
        update_in_insert = true,
      },
    },
    lualine_y = {
      {
        'diff',
        symbols = {
          added = custom_icons.added,
          modified = custom_icons.modified_simple,
          removed = custom_icons.removed,
        },
        colored = true,
      },
      {
        'branch',
        icon = '',
      },
    },
    lualine_z = {},
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = { 'location' },
  },
  extensions = { 'toggleterm', 'quickfix', 'nvim-dap-ui' },
}
