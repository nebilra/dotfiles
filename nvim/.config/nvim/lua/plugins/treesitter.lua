return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  build = ':TSUpdate',
  config = function()
    require('nvim-treesitter').setup()

    local ensure_installed = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' }
    local installed = require('nvim-treesitter.config').get_installed()
    local to_install = vim
      .iter(ensure_installed)
      :filter(function(p)
        return not vim.tbl_contains(installed, p)
      end)
      :totable()
    if #to_install > 0 then
      require('nvim-treesitter').install(to_install)
    end

    vim.api.nvim_create_autocmd('FileType', {
      callback = function(args)
        local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)

        if not lang then
          return
        end

        if not require('nvim-treesitter.parsers')[lang] then
          return
        end

        if not vim.tbl_contains(require('nvim-treesitter.config').get_installed(), lang) then
          vim.schedule(function()
            require('nvim-treesitter').install { lang }
          end)
        end

        pcall(vim.treesitter.start, args.buf)
        vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })
  end,
  event = { 'BufReadPost', 'BufNewFile' },
}
