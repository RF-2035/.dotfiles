--  NOTE:──────────────────────────────────────────────────────────────────────┐
--  │                                                                          │
--  │ MODIFIED FROM KICKSTART.NVIM                                             │
--  │                                                                          │
--  │ enable UTF-8:                                                            │
--  │   - nano /etc/locale.conf         # write LANG=en_US.UTF-8               │
--  │   - nano /etc/locale.gen          # uncomment en_US.UTF-8 UTF-8          │
--  │   - locale-gen                                                           │
--  │                                                                          │
--  │ install the dependencies:                                                │
--  │   - pacman -S neovim git base-devel stow yarn nnn fzf lazygit tmux       │
--  │   - git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si │
--  │   - yay -S pandoc-bin                                                    │
--  │                                                                          │
--  │ install node modules:                                                    │
--  │   - npm install --prefix ~/.opt/gemini -g @google/gemini-cli             │
--  │   - ln -s ~/.opt/gemini/bin/gemini ~/.local/bin/gemini                   │
--  │                                                                          │
--  │ apply the config:                                                        │
--  │   - git clone https://github.com/RF-2035/.dotfiles.git ~/.dotfiles       │
--  │   - cd ~/.dotfiles && stow nvim                                          │
--  └──────────────────────────────────────────────────────────────────────────┘

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true

-- ┌──────────┐
-- │ Settings │
-- └──────────┘

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.mouse = 'a'
vim.opt.showmode = false

vim.opt.tabstop = 4
vim.opt.breakindent = true

-- save undo history
vim.opt.undofile = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.signcolumn = 'yes'
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

vim.opt.splitright = true
vim.opt.splitbelow = true

-- whitespace display
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- substitutions preview
vim.opt.inccommand = 'split'

vim.opt.cursorline = true
vim.opt.scrolloff = 10
vim.opt.confirm = true

-- window title
vim.opt.title = true
vim.opt.titlestring = '%t - Nvim'

-- share clipboard
vim.opt.clipboard = 'unnamedplus'

-- disable shortmess find occurance count (:set shortmess+=S)
vim.opt.shortmess:append 'S'

-- ┌───────────┐
-- │ Platforms │
-- └───────────┘

-- Windows-specific terminal setup
if vim.fn.has 'win32' == 1 then
  vim.opt.shell = 'pwsh.exe'
  vim.opt.shellcmdflag = '-NoLogo -ExecutionPolicy RemoteSigned -Command'
  vim.opt.shellquote = ''
  vim.opt.shellxquote = ''
end

-- ┌───────────────┐
-- │ Basic Keymaps │
-- └───────────────┘

