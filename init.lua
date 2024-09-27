vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true
vim.g.netrw_keepdir = 0
vim.g.netrw_banner = 0 -- use I inside to show banner
vim.g.netrw_localcopydircmd = 'cp -r'
-- cursor options
vim.cmd('hi iCursor gui=NONE guibg=Red guifg=NONE')
vim.cmd('hi defCursor gui=NONE guibg=White guifg=Black')
vim.cmd('hi visCursor gui=NONE guibg=Green guifg=Yellow')
vim.opt.guicursor = "a:blinkon0-defCursor,i-r:iCursor,v-ve:visCursor"
vim.opt.termguicolors = true
vim.opt.showmode = false
vim.opt.fillchars = { eob = " " }
vim.opt.laststatus = 3      -- always show status at bottom
local function git_branch() -- show git branch in status
  local branch = vim.fn.system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
  if string.len(branch) > 0 then
    return branch
  else
    return ":"
  end
end
local function statusline()
  local branch = git_branch()
  local file_name = "%F"    -- full filename
  local modified = "%m%h%r" -- modified [+], help [Help], readonly [RO]
  local align_right = "%="
  local file_type = "%y"
  local file_encoding = "%{strlen(&fenc)?&fenc:'none'}"
  local line = "%l / %L"
  local col = "c%c"
  local percentage = "%p%%"
  return string.format(
    "  (%s)  %s  %s  %s%s  %s  %s  %s  %s  ",
    branch,
    file_name,
    modified,
    align_right,
    file_type,
    file_encoding,
    line,
    col,
    percentage
  )
end

vim.opt.number = true
vim.opt.termguicolors = true
vim.opt.showmode = false          -- no INSERT, VISUAL, ..
vim.opt.fillchars = { eob = " " } -- no ~ in line numbers
vim.opt.statusline = statusline()
vim.opt.mouse = "a"               -- enable mouse always
vim.opt.clipboard:append("unnamedplus")
vim.opt.breakindent = true
vim.opt.smartindent = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.incsearch = true
vim.opt.signcolumn = "no" -- just number line, no extra signs (noise)
vim.opt.updatetime = 250
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.inccommand = "split" -- prev live substitutions
-- vim.opt.cursorline = false -- highlight line cursor is on
vim.opt.scrolloff = 6        -- no scroll past num lines
vim.opt.hlsearch = true      -- ESC to clear

-- [[ keymaps ]]
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>") -- clear search highlight
vim.keymap.set("n", "<leader>,", "<cmd>edit ~/.config/nvim/init.lua<cr>", { desc = "edit nvim" })
-- better move around wrapped lines
vim.keymap.set({ "n", "v" }, "<Up>", [[v:count == 0 ? 'gk' : 'k']], { expr = true, silent = true })
vim.keymap.set({ "n", "v" }, "<Down>", [[v:count == 0 ? 'gj' : 'j']], { expr = true, silent = true })
-- save in any mode
vim.keymap.set({ "n", "i", "v", "x" }, "<C-s>", "<Esc><cmd>w<cr>")
vim.keymap.set("n", "<leader>q", "<cmd>quitall!<cr>", { desc = "quit" })
vim.keymap.set("n", "<leader>x", "<C-w>q", { desc = "win close" })
-- diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "prev diag" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "next diag" })
vim.keymap.set('n', '<leader>d', function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = "diag toggle", silent = false })
-- window movements
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "left win" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "right win" })
vim.keymap.set("n", "<C-k>", "<C-w><C-j>", { desc = "lower win" })
vim.keymap.set("n", "<C-j>", "<C-w><C-k>", { desc = "upper win" })
-- move lines up or down, Alt-Up/Down
vim.keymap.set("n", "<A-Down>", "<cmd>m .+1<cr>==")
vim.keymap.set("n", "<A-Up>", "<cmd>m .-2<cr>==")
vim.keymap.set("i", "<A-Down>", "<Esc><cmd>m .+1<cr>==gi")
vim.keymap.set("i", "<A-Up>", "<Esc><cmd>m .-2<cr>==gi")
vim.keymap.set("v", "<A-Down>", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "<A-Up>", ":m '<-2<CR>gv=gv")
-- indent/dedent with Tab in visual mode
vim.keymap.set("v", "<Tab>", ">gv")
vim.keymap.set("v", "<S-Tab>", "<gv")
-- keep c-i separate from tab keys
vim.keymap.set("n", "<c-i>", "<c-i>")
-- center cursor when jump scrolling
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
-- other shortcuts and pet peves
vim.keymap.set("v", "y", "ygv<esc>")        -- keep cursor when yanking
vim.keymap.set("n", "<cr>", "i<cr><esc>l")  -- enter new line in n mode
vim.keymap.set("n", "<leader>p", 'diw"0P', { desc = "stamp" })
vim.keymap.set("n", "J", "mzJ`z")           -- keep cursor when joining lines
vim.keymap.set({ "x", "v" }, "p", [["_dP]]) -- put word without yanking replaced
vim.keymap.set("n", "Y", "Yg$")             -- go to end when yank whole line
vim.keymap.set("n", "<leader>y", "<cmd>let @+=expand('%')<cr>", { desc = "copy path" })
vim.keymap.set("n", "<leader>Y", "<cmd>let @+=expand('%:p')<cr>", { desc = "full path" })
-- replace word under cursor interactively
vim.keymap.set(
  "n",
  "<leader>r",
  [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  { desc = "word rename" }
)
-- select all using typecal ctrl-a keymap keys press
vim.keymap.set("n", "<leader>a", "ggVG", { desc = "sel all" })

-- [[ auto commands ]] - event functions - autocommands
-- functions that run on some event
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function() vim.highlight.on_yank() end,
})

vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "InsertLeave", "CmdlineLeave", "WinEnter" }, {
  pattern = "*",
  callback = function()
    if vim.o.nu and vim.api.nvim_get_mode().mode ~= "i" then
      vim.opt.relativenumber = true
    end
  end,
})

vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "InsertEnter", "CmdlineEnter", "WinLeave" }, {
  pattern = "*",
  callback = function()
    if vim.o.nu then
      vim.opt.relativenumber = false
      vim.cmd("redraw")
    end
  end,
})

-- [[ plugin manager ]]
-- installing mini.deps and setup
local path_package = vim.fn.stdpath('data') .. '/site/'
local mini_path = path_package .. 'pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
  vim.cmd('echo "Installing `mini.nvim`" | redraw')
  local clone_cmd = {
    'git', 'clone', '--filter=blob:none',
    'https://github.com/echasnovski/mini.nvim', mini_path
  }
  vim.fn.system(clone_cmd)
  vim.cmd('packadd mini.nvim | helptags ALL')
  vim.cmd('echo "Installed `mini.nvim`" | redraw')
end
local deps = require('mini.deps')
deps.setup({ path = { package = path_package } })
local add, now, later = deps.add, deps.now, deps.later

-- [[ now plugins ]]
now(function()
  add({
    source = "rose-pine/neovim",
    name = "rose-pine",
  })
  require("rose-pine").setup({
    styles = { italic = false },
  })
  vim.cmd("colorscheme rose-pine")
end)

now(function() require("mini.icons").setup() end)
now(function() require("mini.ai").setup() end)
now(function() require("mini.diff").setup() end)
now(function() require("mini.extra").setup() end)

now(function()
  local indent = require('mini.indentscope')
  indent.setup({
    draw = {
      delay = 0,
      animation = indent.gen_animation.none()
    },
    symbol = "|"
  })
end)

now(function()
  require('mini.completion').setup({
    delay = { completion = 500, info = 500, signature = 800 },
    lsp_completion = { source_func = 'completefunc' }
  })
  vim.keymap.set('i', "<C-e>", [[pumvisible() ? "\<C-p>" : "\<C-e>"]], { expr = true })
  vim.keymap.set('i', "<C-p>", [[pumvisible() ? "\<C-e>" : "\<C-p>"]], { expr = true })
end)

now(function()
  local starter = require('mini.starter')
  starter.setup({
    silent = true,
    header = "[Space Space] find files\n[Space e] open explorer\n[Space /] grep",
    items = { name = '', action = '', section = '' },
    content_hooks = {
      starter.gen_hook.padding(10, 20),
    },
    footer = ""
  })
end)

