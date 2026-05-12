return {
  -- ┌─────────────────────────┐
  -- │ Colors Preview & Picker │
  -- └─────────────────────────┘
  {
    'uga-rosa/ccc.nvim',
    config = function()
      -- NOTE: <leader>cp → color picker
      require('ccc').setup {
        highlighter = {
          auto_enable = true,
          lsp = true,
        },
      }
      vim.keymap.set('n', '<leader>cp', function()
        vim.cmd 'CccPick'
      end, { desc = 'Color Picker', silent = true })
    end,
  },
  -- ┌──────────────┐
  -- │ HTML Preview │
  -- └──────────────┘
  {
    'brianhuster/live-preview.nvim',
  },
  -- ┌──────────────────┐
  -- │ Markdown Preview │
  -- └──────────────────┘
  {
    -- NOTE: <leader>tv → markdown preview toggle
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    build = 'cd app && yarn install',

    init = function()
      vim.g.mkdp_filetypes = { 'markdown' }
      vim.g.mkdp_auto_close = 0
      vim.g.mkdp_combine_preview = 1

      vim.cmd [[
        function! EchoUrl(url)
          if has('clipboard')
            let @+ = a:url
          endif
          echom a:url
        endfunction
      ]]
      vim.g.mkdp_browserfunc = 'g:EchoUrl'
    end,
    ft = { 'markdown' },
  },
}
