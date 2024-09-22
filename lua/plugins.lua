-- [[ plugins ]]
--      colorscheme
--      treesitter
--      context
--      text-objects
--      hlchunk (pretty indents lines)
--      undotree (undo like git)
--      fugitive (git wrapper)
--      neck-pain
--      tmux-navigation
--      harpoon
--      conform (auto format code)
--      mini: ( starter, diff, files, clue)
--      telescope
--      lspconfig: mason, tool-installer, fidget, neodev
--      cmp: LuaSnip, snippets, luasnip, path, cmdline, buffer
return {

    { -- colorscheme
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            require("tokyonight").setup({
                style = "night", --  `storm`, `night`, `day`, `moon`
                styles = {
                    comments = { italic = false },
                    keywords = { italic = false },
                },
                plugins = {
                    telescope = true,
                },
            })
            vim.cmd([[colorscheme tokyonight-night]])
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

    { -- text-objects, select i/o func, loop, swap stuff too
        "nvim-treesitter/nvim-treesitter-textobjects",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        opts = {
            textobjects = {
                move = {
                    enable = true,
                    goto_next_start = {
                        ["]a"] = "@parameter.inner",
                        ["]l"] = "@loop.outer",
                        ["]i"] = "@conditional.outer",
                        ["]c"] = "@class.outer",
                        ["]b"] = "@block.outer",
                        ["]e"] = "@assignment.outer",
                        ["]n"] = "@annotation.outer",
                        ["]f"] = "@call.outer",
                    },
                    goto_previous_start = {
                        ["[a"] = "@parameter.inner",
                        ["[l"] = "@loop.outer",
                        ["[i"] = "@conditional.outer",
                        ["[c"] = "@class.outer",
                        ["[b"] = "@block.outer",
                        ["[e"] = "@assignment.outer",
                        ["[n"] = "@annotation.outer",
                        ["[f"] = "@call.outer",
                    },
                },
                select = {
                    enable = true,
                    lookahead = true,
                    keymaps = {
                        ["aa"] = { query = "@parameter.outer" },
                        ["ia"] = { query = "@parameter.inner" },
                        ["al"] = { query = "@loop.outer" },
                        ["il"] = { query = "@loop.inner" },
                        ["ai"] = { query = "@conditional.outer" },
                        ["ii"] = { query = "@conditional.inner" },
                        ["ac"] = { query = "@class.outer" },
                        ["ic"] = { query = "@class.inner" },
                        ["ab"] = { query = "@block.outer" },
                        ["ib"] = { query = "@block.inner" },
                        ["ae"] = { query = "@assignment.lhs" },
                        ["ie"] = { query = "@assignment.rhs" },
                        ["in"] = { query = "@annotation.inner" },
                        ["an"] = { query = "@annotation.outer" },
                        ["af"] = { query = "@call.outer" },
                        ["if"] = { query = "@call.inner" },
                        ["am"] = { query = "@function.outer" },
                        ["im"] = { query = "@function.inner" },
                        ["id"] = { query = "@number.inner" },
                    },
                },
            },
        },
        config = function(_, opts)
            local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")

            vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
            vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)
            vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
            vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
            vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
            vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })
            require("nvim-treesitter.configs").setup(opts)
        end,
    },

    { -- lines down the code window, show indents, and blocks of code
        "shellRaining/hlchunk.nvim",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            ---@diagnostic disable-next-line: missing-fields
            require("hlchunk").setup({
                blank = { enable = false },
                chunk = {
                    enable = true,
                    use_treesitter = true,
                    chars = {
                        horizontal_line = "─",
                        vertical_line = "│",
                        left_top = "┌",
                        left_bottom = "└",
                        right_arrow = "─",
                    },
                    duration = 0,
                    delay = 0,
                },
            })
        end,
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
            vim.keymap.set("n", "<leader>gg", "<cmd>Git<Cr>", { desc = "status" })
            vim.keymap.set("n", "<leader>gd", "<cmd>Gvdiffsplit<Cr>", { desc = "diffvsplt" })
        end,
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
                "<leader>f",
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
            local starter = require('mini.starter')
            starter.setup({
                silent = true,
                header = "[Space Space] files\n[Space e] explorer\n[Space o] recent",
                items = { name = '', action = '', section = '' },
                content_hooks = {
                    starter.gen_hook.padding(10, 20),
                },
                footer = ""
            })

            require("mini.diff").setup()

            require("mini.files").setup({
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
        end,
    },

    { -- Fuzzy Finder (files, lsp, etc)
        "nvim-telescope/telescope.nvim",
        event = "VimEnter",
        branch = "0.1.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            {
                "nvim-tree/nvim-web-devicons",
                enabled = vim.g.have_nerd_font
            },
            { "nvim-telescope/telescope-ui-select.nvim" },
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
                cond = function()
                    return vim.fn.executable("make") == 1
                end,
            },
        },

        config = function()
            require("telescope").setup({
                pickers = { colorscheme = { enable_preview = true } },
                defaults = {
                    layout_strategy = "flex",
                    path_display = { truncate = 3 },
                    layout_config = {
                        horizontal = { height = 0.9 },
                        vertical = { height = 0.9 },
                    },
                },
                extensions = {
                    ["ui-select"] = {
                        require("telescope.themes").get_dropdown(),
                    },
                },
            })
            pcall(require("telescope").load_extension, "fzf")
            pcall(require("telescope").load_extension, "ui-select")
            local builtin = require("telescope.builtin")

            -- find files like vs code ctrl-p
            vim.keymap.set("n", "<leader><leader>", function()
                builtin.find_files({ hidden = true })
            end, { desc = "files" })
            -- grep all, search fuzzy any word
            vim.keymap.set("n", "<leader>/", function()
                builtin.live_grep({ max_results = 50 })
            end, { desc = "grep all" })
            -- word search current word under cursor
            vim.keymap.set("n", "<leader>'", function()
                builtin.grep_string()
            end, { desc = "word" })
            -- old files recently opened
            vim.keymap.set("n", "<leader>o", function()
                builtin.oldfiles({ hidden = true, prompt_title = "recent files" })
            end, { desc = "recent" })
            -- config files
            vim.keymap.set("n", "<leader>,", function()
                builtin.find_files(require("telescope.themes").get_dropdown({
                    cwd = vim.fn.stdpath("config"),
                    previewer = false,
                    layout_config = { height = 10 },
                }))
            end, { desc = "config" })
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
                    map("gd", require("telescope.builtin").lsp_definitions, "definition")
                    map("gr", require("telescope.builtin").lsp_references, "references")
                    --  Useful when your language has ways of declaring types without an actual implementation.
                    map("<leader>li", require("telescope.builtin").lsp_implementations, "implementation")
                    --  the definition of its *type*, not where it was *defined*.
                    map("<leader>lt", require("telescope.builtin").lsp_type_definitions, "type def")
                    --  Symbols are things like variables, functions, types, etc.
                    map("<leader>ls", require("telescope.builtin").lsp_document_symbols, "buff symbols")
                    --  Similar to document symbols, except searches over your entire project.
                    map("<leader>lp", require("telescope.builtin").lsp_dynamic_workspace_symbols, "proj symbols")
                    --  Most Language Servers support renaming across files, etc.
                    map("<leader>lr", vim.lsp.buf.rename, "rename vars")
                    -- Execute a code action, usually your cursor needs to be on top of an error
                    -- or a suggestion from your LSP for this to activate.
                    map("<leader>la", vim.lsp.buf.code_action, "code action")
                end,
            })

            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

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

    { -- Autocompletion, when typing, helps with words, code completion
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = { -- Snippet Engine & its associated nvim-cmp source
            {
                "L3MON4D3/LuaSnip",
                build = (function()
                    if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
                        return
                    end
                    return "make install_jsregexp"
                end)(),
                dependencies = { -- https://github.com/rafamadriz/friendly-snippets
                    {
                        "rafamadriz/friendly-snippets",
                        config = function()
                            require("luasnip.loaders.from_vscode").lazy_load()
                        end,
                    },
                },
            },
            "saadparwaiz1/cmp_luasnip",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "hrsh7th/cmp-buffer",
        },

        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")
            luasnip.config.setup({})
            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                completion = { completeopt = "menu,menuone,noinsert" },
                ---@diagnostic disable-next-line: missing-fields
                performance = {
                    throttle = 300,
                },
                mapping = cmp.mapping.preset.insert({
                    -- Select the [n]ext item
                    ["<C-n>"] = cmp.mapping.select_next_item(),
                    -- Select the [p]revious item
                    ["<C-e>"] = cmp.mapping.select_prev_item(),
                    -- Scroll the documentation window [b]ack / [f]orward
                    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-u>"] = cmp.mapping.scroll_docs(4),
                    -- Accept ([y]es) the completion.
                    ["<C-y>"] = cmp.mapping.confirm({ select = true }),
                    -- Manually trigger a completion from nvim-cmp.
                    ["<C-t>"] = cmp.mapping.complete({}),
                    ["<C-h>"] = cmp.mapping(function()
                        if luasnip.expand_or_locally_jumpable() then
                            luasnip.expand_or_jump()
                        end
                    end, { "i", "s" }),
                    ["<C-k>"] = cmp.mapping(function()
                        if luasnip.locally_jumpable(-1) then
                            luasnip.jump(-1)
                        end
                    end, { "i", "s" }),
                }),
                sources = {
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                    { name = "path" },
                    { name = "buffer" },
                },
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
            -- Use buffer source for `/` and `?`
            cmp.setup.cmdline({ '/', '?' }, {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = 'buffer' }
                },
            })
            -- Use cmdline & path source for ':'
            cmp.setup.cmdline(':', {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = 'path' }
                }, {
                    { name = 'cmdline' }
                }),
            })
        end,
    },
}