-- NOTE: <Esc> → clear highlights on search
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- NOTE: <Esc><Esc> or `` → exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
vim.keymap.set('t', '``', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- NOTE: CTRL+<hjkl> → move focus
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- NOTE: CTRL+<LeftMouse> → move cursor to clicked position and run gx

local function sanitize_link_for_path(link)
  local path_str = link
  path_str = path_str:gsub('^https?://', '')
  path_str = path_str:gsub('[?#].*$', '')
  path_str = path_str:gsub('^/*', ''):gsub('/*$', '')
  path_str = path_str:gsub('[%*:<>%?|]', '_')
  return path_str
end

local function find_local_reference(sanitized_path, ext)
  local safe_path = vim.fn.escape(sanitized_path, '[]')
  local pattern = '**/*' .. safe_path .. ext
  local matches = vim.fn.glob(pattern, true, true)
  if matches and #matches > 0 then
    return matches[1]
  end
  return nil
end

vim.keymap.set({ 'n', 'i', 'v', 't', 'c' }, '<C-LeftMouse>', function()
  local mouse_pos = vim.fn.getmousepos()
  vim.api.nvim_win_set_cursor(0, { mouse_pos.line, mouse_pos.column - 1 })
  local cfile = vim.fn.expand '<cfile>'
  if not cfile or cfile == '' then
    return
  end
  if cfile:match '^https?://' then
    local sanitized = sanitize_link_for_path(cfile)
    local md_path = find_local_reference(sanitized, '.md')
    if md_path then
      vim.cmd('edit ' .. vim.fn.fnameescape(md_path))
      return
    end
    local pdf_path = find_local_reference(sanitized, '.pdf')
    if pdf_path then
      vim.ui.open(pdf_path)
      return
    end
    vim.ui.open(cfile)
  else
    vim.ui.open(cfile)
  end
end, { desc = 'Search for local reference or go to web/file (Ctrl + Left Mouse)' })

-- NOTE: CTRL+<Insert> → copy to clipboard

vim.keymap.set({ 'n', 'v' }, '<C-Insert>', '"+y', { desc = 'Copy to clipboard' })
vim.keymap.set({ 'i' }, '<C-Insert>', '<Esc>"+y', { desc = 'Copy to clipboard' })
vim.keymap.set('t', '<C-Insert>', '<C-\\><C-N>"+y', { desc = 'Copy to clipboard' })

-- NOTE: CTRL+SHIFT+C → copy to clipboard

vim.keymap.set({ 'n', 'v' }, '<C-S-c>', '"+y', { desc = 'Copy to clipboard' })
vim.keymap.set({ 'i' }, '<C-S-c>', '<Esc>"+y', { desc = 'Copy to clipboard' })
vim.keymap.set('t', '<C-S-c>', '<C-\\><C-N>"+y', { desc = 'Copy to clipboard' })

-- NOTE: SHIFT+<Insert> → paste from clipboard

vim.keymap.set({ 'n', 'v' }, '<S-Insert>', '"+p', { desc = 'Paste from clipboard' })
vim.keymap.set({ 'i' }, '<S-Insert>', '<Esc>"+p', { desc = 'Paste from clipboard' })
vim.keymap.set({ 'c' }, '<S-Insert>', '<C-R>+', { desc = 'Paste from clipboard' })
vim.keymap.set('t', '<S-Insert>', '<C-\\><C-N>"+p', { desc = 'Paste from clipboard' })

-- NOTE: CTRL+SHIFT+<Insert> → paste from clipboard

vim.keymap.set({ 'n', 'v' }, '<C-S-Insert>', '"+p', { desc = 'Paste from clipboard' })
vim.keymap.set({ 'i' }, '<C-S-Insert>', '<Esc>"+p', { desc = 'Paste from clipboard' })
vim.keymap.set({ 'c' }, '<C-S-Insert>', '<C-R>+', { desc = 'Paste from clipboard' })
vim.keymap.set('t', '<C-S-Insert>', '<C-\\><C-N>"+p', { desc = 'Paste from clipboard' })

-- NOTE: CTRL+SHIFT+V → paste from clipboard

vim.keymap.set({ 'n', 'v' }, '<C-S-v>', '"+p', { desc = 'Paste from clipboard' })
vim.keymap.set({ 'i' }, '<C-S-v>', '<Esc>"+p', { desc = 'Paste from clipboard' })
vim.keymap.set({ 'c' }, '<C-S-v>', '<C-R>+', { desc = 'Paste from clipboard' })
vim.keymap.set('t', '<C-S-v>', '<C-\\><C-N>"+p', { desc = 'Paste from clipboard' })

-- NOTE: <leader>t → toggle

vim.api.nvim_create_autocmd('TermClose', {
  pattern = '*',
  callback = function(event)
    if vim.v.event.status == 0 then
      if vim.api.nvim_buf_is_valid(event.buf) then
        if vim.api.nvim_get_current_buf() == event.buf then
          vim.cmd 'bprevious'
        end
        vim.api.nvim_buf_delete(event.buf, { force = true })
      end
    end
  end,
})

vim.keymap.set('n', '<leader>tt', function()
  vim.cmd 'terminal'
  vim.cmd 'startinsert'
end, { desc = 'Terminal', silent = true })

vim.keymap.set('n', '<leader>tg', function()
  vim.cmd 'terminal lazygit'
  vim.cmd 'file LazyGit'
  vim.cmd 'startinsert'
end, { desc = 'LazyGit', silent = true })

vim.keymap.set('n', '<leader>tn', function()
  vim.cmd 'terminal nnn'
  vim.cmd 'file nnn'
  vim.cmd 'startinsert'
end, { desc = 'Nnn', silent = true })

-- <leader>tp → toggle clipboard sharing

vim.keymap.set({ 'n', 'v' }, '<leader>tp', function()
  ---@diagnostic disable-next-line: undefined-field
  local current_clipboard = vim.opt.clipboard:get()
  if vim.tbl_contains(current_clipboard, 'unnamedplus') then
    vim.opt.clipboard = ''
    vim.notify('Clipboard sharing: OFF', vim.log.levels.INFO)
  else
    vim.opt.clipboard = 'unnamedplus'
    vim.notify('Clipboard sharing: ON', vim.log.levels.INFO)
  end
end, { desc = 'Clipboard', silent = true })

-- if clipboard sharing is enabled, get from + register, otherwise from " register

local function clipboard_get()
  local clipboard_option = vim.opt.clipboard:get()
  local register = vim.tbl_contains(clipboard_option, 'unnamedplus') and '+' or '"'
  return vim.fn.getreg(register)
end

-- <leader>te → toggle swapping ` and <Esc>

local keys_swapped = false

vim.keymap.set({ 'n', 'v' }, '<leader>te', function()
  if keys_swapped then
    -- Remove swap mappings (restore defaults)
    vim.keymap.del({ 'n', 'i', 'v', 't', 'c' }, '`')
    vim.keymap.del({ 'n', 'i', 'v', 't', 'c' }, '<Esc>')
    -- Restore original mappings
    vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
    keys_swapped = false
    vim.notify('Key swap: OFF (` and Esc restored)', vim.log.levels.INFO)
  else
    -- Remove original mappings
    vim.keymap.del('n', '<Esc>')
    -- Add swap mappings
    vim.keymap.set('n', '<Esc>', '`', { desc = 'Backtick (swapped)' })
    vim.keymap.set('n', '`', '<cmd>nohlsearch<CR>', { desc = 'Escape (swapped)' })
    vim.keymap.set({ 'i', 'v', 't', 'c' }, '`', '<Esc>', { desc = 'Escape (swapped)' })
    vim.keymap.set({ 'i', 'v', 't', 'c' }, '<Esc>', '`', { desc = 'Backtick (swapped)' })
    keys_swapped = true
    vim.notify('Key swap: ON (` acts as Esc)', vim.log.levels.INFO)
  end
end, { desc = 'Escape/Backtick', silent = true })

