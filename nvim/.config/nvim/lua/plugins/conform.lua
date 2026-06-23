-- vtsls organize imports function
local function organize_imports()
  local ft = vim.bo.filetype:gsub('react$', '')
  if not vim.tbl_contains({ 'javascript', 'typescript' }, ft) then
    return
  end
  local ok = vim.lsp.buf_request_sync(0, 'workspace/executeCommand', {
    command = (ft .. '.organizeImports'),
    arguments = { vim.api.nvim_buf_get_name(0) },
  }, 3000)
  if not ok then
    print 'Command timeout or failed to complete.'
  end
end

return {
  { -- Autoformat
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = { c = true, cpp = true }
        if disable_filetypes[vim.bo[bufnr].filetype] or vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return nil
        else
          if not vim.b[bufnr].disable_autosort and not vim.g.disable_autosort then
            -- organize_imports()
          end
          return {
            timeout_ms = 1000,
            lsp_format = 'never',
          }
        end
      end,
      formatters = {
        prettierd = {
          prepend_args = { '--use-tabs' },
        },
      },
      formatters_by_ft = {
        lua = { 'stylua' },
        bash = { 'beautysh' },
        sh = { 'beautysh' },
        go = { 'goimports' },
        -- You can use 'stop_after_first' to run the first available formatter from the list
        python = { 'isort', 'black', stop_after_first = false },
        svelte = { 'biome', 'biome-organize-imports' },
        javascript = { 'biome', 'biome-organize-imports' },
        typescript = { 'biome', 'biome-organize-imports' },
        javascriptreact = { 'biome', 'biome-organize-imports' },
        typescriptreact = { 'biome', 'biome-organize-imports' },
        json = { 'biome', 'biome-organize-imports' },
        jsonc = { 'biome', 'biome-organize-imports' },
        css = { 'biome', 'biome-organize-imports' },
        graphql = { 'biome', 'biome-organize-imports' },
        html = { 'biome', 'biome-organize-imports' },
        vue = { 'biome', 'biome-organize-imports' },
        toml = { 'biome', 'biome-organize-imports' },
        flow = { 'prettierd', 'prettier', stop_after_first = true },
        angular = { 'prettierd', 'prettier', stop_after_first = true },
        less = { 'prettierd', 'prettier', stop_after_first = true },
        markdown = { 'prettierd', 'prettier', stop_after_first = true },
        scss = { 'prettierd', 'prettier', stop_after_first = true },
        yaml = { 'prettierd', 'prettier', stop_after_first = true },
        http = { 'kulala-fmt' },
      },
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
