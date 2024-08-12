-- [[ plugins ]]
--      colorscheme
--      treesitter
--      hlchunk (pretty indents lines)
--      undotree (undo like git)
--      fugitive (git wrapper)
--      no-neck-pain
--      harpoon
--      conform (auto format code)
--      mini: (ai, starter, surround, files, clue)
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
            highlight = {
                enable = true,
                -- additional_vim_regex_highlighting = { "ruby" },
            },
            indent = {
                enable = true,
                -- disable = { "ruby" }
            },
        },
        config = function(_, opts)
            ---@diagnostic disable-next-line: missing-fields
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
            vim.keymap.set("n", "<leader>g", "<cmd>Git<Cr>", { desc = "Git fugitive" })
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
                        location = '~/.notes/no-neck-pain-scratchpad'
                    },
                    bo = { filetype = 'md' },
                    right = { enabled = false },
                },
            })
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

            vim.keymap.set("n", "<leader>ha", function() harpoon:list():add() end, { desc = "harpoon add" })
            vim.keymap.set("n", "<leader>he", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
                { desc = "harpoon edit" })
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
                desc = "buff format",
            },
        },
        opts = {
            notify_on_error = false,
            format_on_save = function(bufnr)
                local disable_filetypes = { c = true, cpp = true }
                return {
                    timeout_ms = 500,
                    lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
                }
            end,
        },
    },

    { --  Check out: https://github.com/echasnovski/mini.nvim
        "echasnovski/mini.nvim",
        config = function()
            require("mini.ai").setup({ n_lines = 500 })

            local starter = require('mini.starter')
            starter.setup({
                header = "Vlad is a pretty freaking Awesome guy",
                items = {
                    starter.sections.recent_files(5, false),
                    starter.sections.recent_files(5, true),
                },
                content_hooks = {
                    starter.gen_hook.padding(3, 13),
                },
                footer = '',
            })

            require("mini.surround").setup({
                mappings = {
                    add = 'sa',          -- Add surrounding in Normal and Visual modes
                    delete = 'sd',       -- Delete surrounding
                    find = '',           -- Find surrounding (to the right)
                    find_left = '',      -- Find surrounding (to the left)
                    highlight = '',      -- Highlight surrounding
                    replace = 'sr',      -- Replace surrounding
                    update_n_lines = '', -- Update `n_lines`

                    suffix_last = '',    -- Suffix to search with "prev" method
                    suffix_next = '',    -- Suffix to search with "next" method
                },
            })
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

            vim.keymap.set("n", "<leader>e", ":lua Minifile_toggle()<cr>", { desc = "explorer" })
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
                        horizontal = { height = 0.8 },
                        vertical = { height = 0.8 },
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
            end, { desc = "find files" })

            -- grep all, search fuzzy any word
            vim.keymap.set("n", "<leader>/", function()
                builtin.live_grep({ max_results = 50 })
            end, { desc = "find grep all" })

            -- word search current word under cursor
            vim.keymap.set("n", "<leader>'", function()
                builtin.grep_string()
            end, { desc = "find word current" })

            -- old files recently opened
            vim.keymap.set("n", "<leader>o", function()
                builtin.oldfiles({ hidden = true, prompt_title = "recent files" })
            end, { desc = "find recent files" })

            -- config files
            vim.keymap.set("n", "<leader>,", function()
                builtin.find_files(require("telescope.themes").get_dropdown({
                    cwd = vim.fn.stdpath("config"),
                    previewer = false,
                    layout_config = { height = 10 },
                }))
            end, { desc = "config settings" })
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
                    map("<leader>lr", vim.lsp.buf.rename, "rename this vars")

                    -- Execute a code action, usually your cursor needs to be on top of an error
                    -- or a suggestion from your LSP for this to activate.
                    map("<leader>la", vim.lsp.buf.code_action, "code action")

                    -- map("<leader>lh", vim.lsp.buf.declaration, "header declaration")
                end,
            })

            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

            local servers = {
                -- github.com/pmizio/typescript-tools.nvim
                lua_ls = {
                    settings = {
                        Lua = {
                            completion = {
                                callSnippet = "Replace",
                            },
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
        dependencies = {
            -- Snippet Engine & its associated nvim-cmp source
            {
                "L3MON4D3/LuaSnip",
                build = (function()
                    if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
                        return
                    end
                    return "make install_jsregexp"
                end)(),
                dependencies = {
                    --    https://github.com/rafamadriz/friendly-snippets
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
                -- read `:help ins-completion`
                ---@diagnostic disable-next-line: missing-fields
                performance = {
                    max_view_entries = 4,
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