-- NOTE: <leader>c → commands

-- <leader>ce → Paste as Commands
vim.keymap.set('n', '<leader>ce', function()
  local cmds = clipboard_get()
  if not cmds or #cmds == 0 then
    vim.notify('Clipboard is empty.', vim.log.levels.WARN)
    return
  end
  vim.cmd 'redraw!'
  local message = 'Execute?\n\n' .. cmds
  local choice = vim.fn.confirm(message, '&Yes\n&No', 2, 'Question')
  vim.cmd 'redraw!'
  if choice == 1 then
    vim.fn.setreg('"', cmds)
    vim.cmd 'normal! @"'
    -- else
    --   vim.notify('Execution cancelled.', vim.log.levels.INFO)
  end
end, { desc = 'Execute', silent = true })

-- <leader>cl → List Locations
vim.keymap.set('n', '<leader>cl', vim.diagnostic.setloclist, { desc = 'List Locations' })

-- <leader>cf → LSP format (set under `conform.nvim`)

-- <leader>cs → search online
vim.keymap.set('n', '<leader>cs', function()
  local selection = clipboard_get()
  if not selection or #selection == 0 then
    vim.notify('Clipboard is empty.', vim.log.levels.WARN)
    return
  end
  local lines = vim.split(selection, '\n')
  for _, line in ipairs(lines) do
    if line:match '%S' then -- Only search non-empty lines
      local query = line:gsub('%s+', '+')
      local search_url = 'https://libgen.li/index.php?req=' .. query
      vim.ui.open(search_url)
      vim.wait(200)
    end
  end
end, { desc = 'Search: LibGen', silent = true })

