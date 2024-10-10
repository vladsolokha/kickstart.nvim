vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- cursor options
vim.cmd('hi iCursor gui=NONE guibg=Red guifg=NONE')
vim.cmd('hi defCursor gui=NONE guibg=White guifg=Black')
vim.cmd('hi visCursor gui=NONE guibg=Green guifg=Yellow')
vim.opt.guicursor = "a:blinkon0-defCursor,i-r:iCursor,v-ve:visCursor"

local function git_branch() -- show git branch in status
    local branch = vim.fn.system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
    if string.len(branch) > 0 then return branch else return "no git" end
end
local function statusline()
    local branch = git_branch()
    local astring = "%F  %m%h%r %y %=%l/%L  c%c  %p%%"
    return string.format("  (%s)  %s  ", branch, astring)
end
vim.opt.statusline = statusline()
vim.opt.laststatus = 3            -- always show global status
vim.opt.showmode = false          -- no INSERT, VISUAL, ..
vim.opt.fillchars = { eob = " " } -- no ~ in line numbers
vim.opt.mouse = "a"               -- enable mouse always
vim.opt.clipboard:append("unnamedplus")
vim.opt.breakindent = true
vim.opt.smartindent = true
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.incsearch = true
vim.opt.updatetime = 250
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.inccommand = "split" -- prev live substitutions
vim.opt.cursorline = false   -- highlight line cursor is on
vim.opt.scrolloff = 6        -- no scroll past num lines
vim.opt.hlsearch = true      -- ESC to clear search

-- [[ keymaps ]]
vim.keymap.set( -- replace word under cursor interactively
    "n", "<leader>r", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
    { desc = "word rename" }
)
-- better move around wrapped lines
vim.keymap.set({ "n", "v" }, "<Up>", [[v:count == 0 ? 'gk' : 'k']], { expr = true, silent = true })
vim.keymap.set({ "n", "v" }, "<Down>", [[v:count == 0 ? 'gj' : 'j']], { expr = true, silent = true })
vim.keymap.set({ "n", "i", "v", "x" }, "<C-s>", "<Esc><cmd>w<cr>", { desc = "save" })
vim.keymap.set("n", "<leader>q", "<cmd>quitall!<cr>", { desc = "quit" })
vim.keymap.set("n", "<leader>x", "<C-w>q", { desc = "win close" })
-- diagnostic keymaps
vim.keymap.set("n", "[<Up>", vim.diagnostic.goto_prev, { desc = "prev diag" })
vim.keymap.set("n", "]<Up>", vim.diagnostic.goto_next, { desc = "next diag" })
vim.keymap.set('n', '<leader>d', function()
    vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = "diag toggle", silent = false })
