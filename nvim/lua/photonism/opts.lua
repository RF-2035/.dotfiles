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

-- terminal scrollback limit
vim.opt.scrollback = 100000

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

-- ┌──────────┐
-- │ Autocmds │
-- └──────────┘

-- highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})