-- <leader>cd → DOI to APA
vim.keymap.set('n', '<leader>cd', function()
  local clipboard = clipboard_get()
  if not clipboard or #clipboard == 0 then
    vim.notify('Clipboard is empty.', vim.log.levels.WARN)
    return
  end
  local doi_list = vim.split(clipboard, '\n')
  local citations = {}
  for _, doi in ipairs(doi_list) do
    doi = doi:gsub('%s+', '')
    if #doi > 0 then
      vim.notify('Processing: ' .. doi, vim.log.levels.INFO)
      local cmd = {
        'curl',
        '-sSLH', -- s: silent, S: show errors, L: follow redirects
        'Accept: text/x-bibliography; style=apa',
        'https://doi.org/' .. doi,
      }
      local result = vim.fn.system(cmd)
      if vim.v.shell_error == 0 and not result:match '<!DOCTYPE html>' then
        table.insert(citations, vim.trim(result))
      else
        vim.notify('Failed to fetch: ' .. doi, vim.log.levels.INFO)
      end
    end
  end
  if #citations > 0 then
    local citations_string = table.concat(citations, '\n')
    vim.fn.setreg('+', citations_string)
    vim.notify('Citations copied to clipboard.', vim.log.levels.INFO)
  end
end, { desc = 'Search: DOI' })

-- ┌──────────────────────┐
-- │ Keymaps for Markdown │
-- └──────────────────────┘

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'markdown',
  callback = function(event)
    vim.keymap.set('n', '<leader>cv', '<cmd>MarkdownPreviewToggle<CR>', { desc = 'Preview', buffer = event.buf })

    vim.keymap.set('n', '<leader>cm', function()
      local cmd_string = "for i in range(, , -1) | execute '%s/c' . i . '::/c' . (i + 1) . '::/g' | endfor"
      local cursor_pos = string.len 'for i in range('
      vim.fn.feedkeys(':' .. cmd_string, 'i')
      local keys_to_move_cursor = #cmd_string - cursor_pos
      vim.fn.feedkeys(vim.api.nvim_replace_termcodes(string.rep('<Left>', keys_to_move_cursor), true, false, true))
    end, { desc = 'Move Clozes', buffer = event.buf, silent = true })

    vim.keymap.set('n', '<leader>cy', function()
      local buffer_content = vim.api.nvim_buf_get_lines(0, 0, -1, false)
      if not buffer_content or #buffer_content == 0 then
        vim.notify('Buffer is empty, nothing to convert.', vim.log.levels.WARN)
        return
      end
      local content_string = table.concat(buffer_content, '\n')
      local pandoc_cmd = {
        'pandoc',
        '--from=markdown',
        '--to=html',
        '-o',
        '-',
        '--katex',
        '--columns',
        '10000',
      }
      vim.notify('Running Pandoc...', vim.log.levels.INFO)
      vim.system(pandoc_cmd, {
        stdin = content_string,
        text = true,
      }, function(result)
        vim.schedule(function()
          if result.code == 0 then
            vim.fn.setreg('+', result.stdout)
            vim.notify('Pandoc conversion complete. HTML copied to clipboard.', vim.log.levels.INFO)
          else
            local error_message = 'Pandoc failed with code: ' .. result.code
            if result.stderr and #result.stderr > 0 then
              error_message = error_message .. '\n---[Stderr]---\n' .. result.stderr
            end
            if result.stdout and #result.stdout > 0 then
              error_message = error_message .. '\n---[Stdout]---\n' .. result.stdout
            end
            vim.notify(error_message, vim.log.levels.ERROR, {
              title = 'Pandoc Error',
            })
          end
        end)
      end)
    end, { desc = 'Yank HTML', buffer = event.buf, silent = true })
  end,
})

