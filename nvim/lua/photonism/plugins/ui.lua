return {
  -- ┌───────┐
  -- │ Icons │
  -- └───────┘
  {
    'nvim-tree/nvim-web-devicons',
    config = function()
      vim.opt.termguicolors = true
      require('nvim-web-devicons').setup {
        override = {
          nnn = { icon = '', color = '#00AFFF', cterm_color = '39', name = 'Nnn' },
          lazygit = { icon = '', color = '#B83A1D', cterm_color = '160', name = 'LazyGit' },
          gemini = { icon = '✦', color = '#4285F4', cterm_color = '33', name = 'Gemini' },
        },
      }
    end,
  },
  -- ┌─────────┐
  -- │ Greeter │
  -- └─────────┘
  {
    'mhinz/vim-startify',
    config = function()
      vim.g.startify_fortune_use_unicode = 1

      -- NOTE: <leader>g → Greeter
      vim.keymap.set('n', '<leader>g', function()
        vim.cmd 'Startify'
      end, { desc = 'Greeter', silent = true })

      -- NOTE: in Greeter, o → Open Session, w → Write Session, d → Delete Session
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'startify',
        callback = function()
          vim.keymap.set('n', 'o', function()
            vim.cmd 'SLoad'
          end, { buffer = true, desc = 'Open Session', silent = true })
          vim.keymap.set('n', 'w', function()
            vim.cmd 'SSave'
          end, { buffer = true, desc = 'Write Session', silent = true })
          vim.keymap.set('n', 'd', function()
            vim.cmd 'SDelete'
          end, { buffer = true, desc = 'Delete Session', silent = true })
        end,
      })
    end,
  },
  -- ┌──────────┐
  -- │ Explorer │
  -- └──────────┘
  {
    'nvim-tree/nvim-tree.lua',
    config = function()
      local nvim_tree = require 'nvim-tree'
      nvim_tree.setup {
        hijack_cursor = true,
        disable_netrw = true,
        sync_root_with_cwd = true,
        -- view = {
        --   float = {
        --     enable = true,
        --   },
        -- },
        renderer = {
          root_folder_label = vim.fn.has 'win32' == 1 and ':~:s?$?\\\\..?' or ':~:s?$?/..?',
          icons = {
            glyphs = {
              git = {
                unstaged = '',
                staged = '',
                unmerged = '',
                renamed = '',
                untracked = '',
                deleted = '',
                ignored = '',
              },
            },
          },
        },
        actions = {
          change_dir = {
            global = true,
          },
        },
        trash = {
          cmd = 'trash-put',
        },
        filters = {
          git_ignored = false,
        },
      }

      -- NOTE: <leader>e → Explorer
      vim.keymap.set('n', '<leader>e', function()
        require('nvim-tree.api').tree.open()
      end, { desc = 'nvim-tree: Open', silent = true })

      -- NOTE: h → collapse, l → preview, n → new, <leader>e → close
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'NvimTree',
        callback = function()
          local api = require 'nvim-tree.api'
          vim.keymap.set('n', 'h', api.node.navigate.parent_close, { buffer = true, desc = 'Collapse' })
          vim.keymap.set('n', 'l', api.node.open.preview, { buffer = true, desc = 'Preview' })
          vim.keymap.set('n', 'n', api.fs.create, { buffer = true, desc = 'Create File Or Directory' })
          vim.keymap.set('n', '<leader>e', api.tree.close, { buffer = true, desc = 'Close' })
        end,
      })
    end,
  },
  -- ┌─────────┐
  -- │ Tab Bar │
  -- └─────────┘
  {
    -- NOTE: <leader>b → buffer
    'akinsho/bufferline.nvim',
    version = '*',
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
      local bufferline = require 'bufferline'
      bufferline.setup {
        options = {
          close_command = function(bufnum)
            if vim.api.nvim_get_current_buf() == bufnum then
              vim.cmd 'bprevious'
            end
            vim.cmd('bdelete ' .. bufnum)
          end,
          right_mouse_command = function(bufnum)
            if vim.api.nvim_get_current_buf() == bufnum then
              vim.cmd 'bprevious'
            end
            vim.cmd('bdelete ' .. bufnum)
          end,
          always_show_bufferline = false,
          auto_toggle_bufferline = true,
          style_preset = bufferline.style_preset.no_italic,
          offsets = {
            {
              filetype = 'NvimTree',
              text = 'Explorer',
              highlight = 'BufferlineTab',
              separator = true, -- use a "true" to enable the default, or set your own character
            },
          },
        },
      }

      vim.keymap.set('n', '<leader>ba', function()
        vim.cmd 'enew'
      end, { desc = 'Add', silent = true })

      vim.keymap.set('n', '<leader>bq', function()
        local current_buf = vim.api.nvim_get_current_buf()

        if #vim.fn.getbufinfo { buflisted = 1 } <= 1 then
          vim.cmd 'quit'
        else
          vim.cmd 'bprevious'
          vim.cmd('bdelete ' .. current_buf)
        end
      end, { desc = 'Quit', silent = true })

      vim.keymap.set('n', '<leader>bp', function()
        vim.cmd 'BufferLinePick'
      end, { desc = 'Pick', silent = true })

      vim.keymap.set('n', '<leader>bc', function()
        vim.cmd 'BufferLinePickClose'
      end, { desc = 'Close', silent = true })

      vim.keymap.set('n', '<leader>bl', function()
        vim.cmd 'BufferLineCloseRight'
      end, { desc = 'Close Right', silent = true })

      vim.keymap.set('n', '<leader>bh', function()
        vim.cmd 'BufferLineCloseLeft'
      end, { desc = 'Close Left', silent = true })

      vim.keymap.set('n', '<leader>b<Tab>', function()
        vim.cmd 'BufferLineCycleNext'
      end, { desc = 'Cycle Next', silent = true })

      vim.keymap.set('n', '<leader>b<S-Tab>', function()
        vim.cmd 'BufferLineCyclePrev'
      end, { desc = 'Cycle Prev', silent = true })
    end,
  },
  -- ┌────────────┐
  -- │ Status Bar │
  -- └────────────┘
  {
    'nvim-lualine/lualine.nvim',
    requires = { 'nvim-tree/nvim-web-devicons', opt = true },
    config = function()
      local nvim_tree = {
        sections = {
          lualine_a = {
            function()
              return vim.fn.fnamemodify(vim.fn.getcwd(), ':~:t')
            end,
          },
        },
        filetypes = { 'NvimTree' },
      }
      require('lualine').setup {
        options = {
          section_separators = { left = '', right = '' },
          component_separators = { left = '', right = '' },
        },
        sections = {
          lualine_x = { 'encoding', 'fileformat', 'filetype', 'searchcount' },
        },
        extensions = { nvim_tree },
      }
    end,
  },
  -- ┌───────────┐
  -- │ Key Hints │
  -- └───────────┘
  {
    'folke/which-key.nvim',
    event = 'VimEnter',
    opts = {
      preset = 'modern',
      delay = 0,
      icons = {
        mappings = vim.g.have_nerd_font,
        keys = vim.g.have_nerd_font and {} or {
          Up = '<Up> ',
          Down = '<Down> ',
          Left = '<Left> ',
          Right = '<Right> ',
          C = '<C-…> ',
          M = '<M-…> ',
          D = '<D-…> ',
          S = '<S-…> ',
          CR = '<CR> ',
          Esc = '<Esc> ',
          ScrollWheelDown = '<ScrollWheelDown> ',
          ScrollWheelUp = '<ScrollWheelUp> ',
          NL = '<NL> ',
          BS = '<BS> ',
          Space = '<Space> ',
          Tab = '<Tab> ',
          F1 = '<F1>',
          F2 = '<F2>',
          F3 = '<F3>',
          F4 = '<F4>',
          F5 = '<F5>',
          F6 = '<F6>',
          F7 = '<F7>',
          F8 = '<F8>',
          F9 = '<F9>',
          F10 = '<F10>',
          F11 = '<F11>',
          F12 = '<F12>',
        },
      },

      -- NOTE: names of keychain groups
      spec = {
        { '<leader>s', group = 'Search' },
        { '<leader>t', group = 'Toggle' },
        { '<leader>a', group = 'Assist' },
        { '<leader>b', group = 'Buffer' },
        { '<leader>c', group = 'Commands' },
      },
    },
  },
  -- ┌────────┐
  -- │ Search │
  -- └────────┘
  {
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',

        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      require('telescope').setup {
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }

      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      -- NOTE: <leader>s → search
      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = 'Help' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = 'Keymaps' })
      vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = 'Files' })
      vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = 'Scopes' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = 'Word' })
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = 'Grep' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = 'Diagnostics' })
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = 'Resume' })
      vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = 'Recent' })
      vim.keymap.set('n', '<leader>sb', builtin.buffers, { desc = 'Buffers' })

      vim.keymap.set('n', '<leader>sc', function()
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = 'Current' })

      vim.keymap.set('n', '<leader>so', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = 'Open' })

      vim.keymap.set('n', '<leader>sn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = 'Neovim' })
    end,
  },
  -- ┌───────────┐
  -- │ mini.nvim │
  -- └───────────┘
  {
    'echasnovski/mini.nvim',
    config = function()
      -- ┌──────────────────┐
      -- │ mini.indentscope │
      -- └──────────────────┘
      -- this setting fits vim.o.foldmethod='expr' vim.o.foldexpr='v:lua.vim.treesitter.foldexpr()'
      local indentscope = require 'mini.indentscope'
      indentscope.setup {
        options = {
          indent_at_cursor = false,
          try_as_border = true,
        },
        symbol = '▏',
      }

      -- ┌──────────┐
      -- │ mini.map │
      -- └──────────┘
      local minimap = require 'mini.map'
      minimap.setup {
        integrations = {
          minimap.gen_integration.builtin_search(),
          minimap.gen_integration.diff(),
          minimap.gen_integration.diagnostic(),
          minimap.gen_integration.gitsigns(),
        },
        symbols = {
          encode = minimap.gen_encode_symbols.dot '4x2',
        },
        window = {
          focusable = true,
          side = 'right',
          width = 15,
        },
      }

      local map_source_win = nil
      local view_file = vim.fn.stdpath 'state' .. '/minimap_toggle_view.vim'

      local function save_view()
        map_source_win = vim.api.nvim_get_current_win()
        local original_vop = vim.o.viewoptions
        vim.o.viewoptions = 'folds'
        vim.cmd('silent! mkview! ' .. vim.fn.fnameescape(view_file))
        vim.o.viewoptions = original_vop
        vim.cmd 'normal! zR'
      end

      local function restore_view()
        if map_source_win and vim.api.nvim_win_is_valid(map_source_win) then
          vim.api.nvim_win_call(map_source_win, function()
            local target_pos = vim.api.nvim_win_get_cursor(0)
            local original_vop = vim.o.viewoptions
            vim.o.viewoptions = 'folds'
            vim.cmd('silent! source ' .. vim.fn.fnameescape(view_file))
            vim.o.viewoptions = original_vop
            pcall(vim.api.nvim_win_set_cursor, 0, target_pos)
            vim.cmd 'normal! zvzz^'
          end)
        end
        map_source_win = nil
      end

      -- NOTE: <leader>m → minimap
      vim.keymap.set('n', '<leader>m', function()
        local is_open = minimap.current.win_data[vim.api.nvim_get_current_tabpage()] ~= nil
        if is_open then
          minimap.close()
          restore_view()
        else
          save_view()
          minimap.open()
          vim.schedule(function()
            minimap.toggle_focus()
          end)
        end
      end, { desc = 'Map', silent = true })

      -- NOTE: in minimap, q or focus loss → close minimap and restore folds
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'minimap',
        callback = function(args)
          vim.keymap.set('n', 'q', function()
            minimap.close()
            vim.schedule(restore_view)
          end, { buffer = args.buf, desc = 'Close', silent = true })
        end,
      })

      vim.api.nvim_create_autocmd('WinLeave', {
        group = vim.api.nvim_create_augroup('MiniMapAutoClose', { clear = true }),
        callback = function()
          local cur_win = vim.api.nvim_get_current_win()
          local buf_name = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(cur_win))
          if buf_name:match 'minimap://' then
            minimap.close()
            vim.schedule(restore_view)
          end
        end,
      })
    end,
  },
}
