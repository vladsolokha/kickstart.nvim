vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.g.have_nerd_font = true

vim.opt.number = true
-- vim.opt.relativenumber = true

vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
vim.opt.clipboard = 'unnamedplus'

-- Enable break indent
vim.opt.breakindent = true
vim.opt.smartindent = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.shiftwidth = 4

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv 'HOME' .. '/.vim/undodir'
vim.opt.undofile = true

vim.opt.incsearch = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 500

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.keymap.set({ 'n', 'i', 'v', 'x' }, '<C-s>', '<Esc><cmd>w<cr>')

vim.keymap.set('n', '<leader>d', '<cmd>bd<cr>', { desc = 'close buffer' })
vim.keymap.set('n', '<leader>qq', '<cmd>qa<cr>', { desc = 'close nvim' })
vim.keymap.set('n', '<leader>l', '<cmd>Lazy<cr>', { desc = 'lazy' })
vim.keymap.set('n', '<leader>m', '<cmd>Mason<cr>', { desc = 'mason' })

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>xp', vim.diagnostic.goto_prev, { desc = 'previous diagnostic message' })
vim.keymap.set('n', '<leader>xn', vim.diagnostic.goto_next, { desc = 'next diagnostic message' })
vim.keymap.set('n', '<leader>xe', vim.diagnostic.open_float, { desc = 'error messages' })
vim.keymap.set('n', '<leader>xq', vim.diagnostic.setloclist, { desc = 'quickfix diagnostic list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'exit terminal mode' })

--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'right window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-j>', { desc = 'lower window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-k>', { desc = 'upper window' })

vim.keymap.set('n', '<leader>ws', '<cmd>vsplit|bnext<cr>', { desc = 'side split ->' })
vim.keymap.set('n', '<leader>wv', '<cmd>sbn<cr>', { desc = 'down split' })
vim.keymap.set('n', '<leader>wr', '<C-w>r', { desc = 'swap / rotate' })

vim.keymap.set('n', '<leader>e', ':Neotree toggle filesystem reveal right<CR>', { desc = 'Explorer' })

vim.keymap.set('n', '<leader>wd', '<C-w>q', { desc = 'Quit window' })

vim.keymap.set({ 'n', 'v', 'x' }, '<A-Down>', '<cmd>m .+1<cr>==', { desc = 'Move down' })
vim.keymap.set({ 'n', 'v', 'x' }, '<A-Up>', '<cmd>m .-2<cr>==', { desc = 'Move up' })

vim.keymap.set({ 'n' }, '<C-Tab>', '<cmd>bnext<CR>', { desc = 'Next buffer' })
vim.keymap.set({ 'n' }, '<C-S-Tab>', '<cmd>bprev<CR>', { desc = 'Prev buffer' })

vim.keymap.set('n', '<Tab>', '>>')
vim.keymap.set('n', '<S-Tab>', '<<')
vim.keymap.set('v', '<Tab>', '>gv')
vim.keymap.set('v', '<S-Tab>', '<gv')

-- center cursor when jump scrolling
vim.keymap.set('n', 'n', 'nzz')
vim.keymap.set('n', 'N', 'Nzz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', '<C-d>', '<C-d>zz')

vim.keymap.set('n', 'J', 'mzJ`z')
vim.keymap.set('x', '<leader>p', [["_dP]], { desc = 'stamp word' })

vim.keymap.set({ 'n', 'v' }, '<leader>y', [["+y]], { desc = 'yank to system clipboard' })
vim.keymap.set('n', '<leader>Y', [["+Y]], { desc = 'big yank to system clipboard' })

-- vim.keymap.set('n', '<leader>rr', ':split|terminal python3 %<cr>', { desc = 'Run python file down' })
-- vim.keymap.set('n', '<leader>rs', ':vsplit|terminal python3 %<cr>', { desc = 'Run python file side ->' })

vim.keymap.set('n', '<leader>!', '<cmd>CellularAutomaton make_it_rain<CR>', { desc = 'make it rain!' })

-- [[Auto Commands]] - event functions - autocommands
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})