now(function()
  local files = require("mini.files")
  files.setup({
    windows = {
      preview = true,
      width_focus = 25,   -- Width of focused window
      width_nofocus = 15, -- Width of non-focused window
      width_preview = 50, -- Width of preview window
    },
    mappings = {
      go_in_plus  = "<Right>",
      go_in       = "<S-Right>",
      go_out      = "<Left>",
      go_out_plus = "<S-Left>",
      close       = "<ESC>",
    },
  })
  function Minifile_toggle()
    if not files.close() then
      files.open()
    end
  end

  vim.keymap.set("n", "<leader>e", ":lua Minifile_toggle()<cr>", { silent = true, desc = "explore" })
  -- <leader>E is :Ex 
end)

now(function()
  local pick = require("mini.pick")
  pick.setup({
    mappings = {
      choose_in_vsplit  = '<C-s>',
      scroll_down       = '<C-d>',
      scroll_up         = '<C-u>',
      move_up           = '<C-e>',
      scroll_left       = '<C-k>',
      scroll_right      = '<C-h>',
    },
    options = { content_from_bottom = true },
    window = {
      config = function()
        local h = math.floor(0.6 * vim.o.lines)
        local w = math.floor(0.6 * vim.o.columns)
        local row = math.floor(0.3 * h)
        local col = math.floor(0.3 * w)
        return {
          anchor = 'NW',
          border = 'single',
          height = h,
          width = w,
          row = row,
          col = col
        }
      end,
      prompt_cursor = '_',
    },
  })
  vim.keymap.set("n", "<leader><leader>", "<cmd>Pick files<cr>", { desc = "files" })
  vim.keymap.set("n", "<leader>/", "<cmd>Pick grep_live<cr>", { desc = "live grep" })
  vim.keymap.set("n", "<leader>'", "<cmd>Pick grep pattern='<cword>'<cr>", { desc = "grep word" })
  vim.keymap.set("n", "<leader>?", "<cmd>Pick help<cr>", { desc = "help" })
  -- from mini extra
  vim.keymap.set("n", "gr", "<cmd>Pick lsp scope='references'<cr>", { desc = "refs" })
  vim.keymap.set("n", "<leader>lt", "<cmd>Pick lsp scope='type_definition'<cr>", { desc = "type def" })
  vim.keymap.set("n", [[<leader>"]], "<cmd>Pick registers<cr>", { desc = "registers" })
end)

now(function()
  add({ source = "shortcuts/no-neck-pain.nvim" })
  require("no-neck-pain").setup({
    minSideBufferWidth = math.floor(0.2 * vim.o.columns),
    disableOnLastBuffer = false,
    autocmds = { enableOnVimEnter = true, },
    buffers = {
      scratchPad = {
        enabled = true,
        location = '~/.notes/scratchpad'
      },
      bo = { filetype = 'md' },
      right = { enabled = false },
    },
  })
  vim.keymap.set("n", "<leader>n", "<cmd>NoNeckPain<CR>", { silent = true, desc = "neck pain" })
end)

now(function()
  add({
    source = "ThePrimeagen/harpoon",
    name = "harpoon",
    checkout = "harpoon2",
    monitor = "harpoon2",
    depends = { "nvim-lua/plenary.nvim" },
  })
  local harpoon = require("harpoon")
  harpoon.setup({
    settings = {
      save_on_toggle = true,
      sync_on_ui_close = true,
    }
  })

  vim.keymap.set("n", "<leader>ha", function() harpoon:list():add() end, { desc = "add" })
  vim.keymap.set("n", "<leader>he", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
    { desc = "edit" })
  vim.keymap.set("n", "<C-n>", function() harpoon:list():select(1) end)
  vim.keymap.set("n", "<C-e>", function() harpoon:list():select(2) end)
  vim.keymap.set("n", "<C-y>", function() harpoon:list():select(3) end)
  vim.keymap.set("n", "<c-t>", function() harpoon:list():select(4) end)
end)

-- [[ later plugins ]]
later(function()
  add({ -- syntax highlight
    source = 'nvim-treesitter/nvim-treesitter',
    -- Perform action after every checkout
    hooks = { post_checkout = function() vim.cmd('TSUpdate') end },
  })
  ---@diagnostic disable-next-line: missing-fields
  require('nvim-treesitter.configs').setup({
    ensure_installed = {},
    auto_install = true,
    highlight = { enable = true },
    indent = { enable = true, },
  })
end)

-- function, conditional context top of screen
later(function()
  add({ source = "nvim-treesitter/nvim-treesitter-context" })
  require 'treesitter-context'.setup {
    max_lines = 8,           -- How many lines the window should span. Values <= 0 mean no limit.
    multiline_threshold = 8, -- Maximum number of lines to show for a single context
  }
  vim.keymap.set("n", "<leader>c", "<cmd>TSContextToggle<CR>", { desc = "context" })
  vim.keymap.set("n", "[c", function()
    require("treesitter-context").go_to_context(vim.v.count1)
  end, { desc = "context", silent = true })
end)

-- undo and redo visually
later(function()
  add({ source = "mbbill/undotree" })
  vim.g.undotree_SetFocusWhenToggle = 1
  vim.keymap.set("n", "<leader>u", "<cmd>UndotreeToggle<cr>", { desc = "undotree" })
end)

-- git wrapper for git stuff
later(function()
  add({ source = "tpope/vim-fugitive" })
  vim.keymap.set("n", "<leader>gg", "<cmd>G<Cr>", { desc = "status" })
  vim.keymap.set("n", "<leader>gd", "<cmd>Gvdiffsplit<Cr>", { desc = "diff" })
  vim.keymap.set("n", "<leader>gb", "<cmd>G blame<Cr>", { desc = "blame" })
end)

-- surround cs{motion} to change, ds{motion} to delete, ys{motion} add
later(function() add({ source = "tpope/vim-surround" }) end)

-- vim exchange, cx{motion} to select, (.) or cx{motion} to swap, cxc to clear
later(function() add({ source = "tommcdo/vim-exchange" }) end)

-- tmux nvim navigate R between panes
later(function()
  add({ source = "alexghergh/nvim-tmux-navigation" })
  local ntn = require('nvim-tmux-navigation')
  ntn.setup {}
  vim.keymap.set('n', "<C-l>", ntn.NvimTmuxNavigateRight)
end)

-- autoformat, make doc look like standard code, removing white spaces and extra stuff
later(function()
  add({ source = "stevearc/conform.nvim" })
  local conform = require("conform")
  conform.setup({
    default_format_opts = { lsp_format = "fallback" },
    format_on_save = nil,
  })
  vim.keymap.set("n", "<leader>lf", function()
    conform.format({ async = true })
  end, { desc = "format" })
end)

-- LSP Configuration & Plugins
later(function()
  add({
    source = "neovim/nvim-lspconfig",
    name = "lspconfig",
    depends = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      "folke/neodev.nvim",
    },
  })
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(event)
      local map = function(keys, func, desc)
        vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "" .. desc })
      end

      map("K", vim.lsp.buf.hover, "hover documentation")
      map("gd", vim.lsp.buf.definition, "definition")
      --  Useful when your language has ways of declaring types without an actual implementation.
      map("<leader>li", vim.lsp.buf.implementation, "implementation")
      --  Most Language Servers support renaming across files, etc.
      map("<leader>lr", vim.lsp.buf.rename, "rename vars")
      -- Execute a code action, usually your cursor needs to be on top of an error
      -- or a suggestion from your LSP for this to activate.
      map("<leader>la", vim.lsp.buf.code_action, "code action")
    end,
  })

  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = vim.tbl_extend("force", capabilities, require("mini.completion").completefunc_lsp())

  local servers = {
    lua_ls = {
      settings = {
        Lua = {
          diagnostics = { globals = { 'vim' } },
          completion = { callSnippet = "Replace" },
        },
      },
    },
    ruff = {
      init_options = {
        settings = { -- Ruff language server settings go here
          ignore = { "E501", "E402" },
        },
      },
    },
  }

  require("mason").setup() -- :Mason
  local ensure_installed = vim.tbl_keys(servers or {})
  vim.list_extend(ensure_installed, {
    "stylua", -- Used to format Lua code
  })
  require("mason-tool-installer").setup({ ensure_installed = ensure_installed })
  require("mason-lspconfig").setup({
    handlers = {
      function(server_name)
        local server = servers[server_name] or {}
        server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
        require("lspconfig")[server_name].setup(server)
      end,
    },
  })
end)

-- vim: ts=2 sts=2 sw=2 et
