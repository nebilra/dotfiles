-- ~  Personal config based on minim

-- ~  --------------------------------------------------------------------------------  ~ --

-- ~  Init

-- Try to build a minimal theme/palette from the currently active colorscheme.
-- If no colorscheme is available, fall back to loading 'tokyonight' and
-- attempting to build from that. As a last resort, use a small hard-coded
-- palette so lualine still renders.
local theme
local palette

local function hl_color(group, attr)
  -- Safely get highlight info for a group and return hex color for attr ('fg'/'bg').
  -- Prefer the newer API when available; fall back to the old one for older Neovim.
  local ok, hl = pcall(function()
    return vim.api.nvim_get_hl(0, { name = group })
  end)
  if not ok or type(hl) ~= 'table' then
    return nil
  end

  -- Support both possible key names ('fg'/'bg' and 'foreground'/'background').
  local val
  if attr == 'fg' then
    val = hl.fg or hl.foreground
  elseif attr == 'bg' then
    val = hl.bg or hl.background
  else
    val = hl[attr]
  end

  if type(val) == 'number' then
    return string.format('#%06x', val)
  end
  return nil
end

local function pick_color(groups)
  for _, g in ipairs(groups) do
    local c = hl_color(g, 'fg')
    if c then
      return c
    end
  end
  return nil
end

local function build_from_current()
  if not vim.g.colors_name then
    return nil
  end

  local p = {}
  p.dragonWhite = pick_color { 'Normal', 'StatusLine' } or '#c0caf5'
  p.dragonAqua = pick_color { 'Identifier', 'Type', 'Special', 'Directory' } or '#7dcfff'
  p.dragonRed = pick_color { 'Error', 'DiagnosticError', 'ErrorMsg', 'GitSignsDelete', 'DiffDelete' } or '#f7768e'
  p.dragonGreen = pick_color { 'String', 'GitSignsAdd', 'DiffAdd' } or '#9ece6a'
  p.dragonBlue = pick_color { 'Function', 'Statement', 'DiagnosticInfo' } or '#7aa2f7'
  p.dragonOrange = pick_color { 'PreProc', 'Title', 'Keyword' } or '#ff9e64'
  p.dragonYellow = pick_color { 'Warning', 'DiagnosticWarn', 'StorageClass' } or '#e0af68'
  p.dragonViolet = pick_color { 'Identifier', 'Keyword', 'Type' } or '#bb9af7'
  p.dragonTeal = pick_color { 'Comment', 'Conditional', 'Constant' } or '#2ac3de'

  local t = {}
  t.ui = {
    fg = pick_color { 'Normal', 'StatusLine' } or p.dragonWhite,
    fg_dim = pick_color { 'Comment', 'LineNr', 'StatusLineNC' } or p.dragonWhite,
    bg_m3 = hl_color('StatusLineNC', 'bg') or hl_color('Normal', 'bg') or p.dragonViolet,
  }
  t.vcs = {
    added = pick_color { 'GitSignsAdd', 'DiffAdd' } or p.dragonGreen,
    changed = pick_color { 'GitSignsChange', 'DiffChange' } or p.dragonBlue,
    removed = pick_color { 'GitSignsDelete', 'DiffDelete' } or p.dragonRed,
  }
  t.diag = {
    error = pick_color { 'DiagnosticError', 'Error', 'ErrorMsg' } or p.dragonRed,
    warning = pick_color { 'DiagnosticWarn', 'Warning' } or p.dragonYellow,
    info = pick_color { 'DiagnosticInfo', 'Todo' } or p.dragonBlue,
    hint = pick_color { 'DiagnosticHint', 'Comment' } or p.dragonTeal,
  }

  return { theme = t, palette = p }
end

local built = build_from_current()
if not built then
  -- Try to load tokyonight and then build again. Call via a function so pcall
  -- receives an actual function (avoid type-checker errors where vim.cmd is
  -- treated as a table with a __call metatable).
  pcall(function()
    vim.cmd 'colorscheme tokyonight'
  end)
  built = build_from_current()
end

if built then
  theme = built.theme
  palette = built.palette
else
  -- Last-resort defaults so lualine won't error.
  palette = {
    dragonWhite = '#c0caf5',
    dragonAqua = '#7dcfff',
    dragonRed = '#f7768e',
    dragonGreen = '#9ece6a',
    dragonBlue = '#7aa2f7',
    dragonOrange = '#ff9e64',
    dragonYellow = '#e0af68',
    dragonViolet = '#bb9af7',
    dragonTeal = '#2ac3de',
  }
  theme = {
    ui = { fg = palette.dragonWhite, fg_dim = palette.dragonWhite, bg_m3 = '#1f2335' },
    vcs = { added = palette.dragonGreen, changed = palette.dragonBlue, removed = palette.dragonRed },
    diag = { error = palette.dragonRed, warning = palette.dragonYellow, info = palette.dragonBlue, hint = palette.dragonTeal },
  }
end
local has_devicons, devicons = pcall(require, 'nvim-web-devicons')
local static = {}

