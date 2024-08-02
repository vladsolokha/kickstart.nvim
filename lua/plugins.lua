-- [[ plugins in order ]]
-- color, theme, ui, how it looks
--      colorscheme
--      which-key
--      treesitter
--      context
--      gitsigns
--      hlchunk (pretty indents)
--      harpoon
-- code, format, lsp, stuff that affects code
--      telescope: plenary, web-dev-icons, ui-select, fzf-native, ripgrep (ext. install)
--      lspconfig: mason, tool-installer, fidget, neodev
--      conform (auto format code)
--      cmp: LuaSnip, snippets, luasnip, path, cmdline, buffer
--      mini: (ai, surround, explorer, comment)
--      undotree (undo like git)
--      auto-session
return {
    { -- colorscheme
        "miikanissi/modus-themes.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            require("modus-themes").setup({
                vim.cmd([[colorscheme modus_operandi]]),
            })
        end,
    },

    { -- forget which key does what, visual help for next key press
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {
            delay = 1000,
            win = {
                height = { min = 2, max = 20 },
                padding = { 0, 0 },
                title = false,
            },
            layout = {
                width = { min = 20, max = 30 },
                spacing = 2,
            },
            plugins = {
                marks = false,
                spelling = { enabled = false },
                presets = { z = false },
            },
            spec = {
                { "<leader>q", group = "quit" },
                { "<leader>w", group = "windows" },
            },
            expand = 3, -- expand groups when <= 5 mappings
            replace = {
                key = {
                    { "<CR>",    "ret" },
                    { "<Space>", "spc" },
                    { "<Esc>",   "esc" },
                    { "<BS>",    "bs" },
                },
            },
            icons = {
                mappings = false,
            },
            show_help = false,
            show_keys = false,
        },
        keys = {},
    },

    { -- Highlight, edit, and navigate code
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        opts = {
            ensure_installed = {},
            -- Autoinstall languages that are not installed
            auto_install = true,
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = { "ruby" },
            },
            indent = { enable = true, disable = { "ruby" } },
        },
        config = function(_, opts)
            -- [[ Configure Treesitter ]] See `:help nvim-treesitter`

            ---@diagnostic disable-next-line: missing-fields
            require("nvim-treesitter.configs").setup(opts)
        end,
    },

    { -- context of functions and other long statements on treesitter
        "nvim-treesitter/nvim-treesitter-context",
        config = function()
            require("treesitter-context").setup({
                max_lines = 2,
            })
            vim.keymap.set("n", "[c", function()
                require("treesitter-context").go_to_context(vim.v.count1)
            end, { silent = true, desc = "top context" })
        end,
    },

    { -- Adds git related signs to the gutter, as well as utilities for managing changes
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup({
                signs = {
                    add = { text = "+" },
                    change = { text = "~" },
                    delete = { text = "_" },
                    topdelete = { text = "‾" },
                    changedelete = { text = "~" },
                },
            })
        end,
    },

    { -- lines down the code window, show indents, and blocks of code
        "shellRaining/hlchunk.nvim",
        event = "UIEnter",
        config = function()
            ---@diagnostic disable-next-line: missing-fields
            require("hlchunk").setup({ blank = { enable = false } })
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
            vim.keymap.set("n", "<leader>hi", function() harpoon:list():select(3) end, { desc = "harpoon 3" })
            vim.keymap.set("n", "<leader>ho", function() harpoon:list():select(4) end, { desc = "harpoon 4" })
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
            { -- If encountering errors, see telescope-fzf-native README for installation instructions
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
                cond = function()
                    return vim.fn.executable("make") == 1
                end,
            },
        },
        config = function()
            -- [[ Configure Telescope ]]
            -- See `:help telescope` and `:help telescope.setup()`
            require("telescope").setup({
                -- You can put your default mappings / updates / etc. in here
                --  All the info you're looking for is in `:help telescope.setup()`
                -- defaults = { mappings = { i = { ['<c-enter>'] = 'to_fuzzy_refine' }, }, },
                pickers = { colorscheme = { enable_preview = true } },
                defaults = {
                    layout_strategy = "flex",
                    path_display = { truncate = 3 },
                    layout_config = {
                        horizontal = { height = 0.6 },
                        vertical = { height = 0.6 },
                    },
                },
                extensions = {
                    ["ui-select"] = {
                        require("telescope.themes").get_dropdown(),
                    },
                },
            })

            -- Enable Telescope extensions if they are installed
            pcall(require("telescope").load_extension, "fzf")
            pcall(require("telescope").load_extension, "ui-select")

            -- [[ Telescope keymaps ]]
            -- help telescope.builtin
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
            vim.keymap.set("n", "//", function()
                builtin.grep_string()
            end, { desc = "find word current" })

            -- old files recently opened
            vim.keymap.set("n", "<leader>o", function()
                builtin.oldfiles({ hidden = true, prompt_title = "recent files" })
            end, { desc = "find recent files" })

            -- switch colors scheme theme change colors
            vim.keymap.set("n", "<leader>m", function()
                builtin.colorscheme()
            end, { desc = "mood colors" })

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
            -- Automatically install LSPs and related tools to stdpath for Neovim
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "WhoIsSethDaniel/mason-tool-installer.nvim",
            -- `neodev` configures Lua LSP for your Neovim config, runtime and plugins
            -- used for completion, annotations and signatures of Neovim apis
            { "folke/neodev.nvim", opts = {} },
        },
        config = function()
            -- LSP provides Neovim with features like:
            --  - Go to definition - Find references - Autocompletion - Symbol Search
            -- help lsp-vs-treesitter

            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(event)
                    local map = function(keys, func, desc)
                        vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "lsp: " .. desc })
                    end

                    --  To jump back, press <C-t>.
                    map("gd", require("telescope.builtin").lsp_definitions, "definition")
                    map("gr", require("telescope.builtin").lsp_references, "references")

                    --  Useful when your language has ways of declaring types without an actual implementation.
                    map("gI", require("telescope.builtin").lsp_implementations, "implementation")

                    --  the definition of its *type*, not where it was *defined*.
                    map("gy", require("telescope.builtin").lsp_type_definitions, "type definition")

                    --  Symbols are things like variables, functions, types, etc.
                    map("gb", require("telescope.builtin").lsp_document_symbols, "buff symbols")

                    --  Similar to document symbols, except searches over your entire project.
                    map("ga", require("telescope.builtin").lsp_dynamic_workspace_symbols, "all symbols")

                    --  Most Language Servers support renaming across files, etc.
                    map("gR", vim.lsp.buf.rename, "rename this vars")

                    -- Execute a code action, usually your cursor needs to be on top of an error
                    -- or a suggestion from your LSP for this to activate.
                    map("<leader>a", vim.lsp.buf.code_action, "code action")

                    map("K", vim.lsp.buf.hover, "hover documentation")

                    map("gD", vim.lsp.buf.declaration, "header declaration")

                    -- highlight references of the word under your cursor while resting
                    -- help CursorHold
                    local client = vim.lsp.get_client_by_id(event.data.client_id)
                    if client and client.server_capabilities.documentHighlightProvider then
                        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                            buffer = event.buf,
                            callback = vim.lsp.buf.document_highlight,
                        })

                        -- When you move your cursor, the highlights will be cleared
                        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                            buffer = event.buf,
                            callback = vim.lsp.buf.clear_references,
                        })
                    end
                end,
            })

            -- LSP servers and clients are able to communicate to each other what features they support.
            -- By default, Neovim doesn't support everything that is in the LSP specification.
            --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
            --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

            --  Add any additional override configuration in the following tables. Available keys are:
            --  - cmd (table): Override the default command used to start the server
            --  - filetypes (table): Override the default list of associated filetypes for the server
            --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
            --  - settings (table): Override the default settings passed when initializing the server.
            --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
            local servers = {
                -- pyright = {},
                -- python-lsp-server = {},
                -- ruff = {},
                -- help lspconfig-all  -- for all other servers
                -- github.com/pmizio/typescript-tools.nvim
                -- tsserver = {},
                lua_ls = {
                    -- cmd = {...},
                    -- filetypes = { ...},
                    -- capabilities = {},
                    settings = {
                        Lua = {
                            completion = {
                                callSnippet = "Replace",
                            },
                        },
                    },
                },
            }
            -- Ensure the servers and tools above are installed
            -- To check the current status of installed tools and/or
            -- manually install other tools, you can run
            -- :Mason
            require("mason").setup()

            local ensure_installed = vim.tbl_keys(servers or {})
            vim.list_extend(ensure_installed, {
                "stylua", -- Used to format Lua code
            })
            require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

            require("mason-lspconfig").setup({
                handlers = {
                    function(server_name)
                        local server = servers[server_name] or {}
                        -- This handles overriding only values explicitly passed
                        -- by the server configuration above. Useful when disabling
                        -- certain features of an LSP (for example, turning off formatting for tsserver)
                        server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
                        require("lspconfig")[server_name].setup(server)
                    end,
                },
            })
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
                -- Disable "format_on_save lsp_fallback" for languages that don't
                -- have a well standardized coding style. You can add additional
                -- languages here or re-enable it for the disabled ones.
                local disable_filetypes = { c = true, cpp = true }
                return {
                    timeout_ms = 500,
                    lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
                }
            end,
            formatters_by_ft = {
                -- installing these via mason
                -- lua = { "stylua" },
                -- Conform can also run multiple formatters sequentially
                -- python = { "autoflake", "ruff" },
                -- You can use a sub-list to tell conform to run *until* a formatter is found.
                -- javascript = { { "prettierd", "prettier" } },
            },
        },
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
                    -- `friendly-snippets` contains a variety of premade snippets.
                    --    See the README about individual language/framework/plugin snippets:
                    --    https://github.com/rafamadriz/friendly-snippets
                    {
                        "rafamadriz/friendly-snippets",
                        config = function()
                            require("luasnip.loaders.from_vscode").lazy_load()
                            --- will exclude all javascript snippets
                            --     exclude = { "javascript" },
                        end,
                    },
                },
            },
            "saadparwaiz1/cmp_luasnip",
            -- Adds other completion capabilities.
            --  nvim-cmp does not ship with all sources by default. They are split
            --  into multiple repos for maintenance purposes.
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "hrsh7th/cmp-buffer",
        },
        config = function()
            -- See `:help cmp`
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
                    throttle = 800,
                },
                mapping = cmp.mapping.preset.insert({
                    -- Select the [n]ext item
                    ["<C-n>"] = cmp.mapping.select_next_item(),
                    -- Select the [p]revious item
                    ["<C-p>"] = cmp.mapping.select_prev_item(),

                    -- Scroll the documentation window [b]ack / [f]orward
                    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-u>"] = cmp.mapping.scroll_docs(4),

                    -- Accept ([y]es) the completion.
                    ["<C-y>"] = cmp.mapping.confirm({ select = true }),
                    -- Manually trigger a completion from nvim-cmp.
                    ["<C-k>"] = cmp.mapping.complete({}),

                    -- <c-l> will move you to the right of each of the expansion locations.
                    -- <c-h> is similar, except moving you backwards.
                    ["<C-l>"] = cmp.mapping(function()
                        if luasnip.expand_or_locally_jumpable() then
                            luasnip.expand_or_jump()
                        end
                    end, { "i", "s" }),
                    ["<C-h>"] = cmp.mapping(function()
                        if luasnip.locally_jumpable(-1) then
                            luasnip.jump(-1)
                        end
                    end, { "i", "s" }),

                    -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
                    --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
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

    { --  Check out: https://github.com/echasnovski/mini.nvim
        "echasnovski/mini.nvim",
        config = function()
            -- Better Around/Inside textobjects
            --  - va)  - [V]isually select [A]round [)]paren
            --  - yinq - [Y]ank [I]nside [N]ext [']quote
            --  - ci'  - [C]hange [I]nside [']quote
            require("mini.ai").setup({ n_lines = 500 })

            -- Add/delete/replace surroundings (brackets, quotes, etc.)
            -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
            -- - sd'   - [S]urround [D]elete [']quotes
            -- - sr)'  - [S]urround [R]eplace [)] [']
            require("mini.surround").setup({
                -- Module mappings. Use `''` (empty string) to disable one.
                mappings = {
                    add = "sa",     -- Add surrounding in Normal and Visual modes
                    delete = "sd",  -- Delete surrounding
                    replace = "sr", -- Replace surrounding
                },
            })

            -- files mini files explorer tree
            require("mini.files").setup({
                mappings = {
                    go_in = "<Right>",
                    go_in_plus = "<S-Right>",
                    go_out = "<Left>",
                    go_out_plus = "<S-Left>",
                },
            })

            function Minifile_toggle()
                if not MiniFiles.close() then
                    MiniFiles.open()
                end
            end

            vim.keymap.set("n", "<leader>e", ":lua Minifile_toggle()<cr>", { desc = "explorer" })

            require("mini.comment").setup()
        end,
    },

    { -- undo and redo visually
        "mbbill/undotree",
        config = function()
            vim.keymap.set("n", "<leader>u", "<cmd>UndotreeToggle<cr><cmd>UndotreeFocus<cr>", { desc = "undotree" })
        end,
    },

    {
        "tpope/vim-fugitive",
        config = function()
            vim.keymap.set(
                "n",
                "<leader>b",
                "<cmd>Git blame<CR>",
                { desc = "Git blame toggle" }
            )
            vim.keymap.set("n", "<leader>G", "<cmd>Git<Cr>", { desc = "Git fugitive" })
        end,
    }

}
