return { -- Linting
  'mfussenegger/nvim-lint',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    local lint = require 'lint'
    lint.linters_by_ft = {
      markdown = { 'markdownlint' },
      -- javascript = { 'eslint_d' },
      -- javascriptreact = { 'eslint_d' },
      -- typescript = { 'eslint_d' },
      -- typescriptreact = { 'eslint_d' },
    }

    local function has_eslint(bufnr)
      local filename = vim.api.nvim_buf_get_name(bufnr)

      local config = vim.fs.find({
        'eslint.config.js',
        'eslint.config.mjs',
        'eslint.config.cjs',
        '.eslintrc',
        '.eslintrc.js',
        '.eslintrc.cjs',
        '.eslintrc.json',
        '.eslintrc.yml',
        '.eslintrc.yaml',
      }, {
        path = filename,
        upward = true,
      })[1]

      if not config then
        return false
      end

      local root = vim.fs.root(bufnr, { 'package.json', '.git' })

      return root ~= nil and vim.uv.fs_stat(root .. '/node_modules/.bin/eslint') ~= nil
    end

    lint.linters.eslint_d.condition = function(ctx)
      return has_eslint(ctx.bufnr)
    end

    lint.linters.markdownlint = require('lint.util').wrap(lint.linters.markdownlint, function(diagnostic)
      -- ignore "MD013: line length error from markdownlint" error
      if diagnostic.message:find 'MD013' then
        return nil
      end
      return diagnostic
    end)

    -- lint.linters.eslint_d = require('lint.util').wrap(lint.linters.eslint_d, function(diagnostic)
    --   -- try to ignore "No ESLint configuration found" error
    --   -- if diagnostic.message:find("Error: No ESLint configuration found") then -- old version
    --   -- update: 20240814, following is working
    --   if diagnostic.message:find 'Error: Could not find config file' then
    --     return nil
    --   end
    --   return diagnostic
    -- end)
    -- on the specified events.
    local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
    vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
      group = lint_augroup,
      callback = function()
        -- Only run the linter in buffers that you can modify in order to
        -- avoid superfluous noise, notably within the handy LSP pop-ups that
        -- describe the hovered symbol using Markdown.
        if vim.bo.modifiable then
          lint.try_lint(nil, { ignore_errors = true })
        end
      end,
    })
    vim.api.nvim_create_user_command('LintInfo', function()
      local ft = vim.bo.filetype
      local linters = lint.linters_by_ft[ft] or {}

      print('Filetype: ' .. ft)

      for _, name in ipairs(linters) do
        local linter = lint.linters[name]

        local enabled = true

        if linter.condition then
          enabled = linter.condition {
            filename = vim.api.nvim_buf_get_name(0),
            bufnr = vim.api.nvim_get_current_buf(),
          }
        end

        print(string.format('%s: %s', name, enabled and 'ENABLED' or 'DISABLED'))
      end
    end, {})
  end,
}