-- ~  --------------------------------------------------------------------------------  ~ --

-- ~  Helpers

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

local get_ftype_icon = function()
  local full_filename = vim.api.nvim_buf_get_name(0)
  local filename = vim.fn.fnamemodify(full_filename, ':t')
  local extension = vim.fn.fnamemodify(filename, ':e')
  static.ftype_icon, static.ftype_icon_color = devicons.get_icon_color(filename, extension, { default = true })
  return static.ftype_icon and static.ftype_icon .. ''
end

local condition = {
  is_buf_empty = function()
    return vim.fn.empty(vim.fn.expand '%:t') ~= 1
  end,
  is_git_repo = function()
    local filepath = vim.fn.expand '%:p:h'
    local gitdir = vim.fn.finddir('.git', filepath .. ';')
    return gitdir and #gitdir > 0 and #gitdir < #filepath
  end,
}

local mode_colors = {
  n = palette.dragonRed,
  no = palette.dragonRed,
  cv = palette.dragonRed,
  ce = palette.dragonRed,
  ['!'] = palette.dragonRed,
  t = palette.dragonRed,
  i = palette.dragonGreen,
  v = palette.dragonBlue,
  [''] = palette.dragonBlue,
  V = palette.dragonBlue,
  c = palette.dragonAqua,
  s = palette.dragonOrange,
  S = palette.dragonOrange,
  [''] = palette.dragonOrange,
  ic = palette.dragonYellow,
  R = palette.dragonViolet,
  Rv = palette.dragonViolet,
  r = palette.dragonTeal,
  rm = palette.dragonTeal,
  ['r?'] = palette.dragonTeal,
}

-- ~  --------------------------------------------------------------------------------  ~ --

-- ~  Lualine Config

local config = {
  options = {
    component_separators = '',
    section_separators = '',
    always_divide_middle = true,
    -- theme = {
    --   normal = { c = { fg = theme.ui.fg, bg = 'Normal', gui = 'bold' } },
    --   inactive = { c = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 } },
    -- },
    theme = 'auto',
    always_show_tabline = false,
  },
  sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  },
  inactive_sections = {
    lualine_a = { 'filename' },
    lualine_b = { 'location' },
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
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
}

local status_c = function(component)
  table.insert(config.sections.lualine_c, component)
end
local status_x = function(component)
  table.insert(config.sections.lualine_x, component)
end

-- ~  --------------------------------------------------------------------------------  ~ --

-- ~  Status line
-- ~  Left

status_c {
  function()
    return '| '
  end,
  color = { fg = palette.dragonWhite },
  padding = { left = 0 },
}

status_c {
  -- Colored mode icon
  function()
    return custom_icons.mode
  end,
  color = function()
    return { fg = mode_colors[vim.fn.mode()] }
  end,
  padding = { right = 1 },
}

status_c {
  -- File type icon via 'nvim-web-devicons'
  function()
    if has_devicons then
      return get_ftype_icon()
    end
  end,
  cond = condition.is_buf_empty,
  color = { fg = static.ftype_icon_color },
  padding = { left = 1, right = 0 },
}

status_c {
  'filename',
  cond = condition.is_buf_empty,
  path = 4,
  color = { fg = palette.dragonAqua },
  symbols = {
    modified = custom_icons.touched,
    readonly = custom_icons.lock,
    unnamed = '[No Name]',
    newfile = '[New]',
  },
}

-- ~  --------------------------------------------------------------------------------  ~ --
-- ~  Mid

status_c {
  function()
    return '%='
  end,
}

-- ~  --------------------------------------------------------------------------------  ~ --
-- ~  Right

status_x {
  'diff',
  cond = condition.is_git_repo,
  source = function()
    local gitsigns = vim.b.gitsigns_status_dict
    if gitsigns then
      return { added = gitsigns.added, modified = gitsigns.changed, removed = gitsigns.removed }
    end
  end,
  symbols = {
    added = custom_icons.added,
    modified = custom_icons.modified_simple,
    removed = custom_icons.removed,
  },
  colored = true,
  diff_color = {
    added = { fg = theme.vcs.added },
    modified = { fg = theme.vcs.changed },
    removed = { fg = theme.vcs.removed },
  },
}

status_x {
  'diagnostics',
  sources = { 'nvim_diagnostic' },
  symbols = {
    error = custom_icons.error,
    warn = custom_icons.warn,
    info = custom_icons.info,
    hint = custom_icons.hint,
  },
  diagnostics_color = {
    error = { fg = theme.diag.error },
    warn = { fg = theme.diag.warning },
    info = { fg = theme.diag.info },
    hint = { fg = theme.diag.hint },
  },
}

status_x { 'branch', icon = custom_icons.git_branch, color = { fg = palette.dragonViolet } }
status_x {
  function()
    return ' |'
  end,
  color = { fg = palette.dragonWhite },
  padding = { right = 0 },
}

-- ~  --------------------------------------------------------------------------------  ~ --

return config
