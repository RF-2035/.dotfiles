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

-- NOTE: gx → try local files first, then gx

vim.keymap.set({ 'n', 'i', 'v', 't', 'c' }, 'gx', function()
  local cfile = vim.fn.expand '<cfile>'
  if not cfile or cfile == '' then
    return
  end
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
  vim.cmd 'normal! gx'
end, { desc = 'Search for local reference or go to web/file (gx)' })

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
