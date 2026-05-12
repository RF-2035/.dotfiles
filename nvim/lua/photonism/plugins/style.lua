return {
  -- ┌─────────────┐
  -- │ Colorscheme │
  -- └─────────────┘
  {
    'Mofiqul/adwaita.nvim',
    lazy = false,
    priority = 1000,

    config = function()
      -- apply the colorscheme
      vim.cmd 'colorscheme adwaita'
      vim.o.background = 'light'

      -- ┌─────────┐
      -- │ Neovide │
      -- └─────────┘
      -- neovide
      if vim.g.neovide then
        -- add frame = "none" to ~/.config/neovide/config.toml to remove the window frame
        vim.o.titlestring = '%t - Neovide'
        -- using adwaita mono as braille fallback (for mini.map)
        if vim.fn.has 'win32' == 1 then
          vim.o.guifont = 'Iosevka Nerd Font,Noto Sans CJK JP:h11'
        else
          vim.o.guifont = 'Iosevka Nerd Font,Adwaita Mono,Noto Sans CJK JP:h11'
        end
        vim.g.neovide_opacity = 0.9
        vim.g.neovide_cursor_short_animation_length = 0.04
      end

      -- ┌──────────┐
      -- │ Terminal │
      -- └──────────┘
      -- set terminal colors (ptyxis gnome.palette)
      vim.g.terminal_color_0 = '#1d1d20'
      vim.g.terminal_color_1 = '#c01c28'
      vim.g.terminal_color_2 = '#26a269'
      vim.g.terminal_color_3 = '#a2734c'
      vim.g.terminal_color_4 = '#12488b'
      vim.g.terminal_color_5 = '#a347ba'
      vim.g.terminal_color_6 = '#2aa1b3'
      vim.g.terminal_color_7 = '#cfcfcf'
      vim.g.terminal_color_8 = '#5d5d5d'
      vim.g.terminal_color_9 = '#f66151'
      vim.g.terminal_color_10 = '#33d17a'
      vim.g.terminal_color_11 = '#e9ad0c'
      vim.g.terminal_color_12 = '#2a7bde'
      vim.g.terminal_color_13 = '#c061cb'
      vim.g.terminal_color_14 = '#33c7de'
      vim.g.terminal_color_15 = '#ffffff'

      vim.api.nvim_create_autocmd({ 'ColorScheme', 'LspAttach' }, {
        callback = function()
          -- use underline to indicate document highlight
          vim.api.nvim_set_hl(0, 'LspReferenceText', { bg = 'NONE', underline = true, force = true })
          vim.api.nvim_set_hl(0, 'LspReferenceRead', { bg = 'NONE', underline = true, force = true })
          vim.api.nvim_set_hl(0, 'LspReferenceWrite', { bg = 'NONE', underline = true, force = true })
          vim.api.nvim_set_hl(0, 'LspDocumentHighlight', { bg = 'NONE', underline = true, force = true })
        end,
      })
    end,
  },
  -- ┌────────────┐
  -- │ Animations │
  -- └────────────┘
  {
    'sphamba/smear-cursor.nvim',
    config = function()
      if vim.g.neovide then
        require('smear_cursor').enabled = false
      else
        require('smear_cursor').setup {
          legacy_computing_symbols_support = true,
          min_horizontal_distance_smear = 3,
          min_vertical_distance_smear = 2,
        }
      end
      -- <leader>ts → toggle smear cursor
      vim.keymap.set('n', '<leader>ts', function()
        require('smear_cursor').enabled = not require('smear_cursor').enabled
        vim.notify(require('smear_cursor').enabled and 'Smear cursor: enabled' or 'Smear cursor: disabled', vim.log.levels.INFO)
      end, { desc = 'Smear', silent = true })
    end,
  },
  -- ┌───────────────┐
  -- │ TODO Comments │
  -- └───────────────┘
  {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false },
  },
}
