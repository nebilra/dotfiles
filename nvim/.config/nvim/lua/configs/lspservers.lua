return {
  -- LSPs
  lsp = {
    vtsls = {
      --- @type lspconfig.settings.vtsls
      settings = {
        typescript = {},
      },
      capabilities = {
        semanticTokensProvider = nil,
      },
      experimental = {
        completion = {
          enableServerSideFuzzyMatch = true,
          entriesLimit = 50,
        },
      },
    },
    bashls = {},
    shellcheck = {},
    svelte = {},
    basedpyright = {},
    tailwindcss = {},
    cssls = {},
    html = {},
    emmet_language_server = {},
    lua_ls = {
      settings = {
        Lua = {
          completion = {
            callSnippet = 'Replace',
          },
          -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
          -- diagnostics = { disable = { 'missing-fields' } },
        },
      },
    },
    prismals = {},
    tinymist = {},
    rust_analyzer = {},
  },

  -- Formatters
  formatters = { prettierd = {}, prettier = {}, biome = {}, isort = {}, black = {}, stylua = {} },

  -- Linters
  linters = {
    -- eslint = {},
    eslint_d = {},
    markdownlint = {},
  },

  -- DAP
  dap = {
    -- js_debug_adapter = {},
  },
}