-- ┌───────────────┐
-- │ Optimizations │
-- └───────────────┘

-- highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Install `lazy.nvim`
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- ┌──────────────┐
-- │ Lazy Plugins │
-- └──────────────┘

require('lazy').setup({
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically
  -- { 'google/vim-searchindex' },

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

  -- ┌─────────────┐
  -- │ Vibe Coding │
  -- └─────────────┘
  { -- Copilot Completion
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter',
    config = function()
      require('copilot').setup {
        suggestion = {
          auto_trigger = true,
          keymap = {
            -- NOTE: <Tab> or <C-]> → complete, <C-[> → dismiss
            -- NOTE: <M-]> → next, <M-[> → previous
            accept = '<C-]>',
            accept_word = false,
            accept_line = false,
            next = '<M-]>',
            prev = '<M-[>',
            dismiss = '<C-[>',
            toggle_auto_trigger = false,
          },
        },
        filetypes = {
          ['*'] = true,
        },
      }
      -- NOTE: <leader>cc → copilot panel
      vim.keymap.set('n', '<leader>cc', function()
        vim.cmd 'Copilot panel'
      end, { desc = 'Completions', silent = true })
    end,
  },
  { -- Copilot NES (Next Edit Suggestion)
    'copilotlsp-nvim/copilot-lsp',
  },
  { -- Sidekick CLI for LSP-powered tools and Copilot NES
    'folke/sidekick.nvim',
    opts = {
      cli = {
        mux = {
          enabled = true,
          backend = 'tmux',
        },
      },
    },

    keys = {
      {
        '<c-]>',
        function()
          -- if there is a next edit, jump to it, otherwise apply it if any
          if not require('sidekick').nes_jump_or_apply() then
            return '<c-]>' -- fallback to normal <c-]>
          end
        end,
        expr = true,
        desc = 'Goto/Apply Next Edit Suggestion',
      },
      {
        '<c-.>',
        function()
          require('sidekick.cli').toggle()
        end,
        desc = 'Sidekick Toggle',
        mode = { 'n', 't', 'i', 'x' },
      },
      {
        '<leader>aa',
        function()
          require('sidekick.cli').toggle()
        end,
        desc = 'Toggle',
      },
      {
        '<leader>as',
        function()
          require('sidekick.cli').select()
        end,
        -- Or to select only installed tools:
        -- require("sidekick.cli").select({ filter = { installed = true } })
        desc = 'Select',
      },
      {
        '<leader>ad',
        function()
          require('sidekick.cli').close()
        end,
        desc = 'Detach',
      },
      {
        '<leader>at',
        function()
          require('sidekick.cli').send { msg = '{this}' }
        end,
        mode = { 'x', 'n' },
        desc = 'This',
      },
      {
        '<leader>af',
        function()
          require('sidekick.cli').send { msg = '{file}' }
        end,
        desc = 'File',
      },
      {
        '<leader>av',
        function()
          require('sidekick.cli').send { msg = '{selection}' }
        end,
        mode = { 'x' },
        desc = 'Visual Selection',
      },
      {
        '<leader>ap',
        function()
          require('sidekick.cli').prompt()
        end,
        mode = { 'n', 'x' },
        desc = 'Prompt',
      },
      {
        '<leader>ag',
        function()
          require('sidekick.cli').toggle { name = 'gemini', focus = true }
        end,
        desc = 'Gemini',
      },
    },
  },

  -- ┌──────────────┐
  -- │ Code Folding │
  -- └──────────────┘
  { 'kevinhwang91/promise-async' },
  {
    'kevinhwang91/nvim-ufo',
    dependencies = 'kevinhwang91/promise-async',
    config = function()
      require('ufo').setup {
        provider_selector = function(bufnr, filetype, buftype)
          return { 'treesitter', 'indent' }
        end,
      }

      vim.opt.foldlevel = 99
      vim.opt.foldlevelstart = 99
      vim.opt.foldmethod = 'expr'
      vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'

      -- NOTE: <leader>l, <leader>h → open fold, close fold
      vim.keymap.set('n', '<leader>l', function()
        vim.cmd 'normal! zo'
      end, { desc = 'Fold Open' })
      vim.keymap.set('n', '<leader>h', function()
        vim.cmd 'normal! zc'
      end, { desc = 'Fold Close' })

      -- NOTE: zR, zM → open all folds, close all folds
      vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
      vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
    end,
  },

  -- ┌────────────────────────┐
  -- │ Color Picker & Preview │
  -- └────────────────────────┘
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

  -- ┌─────────────────────────┐
  -- │ HTML & Markdown Preview │
  -- └─────────────────────────┘
  { 'brianhuster/live-preview.nvim' },
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
  -- │ Git Signs │
  -- └───────────┘
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
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

  -- ┌────────────┐
  -- │ LSP Config │
  -- └────────────┘
  {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
  {
    -- Main LSP Configuration
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      -- Mason must be loaded before its dependents so we need to set it up here.
      -- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
      { 'williamboman/mason.nvim', opts = {} },
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      -- Useful status updates for LSP.
      { 'j-hui/fidget.nvim', opts = {} },

      -- Allows extra capabilities provided by blink.cmp
      'saghen/blink.cmp',
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          -- NOTE: Remember that Lua is a real programming language, and as such it is possible
          -- to define small helper and utility functions so you don't have to repeat yourself.
          --
          -- In this case, we create a function that lets us more easily define mappings specific
          -- for LSP related items. It sets the mode, buffer and description for us each time.
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          -- Rename the variable under your cursor.
          --  Most Language Servers support renaming across files, etc.
          map('grn', vim.lsp.buf.rename, '[R]e[n]ame')

          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })

          -- Find references for the word under your cursor.
          map('grr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

          -- Jump to the implementation of the word under your cursor.
          --  Useful when your language has ways of declaring types without an actual implementation.
          map('gri', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

          -- Jump to the definition of the word under your cursor.
          --  This is where a variable was first declared, or where a function is defined, etc.
          --  To jump back, press <C-t>.
          map('grd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header.
          map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          -- Fuzzy find all the symbols in your current document.
          --  Symbols are things like variables, functions, types, etc.
          map('gO', require('telescope.builtin').lsp_document_symbols, 'Open Document Symbols')

          -- Fuzzy find all the symbols in your current workspace.
          --  Similar to document symbols, except searches over your entire project.
          map('gW', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Open Workspace Symbols')

          -- Jump to the type of the word under your cursor.
          --  Useful when you're not sure what type a variable is and you want to see
          --  the definition of its *type*, not where it was *defined*.
          map('grt', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype Definition')

          -- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
          ---@param client vim.lsp.Client
          ---@param method vim.lsp.protocol.Method
          ---@param bufnr? integer some lsp support methods only in specific files
          ---@return boolean
          local function client_supports_method(client, method, bufnr)
            if vim.fn.has 'nvim-0.11' == 1 then
              return client:supports_method(method, bufnr)
            else
              ---@diagnostic disable-next-line: param-type-mismatch
              return client.supports_method(method, { bufnr = bufnr })
            end
          end

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          -- The following code creates a keymap to toggle inlay hints in your
          -- code, if the language server you are using supports them
          --
          -- This may be unwanted, since they displace some of your code
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, 'Inlay Hints')
          end
        end,
      })

      -- Diagnostic Config
      -- See :help vim.diagnostic.Opts
      vim.diagnostic.config {
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many' },
        underline = { severity = vim.diagnostic.severity.ERROR },
        signs = vim.g.have_nerd_font and {
          text = {
            [vim.diagnostic.severity.ERROR] = '󰅚 ',
            [vim.diagnostic.severity.WARN] = '󰀪 ',
            [vim.diagnostic.severity.INFO] = '󰋽 ',
            [vim.diagnostic.severity.HINT] = '󰌶 ',
          },
        } or {},
        virtual_text = {
          source = 'if_many',
          spacing = 2,
          format = function(diagnostic)
            local diagnostic_message = {
              [vim.diagnostic.severity.ERROR] = diagnostic.message,
              [vim.diagnostic.severity.WARN] = diagnostic.message,
              [vim.diagnostic.severity.INFO] = diagnostic.message,
              [vim.diagnostic.severity.HINT] = diagnostic.message,
            }
            return diagnostic_message[diagnostic.severity]
          end,
        },
      }

      local capabilities = require('blink.cmp').get_lsp_capabilities()

      local servers = {
        lua_ls = {
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
            },
          },
        },
      }

      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'stylua',
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      ---@diagnostic disable-next-line: missing-fields
      require('mason-lspconfig').setup {
        ensure_installed = {},
        automatic_installation = false,
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
    end,
  },

  -- ┌────────────────┐
  -- │ LSP Autoformat │
  -- └────────────────┘
  { -- Autoformat
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    -- NOTE: <leader>cf → format buffer
    keys = {
      {
        '<leader>cf',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = '',
        desc = 'Format Buffer',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = { c = true, cpp = true }
        if disable_filetypes[vim.bo[bufnr].filetype] then
          return nil
        else
          return {
            timeout_ms = 500,
            lsp_format = 'fallback',
          }
        end
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
      },
    },
  },

  -- ┌────────────────────┐
  -- │ LSP Autocompletion │
  -- └────────────────────┘
  { -- Autocompletion
    'saghen/blink.cmp',
    event = 'VimEnter',
    version = '1.*',
    dependencies = {
      -- Snippet Engine
      {
        'L3MON4D3/LuaSnip',
        version = '2.*',
        build = (function()
          -- Build Step is needed for regex support in snippets.
          -- This step is not supported in many windows environments.
          -- Remove the below condition to re-enable on windows.
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        dependencies = {
          -- `friendly-snippets` contains a variety of premade snippets.
          --    See the README about individual language/framework/plugin snippets:
          --    https://github.com/rafamadriz/friendly-snippets
          -- {
          --   'rafamadriz/friendly-snippets',
          --   config = function()
          --     require('luasnip.loaders.from_vscode').lazy_load()
          --   end,
          -- },
        },
        opts = {},
      },
      'folke/lazydev.nvim',
    },
    --- @module 'blink.cmp'
    --- @type blink.cmp.Config
    opts = {
      keymap = {
        -- 'default' (recommended) for mappings similar to built-in completions
        --   <c-y> to accept ([y]es) the completion.
        --    This will auto-import if your LSP supports it.
        --    This will expand snippets if the LSP sent a snippet.
        -- 'super-tab' for tab to accept
        -- 'enter' for enter to accept
        -- 'none' for no mappings
        --
        -- For an understanding of why the 'default' preset is recommended,
        -- you will need to read `:help ins-completion`
        --
        -- No, but seriously. Please read `:help ins-completion`, it is really good!
        --
        -- All presets have the following mappings:
        -- <tab>/<s-tab>: move to right/left of your snippet expansion
        -- <c-space>: Open menu or open docs if already open
        -- <c-n>/<c-p> or <up>/<down>: Select next/previous item
        -- <c-e>: Hide menu
        -- <c-k>: Toggle signature help
        --
        -- See :h blink-cmp-config-keymap for defining your own keymap
        preset = 'default',

        ['<Tab>'] = {
          function(cmp)
            -- 1. Completion Menu
            if cmp.is_visible() then
              return cmp.select_next()
            end

            -- 2. Copilot Suggestion (Ghost Text)
            local copilot_suggestion = require 'copilot.suggestion'
            if copilot_suggestion.is_visible() then
              copilot_suggestion.accept()
              return true
            end

            -- 3. Sidekick Next Edit Suggestion (NES)
            if require('sidekick').nes_jump_or_apply() then
              return true
            end

            -- 4. Snippets (Jump Forward)
            if cmp.snippet_active() then
              return cmp.snippet_forward()
            end

            -- 5. Fallback
            return false
          end,
          'fallback',
        },

        -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
        --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
      },

      appearance = {
        -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = 'mono',
      },

      completion = {
        -- By default, you may press `<c-space>` to show the documentation.
        -- Optionally, set `auto_show = true` to show the documentation after a delay.
        documentation = { auto_show = false, auto_show_delay_ms = 500 },
      },

      sources = {
        default = { 'lsp', 'path', 'snippets', 'lazydev' },
        providers = {
          lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
        },
      },

      snippets = { preset = 'luasnip' },

      -- Blink.cmp includes an optional, recommended rust fuzzy matcher,
      -- which automatically downloads a prebuilt binary when enabled.
      --
      -- By default, we use the Lua implementation instead, but you may enable
      -- the rust implementation via `'prefer_rust_with_warning'`
      --
      -- See :h blink-cmp-config-fuzzy for more information
      fuzzy = { implementation = 'lua' },

      -- Shows a signature help window while you type arguments for a function
      signature = { enabled = true },
    },
  },

  -- ┌────────────┐
  -- │ Appearance │
  -- └────────────┘
  {
    'Mofiqul/adwaita.nvim',
    lazy = false,
    priority = 1000,

    config = function()
      -- neovide
      if vim.g.neovide then
        vim.o.background = 'light'
        -- add frame = "none" to ~/.config/neovide/config.toml to remove the window frame
        vim.o.titlestring = '%t - Neovide'
        -- using adwaita mono as braille fallback (for mini.map)
        if vim.fn.has 'win32' == 1 then
          vim.o.guifont = 'Iosevka Nerd Font,Noto Sans CJK JP:h11'
        else
          vim.o.guifont = 'Iosevka Nerd Font,Adwaita Mono,Noto Sans CJK JP:h11'
        end
        vim.g.neovide_opacity = 0.9
        -- vim.g.neovide_padding_top = 12
        vim.g.neovide_cursor_short_animation_length = 0.04
      end

      -- apply the colorscheme
      vim.cmd 'colorscheme adwaita'
      vim.o.background = 'light'

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

  -- todo comments highlight
  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },

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

  -- ┌─────────────────┐
  -- │ nvim-treesitter │
  -- └─────────────────┘
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs', -- Sets main module to use for opts
    -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
    opts = {
      ensure_installed = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' },
      -- Autoinstall languages that are not installed
      auto_install = true,
      highlight = {
        enable = true,
        -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
        --  If you are experiencing weird indenting issues, add the language to
        --  the list of additional_vim_regex_highlighting and disabled languages for indent.
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby' } },
    },
    -- There are additional nvim-treesitter modules that you can use to interact
    -- with nvim-treesitter. You should go explore a few and see what interests you:
    --
    --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
    --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
    --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
  },

  -- The following comments only work if you have downloaded the kickstart repo, not just copy pasted the
  -- init.lua. If you want these files, they are in the repository, so you can just download them and
  -- place them in the correct locations.

  -- NOTE: Next step on your Neovim journey: Add/Configure additional plugins for Kickstart
  --
  --  Here are some example plugins that I've included in the Kickstart repository.
  --  Uncomment any of the lines below to enable them (you will need to restart nvim).
  --
  -- require 'kickstart.plugins.debug',
  -- require 'kickstart.plugins.indent_line',
  -- require 'kickstart.plugins.lint',
  -- require 'kickstart.plugins.autopairs',
  -- require 'kickstart.plugins.neo-tree',
  -- require 'kickstart.plugins.gitsigns', -- adds gitsigns recommend keymaps

  -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    This is the easiest way to modularize your config.
  --
  --  Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
  -- { import = 'custom.plugins' },
  --
  -- For additional information with loading, sourcing and examples see `:help lazy.nvim-🔌-plugin-spec`
  -- Or use telescope!
  -- In normal mode type `<space>sh` then write `lazy.nvim-plugin`
  -- you can continue same window with `<space>sr` which resumes last telescope search
  ---@diagnostic disable-next-line: missing-fields
}, {
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
