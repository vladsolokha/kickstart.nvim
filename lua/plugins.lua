-- [[ plugins ]]
--      rose-pine
--      treesitter
--      context
--      undotree (undo like git)
--      fugitive (git wrapper)
--      surround
--      exchange
--      neck-pain
--      tmux-navigation
--      harpoon
--      conform (auto format code)
--      mini:
--      (icons, ai, hipatterns, base16, indentscope, completion, starter, diff, files, clue, pick)
--      lspconfig: mason, tool-installer, fidget, neodev
return {
    {
        "rose-pine/neovim",
        name = "rose-pine",
        config = function()
            require("rose-pine").setup({
                styles = { italic = false },
            })
            vim.cmd("colorscheme rose-pine")
        end
    },

    { -- Highlight, edit, and navigate code
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        opts = {
            ensure_installed = {},
            auto_install = true,
            highlight = { enable = true, },
            indent = { enable = true, },
        },
        config = function(_, opts)
            ---@diagnostic disable-next-line: missing-fields
            require("nvim-treesitter.configs").setup(opts)
        end,
    },

    { -- function, conditional context top of screen
        "nvim-treesitter/nvim-treesitter-context",
        config = function()
            require 'treesitter-context'.setup {
                max_lines = 8,           -- How many lines the window should span. Values <= 0 mean no limit.
                multiline_threshold = 8, -- Maximum number of lines to show for a single context
            }
            vim.keymap.set("n", "[c", function()
                require("treesitter-context").go_to_context(vim.v.count1)
            end, { desc = "context", silent = true })
            vim.keymap.set("n", "<leader>c", "<cmd>TSContextToggle<CR>", { desc = "context" })
        end
    },

    { -- undo and redo visually
        "mbbill/undotree",
        config = function()
            vim.keymap.set("n", "<leader>u", "<cmd>UndotreeToggle<cr><cmd>UndotreeFocus<cr>", { desc = "undotree" })
        end,
    },

    { -- git wrapper for git stuff
        "tpope/vim-fugitive",
        config = function()
            vim.keymap.set("n", "<leader>gg", "<cmd>G<Cr>", { desc = "status" })
            vim.keymap.set("n", "<leader>gd", "<cmd>Gvdiffsplit<Cr>", { desc = "diff" })
            vim.keymap.set("n", "<leader>gb", "<cmd>G blame<Cr>", { desc = "blame" })
        end,
    },

    { -- surround cs{motion} to change, ds{motion} to delete, ys{motion} add
        "tpope/vim-surround"
    },

    { -- vim exchange, cx{motion} to select, (.) or cx{motion} to swap, cxc to clear
        "tommcdo/vim-exchange",
    },

    {
        "shortcuts/no-neck-pain.nvim",
        version = "*",
        config = function()
            require("no-neck-pain").setup({
                disableOnLastBuffer = false,
                autocmds = {
                    enableOnVimEnter = true,
                },
                buffers = {
                    scratchPad = {
                        enabled = true,
                        location = '~/.notes/scratchpad'
                    },
                    bo = { filetype = 'md' },
                    right = { enabled = false },
                },
            })
        end,
        vim.keymap.set("n", "<leader>n", "<cmd>NoNeckPain<CR>", { silent = true, desc = "neck pain" })
    },

    { -- tmux nvim navigate R between panes
        "alexghergh/nvim-tmux-navigation",
        config = function()
            local ntn = require('nvim-tmux-navigation')
            ntn.setup {}
            vim.keymap.set('n', "<C-l>", ntn.NvimTmuxNavigateRight)
        end,
    },

    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local harpoon = require("harpoon")
            harpoon:setup({
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
        end,
    },

    { -- autoformat, make doc look like standard code, removing white spaces and extra stuff
        "stevearc/conform.nvim",
        event = { "BufWritePre" },
        cmd = { "ConformInfo" },
        keys = {
            {
                "<leader>lf",
                function()
                    require("conform").format({ async = true, lsp_fallback = true })
                end,
                mode = "",
                desc = "format",
            },
        },
        opts = {
            notify_on_error = false,
            format_on_save = nil,
        },
    },

    { --  Check out: https://github.com/echasnovski/mini.nvim
        "echasnovski/mini.nvim",
        config = function()
            require("mini.icons").setup()
            require("mini.ai").setup()

            local hipat = require("mini.hipatterns")
            hipat.setup({
                highlighters = {
                    hex_color = hipat.gen_highlighter.hex_color(),
                }
            })

            local indent = require('mini.indentscope')
            indent.setup({
                draw = {
                    delay = 0,
                    animation = indent.gen_animation.none()
                },
                symbol = "|"
            })

            require('mini.completion').setup({
                delay = { completion = 500, info = 500, signature = 800 },
                lsp_completion = { source_func = 'completefunc' }
            })
            vim.keymap.set('i', "<C-e>", [[pumvisible() ? "\<C-p>" : "\<C-e>"]], { expr = true })
            vim.keymap.set('i', "<C-p>", [[pumvisible() ? "\<C-e>" : "\<C-p>"]], { expr = true })

            require("mini.diff").setup()

            local starter = require('mini.starter')
            starter.setup({
                silent = true,
                header = "[Space f] find files\n[Space e] open explorer",
                items = { name = '', action = '', section = '' },
                content_hooks = {
                    starter.gen_hook.padding(10, 20),
                },
                footer = ""
            })

            require("mini.files").setup({
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
                if not MiniFiles.close() then
                    MiniFiles.open()
                end
            end

            vim.keymap.set("n", "<leader>e", ":lua Minifile_toggle()<cr>", { silent = true, desc = "explore" })
            -- <leader>E is :Ex now

            local miniclue = require("mini.clue")
            miniclue.setup({
                triggers = {
                    -- Leader triggers
                    { mode = 'n', keys = '<Leader>' },
                    { mode = 'x', keys = '<Leader>' },
                    { mode = 'n', keys = '<C-w>' },
                    { mode = 'n', keys = ']' },
                    { mode = 'n', keys = '[' },
                },
                clues = {
                    { mode = 'n', keys = '<Leader>h', desc = '+Harpoon' },
                    { mode = 'n', keys = '<Leader>l', desc = '+LSP' },
                    { mode = 'n', keys = '<Leader>q', desc = '+Quit' },
                    { mode = 'n', keys = '<Leader>g', desc = '+Git' },
                    { mode = 'n', keys = ']d',        postkeys = ']' },
                    { mode = 'n', keys = '[d',        postkeys = '[' },
                    miniclue.gen_clues.windows({
                        submode_move = true,
                        submode_navigate = true,
                        submode_resize = true,
                    }),
                },
                window = {
                    delay = 300,
                    config = {
                        width = 'auto',
                        border = 'single',
                    },
                },
            })

            local pick = require("mini.pick")
            pick.setup({
                mappings = {
                    paste             = '<C-v>',
                    choose_in_vsplit  = '<C-CR>',
                    scroll_down       = '<C-d>',
                    scroll_up         = '<C-u>',
                    refine            = '',
                    choose_in_split   = '',
                    choose_in_tabpage = '',
                    choose_marked     = '',
                    delete_left       = '',
                    mark              = '',
                    mark_all          = '',
                    refine_marked     = '',
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
            vim.keymap.set("n", "<leader><leader>", "<cmd>Pick resume<cr>", { desc = "resume" })
            vim.keymap.set("n", "<leader>f", "<cmd>Pick files<cr>", { desc = "files" })
            vim.keymap.set("n", "<leader>o", "<cmd>Pick oldfiles<cr>", { desc = "recent" })
            vim.keymap.set("n", "<leader>/", "<cmd>Pick grep_live<cr>", { desc = "live grep" })
            vim.keymap.set("n", "<leader>'", "<cmd>Pick grep pattern='<cword>'<cr>", { desc = "grep word" })
            vim.keymap.set("n", "<leader>gf", "<cmd>Pick files tool='git'<cr>", { desc = "git files" })
            vim.keymap.set("n", "<leader>?", "<cmd>Pick help<cr>", { desc = "help" })

            require("mini.extra").setup()
            vim.keymap.set("n", "gr", "<cmd>Pick lsp scope='references'<cr>", { desc = "refs" })
            vim.keymap.set("n", "<leader>ls", "<cmd>Pick lsp scope='document_symbol'<cr>", { desc = "doc symbol" })
            vim.keymap.set("n", "<leader>lp", "<cmd>Pick lsp scope='workspace_symbol'<cr>", { desc = "proj symbol" })
            vim.keymap.set("n", "<leader>lt", "<cmd>Pick lsp scope='type_definition'<cr>", { desc = "type def" })
            vim.keymap.set("n", [[<leader>"]], "<cmd>Pick registers<cr>", { desc = "registers" })
        end,
    },

    { -- LSP Configuration & Plugins
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "WhoIsSethDaniel/mason-tool-installer.nvim",
            { "folke/neodev.nvim", opts = {} },
        },
        config = function()
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
                            completion = {
                                callSnippet = "Replace",
                            },
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
        end,
    },
}