-- window movements
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "left win" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "right win" })
vim.keymap.set("n", "<C-w>n", "<C-w><C-j>", { desc = "bot win" })
vim.keymap.set("n", "<C-w>e", "<C-w><C-k>", { desc = "top win" })
-- window resizing
vim.keymap.set("n", "<A-t>", "<cmd>horizontal resize +8<cr>", { desc = "win taller" })
vim.keymap.set("n", "<A-s>", "<cmd>horizontal resize -8<cr>", { desc = "win shorter" })
vim.keymap.set("n", "<A-.>", "<cmd>vert resize +8<cr>", { desc = "win wider" })
vim.keymap.set("n", "<A-,>", "<cmd>vert resize -8<cr>", { desc = "win narrower" })
-- move lines up or down, Alt-Up/Down
vim.keymap.set("n", "<A-n>", "<cmd>m .+1<cr>==", { desc = "move code down" })
vim.keymap.set("n", "<A-e>", "<cmd>m .-2<cr>==", { desc = "move code up" })
vim.keymap.set("i", "<A-n>", "<Esc><cmd>m .+1<cr>==gi", { desc = "move code down" })
vim.keymap.set("i", "<A-e>", "<Esc><cmd>m .-2<cr>==gi", { desc = "move code up" })
vim.keymap.set("v", "<A-n>", ":m '>+1<CR>gv=gv", { desc = "move code down" })
vim.keymap.set("v", "<A-e>", ":m '<-2<CR>gv=gv", { desc = "move code up" })
-- better indent/dedent
vim.keymap.set({ "x", "v" }, ">", ">gv", { desc = "indent and hi" })
vim.keymap.set({ "x", "v" }, "<", "<gv", { desc = "dedent and hi" })
-- go into Explore files mode netrw
vim.keymap.set("n", "-", "<cmd>Ex %:p:h<Cr>", { desc = "ex this file dir" })
vim.keymap.set("n", "<leader>a", "ggVG", { desc = "sel all" })
-- better c qfix list keys
vim.keymap.set("n", "]<Down>", "<cmd>cn<cr>", { desc = "c next qfix" })
vim.keymap.set("n", "[<Down>", "<cmd>cp<cr>", { desc = "c prev qfix" })
-- other shortcuts and pet peves
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "rm search hi" })
vim.keymap.set("n", "<c-i>", "<c-i>", { desc = "keep ctrl i" })
vim.keymap.set("n", "<C-n>", "<C-d>", { desc = "ctrl-n is also scroll half down" })
vim.keymap.set("v", "y", "ygv<esc>", { desc = "yank and hi" })
vim.keymap.set("n", "Y", "Yg$", { desc = "Y yanks to eol" })
vim.keymap.set({ "x", "v" }, "p", [["_dP]], { desc = "visual mode no yank after put" })
vim.keymap.set("n", "J", "mzJ`z", { desc = "join but no move cursor" })
vim.keymap.set("n", "<leader>p", 'diw"0P', { desc = "stamp" })
vim.keymap.set("n", "<leader>y", "<cmd>let @+=expand('%')<cr>", { desc = "copy file path" })
vim.keymap.set("n", "<leader>Y", "<cmd>let @+=expand('%:p')<cr>", { desc = "copy full file path" })
vim.keymap.set("n", "<leader>,", "<cmd>edit ~/.config/nvim/init.lua<cr>", { desc = "edit nvim" })

-- [[ auto commands ]] - event functions - autocommands
-- functions that run on some event
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function() vim.highlight.on_yank() end,
})

-- netrw options and mappings
vim.g.netrw_keepdir = 0
vim.g.netrw_banner = 0 -- use I inside to show banner
vim.g.netrw_sort_by = "time"
vim.g.netrw_sort_direction = "reverse"
vim.g.netrw_liststyle = 1
vim.api.nvim_create_autocmd('filetype', {
    pattern = 'netrw',
    desc = 'Better mappings for netrw',
    callback = function()
        local bind = function(lhs, rhs)
            vim.keymap.set('n', lhs, rhs, { remap = true, buffer = true })
        end
        bind('P', '<C-w>z')     -- no preview
        bind('.', 'gh')         -- show hide dotfiles
        bind('<Left>', '-')     -- move up directory
        bind('<Right>', '<CR>') -- open file | dir
    end
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
now(function() -- colorscheme
    add({
        source = "rose-pine/neovim",
        name = "rose-pine",
    })
    require("rose-pine").setup({
        styles = { italic = false },
    })
    vim.cmd("colorscheme rose-pine")
end)

now(function() -- mini version of Telescope.nvim
    local pick = require("mini.pick")
    pick.setup({
        mappings = {
            scroll_down       = '<C-d>',
            scroll_up         = '<C-u>',
            move_up           = '<C-e>',
            scroll_left       = '<C-k>',
            scroll_right      = '<C-h>',
            choose_marked     = '<C-x>', -- choose into qfix list
            mark              = '<C-t>', -- tag file
            mark_all          = '<C-a>',
            -- filter matched into new query
            -- i.e. foo <C-f> bar matches all foo, then all bar in no particular order
            refine            = '<C-f>',
            refine_marked     = '<C-p>', -- filter marked items in new query
            delete_left       = '',
            choose_in_split   = '',
            choose_in_tabpage = '',
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
        },
    })
    vim.keymap.set("n", "<leader>f", "<cmd>Pick files<cr>", { desc = "files" })
    vim.keymap.set("n", "<leader>o", "<cmd>Pick resume<cr>", { desc = "resume" })
    vim.keymap.set("n", "<leader>/", "<cmd>Pick grep_live<cr>", { desc = "grep live" })
    vim.keymap.set("n", "<leader>'", "<cmd>Pick grep pattern='<cword>'<cr>", { desc = "grep word" })
    vim.keymap.set("n", "<leader>?", "<cmd>Pick help<cr>", { desc = "help" })
    vim.keymap.set("n", [[<leader>"]], "<cmd>Pick registers<cr>", { desc = "registers" })
end)

now(function() -- extra buff on left for padding code to middle of screen
    add({ source = "shortcuts/no-neck-pain.nvim" })
    require("no-neck-pain").setup({
        minSideBufferWidth = math.floor(0.2 * vim.o.columns),
        disableOnLastBuffer = false,
        autocmds = { enableOnVimEnter = true, },
        buffers = {
            scratchPad = {
                enabled = true,
                fileName = "quicknote",
                location = '~/.notes',
            },
            bo = { filetype = 'txt' },
            right = { enabled = false },
        },
    })
    vim.keymap.set("n", "<leader>k", "<cmd>NoNeckPain<CR>", { silent = true, desc = "neck pain" })
end)

now(function() -- jump to buffers fast
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
    vim.keymap.set("n", "<leader>n", function() harpoon:list():select(1) end, { desc = "harpoon 1" })
    vim.keymap.set("n", "<leader>e", function() harpoon:list():select(2) end, { desc = "harpoon 2" })
    vim.keymap.set("n", "<leader>i", function() harpoon:list():select(3) end, { desc = "harpoon 3" })
end)

-- [[ later plugins ]]
later(function() require("mini.ai").setup() end) -- extra text objects for around/in
-- jump to hunks and see code changes on numbers
later(function()
    require('mini.diff').setup({
        view = {
            style = 'sign',
            signs = { add = '+', change = '~', delete = '-' },
        }
    })
end)
later(function() require('mini.extra').setup() end) -- extra Pickers for Pick; explore, registers, buf_lines

later(function()                                    -- git client, great features, blame, diff, log
    add({ source = 'tpope/vim-fugitive' })
    vim.keymap.set('n', '<Leader>gg', '<cmd>vert G<cr>', { desc = 'fugitive' })
    vim.keymap.set('n', '<Leader>gb', '<cmd>Git blame<cr>', { desc = 'blame' })
    vim.keymap.set('n', '<Leader>gv', '<cmd>Gvdiffsplit<cr>', { desc = 'v diff' })
    vim.keymap.set('n', '<Leader>gl', '<cmd>vert G log<cr>', { desc = 'log' })
    vim.keymap.set('n', '<Leader>gs', '<cmd>Gclog<cr>', { desc = 'c log' })
end)

later(function() -- visualize undo in tree
    add({ source = "mbbill/undotree" })
    vim.g.undotree_SetFocusWhenToggle = 1
    vim.keymap.set("n", "<leader>u", "<cmd>UndotreeToggle<cr>", { desc = "undotree" })
end)

later(function() -- syntax highlight
    add({
        source = 'nvim-treesitter/nvim-treesitter',
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

later(function() -- function, conditional context top of screen
    add({ source = "nvim-treesitter/nvim-treesitter-context" })
    require 'treesitter-context'.setup {
        max_lines = 8, multiline_threshold = 8,
    }
    vim.keymap.set("n", "<leader>C", "<cmd>TSContextToggle<CR>", { desc = "tog context" })
    vim.keymap.set("n", "<leader>c", function()
        require("treesitter-context").go_to_context(vim.v.count1)
    end, { desc = "go to context", silent = true })
end)

later(function() -- LSP Configuration & Plugins
    add({
        source = "neovim/nvim-lspconfig",
        name = "lspconfig",
        depends = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "WhoIsSethDaniel/mason-tool-installer.nvim",
            "hrsh7th/cmp-nvim-lsp",
        },
    })
    vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(event)
            local map = function(keys, func, desc)
                vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "" .. desc })
            end

            map("K", vim.lsp.buf.hover, "hover documentation")
            map("gd", vim.lsp.buf.definition, "definition")
            map("gr", vim.lsp.buf.references, "refs")
            map("<leader>lf", vim.lsp.buf.format, "format")
            map("<leader>li", vim.lsp.buf.implementation, "implementation")
            map("<leader>lr", vim.lsp.buf.rename, "rename vars")
            map("<leader>lt", vim.lsp.buf.type_definition, "type def")
            map("<leader>la", vim.lsp.buf.code_action, "code action")
        end,
    })

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())
    capabilities.textDocument.completion.completionItem.snippetSupport = false

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

    require("mason").setup()
    local ensure_installed = vim.tbl_keys(servers or {})
    vim.list_extend(ensure_installed, { "stylua", })
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

later(function() -- autocomplete in code, cmd, and search
    add({
        source = "hrsh7th/nvim-cmp",
        depends = {
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "hrsh7th/cmp-buffer",
        }
    })
    local cmp = require("cmp")
    cmp.setup({
        completion = { completeopt = "menu,menuone,noinsert" },
        performance = { debounce = 500, throttle = 300 },
        mapping = cmp.mapping.preset.insert({
            ["<C-n>"] = cmp.mapping.select_next_item(),
            ["<C-e>"] = cmp.mapping.select_prev_item(),
            ["<C-d>"] = cmp.mapping.scroll_docs(-4),
            ["<C-u>"] = cmp.mapping.scroll_docs(4),
            ["<C-y>"] = cmp.mapping.confirm({ select = true }),
            ["<C-t>"] = cmp.mapping.complete({}),
        }),
        sources = cmp.config.sources({
            { name = "nvim_lsp" },
        }, {
            { name = "buffer" },
            { name = "path" },
        })
    })
    -- disable completion in comments
    cmp.setup({
        enabled = function()
            local context = require 'cmp.config.context'
            if vim.api.nvim_get_mode().mode == 'c' then
                return true
            else
                return not context.in_treesitter_capture("comment")
                    and not context.in_syntax_group("Comment")
            end
        end
    })
    local cmdlineMap = {
        ['<C-n>'] = {
            c = function(_)
                if cmp.visible() then
                    cmp.select_next_item()
                end
            end,
        },
        ["<C-e>"] = {
            c = function(_)
                if cmp.visible() then
                    cmp.select_prev_item()
                end
            end,
        },
        ["<C-y>"] = {
            c = function(_)
                if cmp.visible() then
                    cmp.confirm({ select = true })
                end
            end,
        },
    }
    cmp.setup.cmdline({ '/', '?' }, {
        mapping = cmdlineMap,
        sources = {
            { name = 'buffer' }
        },
    })
    cmp.setup.cmdline(':', {
        mapping = cmdlineMap,
        sources = cmp.config.sources({
            { name = 'path' }
        }, {
            { name = 'cmdline' }
        }),
    })
end)
