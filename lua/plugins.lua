return {
	-- colorscheme
	{ "catppuccin/nvim", event = "VeryLazy" },
	{ "morhetz/gruvbox", event = "VeryLazy" },
	{ "folke/tokyonight.nvim", event = "VeryLazy" },
	{ "sainnhe/gruvbox-material", event = "VeryLazy" },
	{
		"neanias/everforest-nvim",
		version = false,
		lazy = false,
		priority = 1000, -- make sure to load this before all the other start plugins
		-- Optional; default configuration will be used if setup isn't called.
		config = function()
			require("everforest").setup({
				vim.cmd([[colorscheme everforest]]),
			})
		end,
	},

	{ -- forget which key does what, visual help for next key press
		"folke/which-key.nvim",
		event = "VimEnter", -- Sets the loading event to 'VimEnter'
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 500
		end,
		config = function() -- This is the function that runs, AFTER loading
			require("which-key").setup({
				presets = { operators = false, motions = false, text_objects = false },
				key_labels = { ["<space>"] = "space", ["<cr>"] = "return", ["<tab>"] = "tab" },
				window = {
					margin = { 0, 0, 0, 0 },
					padding = { 2, 0, 2, 0 },
					winblend = 10,
				},
				spelling = { suggestions = 5 },
				layout = { height = { min = 3, max = 25 }, width = { min = 20, max = 50 }, spacing = 1 },
				show_help = false,
			})

			-- Document existing key chains
			require("which-key").register({
				["<leader>c"] = { name = "code", _ = "which_key_ignore" },
				["<leader>w"] = { name = "window", _ = "which_key_ignore" },
				["<leader>/"] = { name = "search in", _ = "which_key_ignore" },
				["<leader>x"] = { name = "errors", _ = "which_key_ignore" },
				["<leader>r"] = { name = "run code", _ = "which_key_ignore" },
				["<leader>q"] = { name = "quit", _ = "which_key_ignore" },
			})
		end,
	},

	{ -- cycle through buffers list
		"ghillb/cybu.nvim",
		-- branch = "main", -- timely updates
		branch = "v1.x", -- won't receive breaking changes
		requires = { "nvim-tree/nvim-web-devicons", "nvim-lua/plenary.nvim" }, -- optional for icon support
		config = function()
			require("cybu").setup({
				position = { anchor = "bottomright" },
				display_time = 2500,
				behavior = { -- set behavior for different modes
					mode = {
						default = {
							view = "paging", -- paging, rolling
						},
						auto = {
							view = "paging", -- paging, rolling
						},
					},
				},
			})
			vim.keymap.set({ "n" }, "<c-s-tab>", ":CybuPrev<cr>", { desc = "prev buffer cycle" })
			vim.keymap.set({ "n" }, "<c-tab>", ":CybuNext<cr>", { desc = "next buffer cycle" })
		end,
	},

	{ -- Fuzzy Finder (files, lsp, etc)
		"nvim-telescope/telescope.nvim",
		event = "VimEnter",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ -- If encountering errors, see telescope-fzf-native README for installation instructions
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
				cond = function()
					return vim.fn.executable("make") == 1
				end,
			},
			{ "nvim-telescope/telescope-ui-select.nvim" },
			{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
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
					winblend = 10,
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
			end, { desc = "files" })

			-- grep all, search fuzzy any word
			vim.keymap.set("n", "<leader>//", function()
				builtin.live_grep({ max_results = 50 })
			end, { desc = "grep all" })

			-- word search current word under cursor
			vim.keymap.set("n", "//", function()
				builtin.grep_string()
			end, { desc = "word search this current word" })

			-- old files recently opened
			vim.keymap.set("n", "<leader>o", function()
				builtin.oldfiles({ hidden = true, prompt_title = "recent files" })
			end, { desc = "recent files" })

			-- switch colors scheme theme change colors
			vim.keymap.set("n", "<leader>/t", function()
				builtin.colorscheme()
			end, { desc = "theme colors" })

			-- config files
			vim.keymap.set("n", "<leader>/c", function()
				builtin.find_files(require("telescope.themes").get_dropdown({
					cwd = vim.fn.stdpath("config"),
					previewer = false,
					layout_config = { height = 10 },
				}))
			end, { desc = "config files" })

			-- !
			vim.keymap.set("n", "<leader>/!", builtin.planets, { desc = "search pluto / moon" })
		end,
	},

	{ -- LSP Configuration & Plugins
		"neovim/nvim-lspconfig",
		dependencies = {
			-- Automatically install LSPs and related tools to stdpath for Neovim
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",

			-- Useful status updates for LSP.
			-- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
			{ "j-hui/fidget.nvim", opts = {} },

			-- `neodev` configures Lua LSP for your Neovim config, runtime and plugins
			-- used for completion, annotations and signatures of Neovim apis
			{ "folke/neodev.nvim", opts = {} },
		},
		config = function()
			-- LSP provides Neovim with features like:
			--  - Go to definition - Find references - Autocompletion - Symbol Search
			-- help lsp-vs-treesitter

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
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
					map("<leader>/s", require("telescope.builtin").lsp_document_symbols, "document symbols")

					--  Similar to document symbols, except searches over your entire project.
					map("<leader>/p", require("telescope.builtin").lsp_dynamic_workspace_symbols, "project symbols")

					--  Most Language Servers support renaming across files, etc.
					map("<leader>cn", vim.lsp.buf.rename, "rename this var")

					-- Execute a code action, usually your cursor needs to be on top of an error
					-- or a suggestion from your LSP for this to activate.
					map("<leader>ca", vim.lsp.buf.code_action, "code action")

					map("K", vim.lsp.buf.hover, "hover documentation")

					map("gD", vim.lsp.buf.declaration, "header declaration")

					-- The following two autocommands are used to highlight references of the
					-- word under your cursor when your cursor rests there for a little while.
					--    See `:help CursorHold` for information about when this is executed
					--
					-- When you move your cursor, the highlights will be cleared (the second autocommand).
					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if client and client.server_capabilities.documentHighlightProvider then
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = event.buf,
							callback = vim.lsp.buf.document_highlight,
						})

						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = event.buf,
							callback = vim.lsp.buf.clear_references,
						})
					end
				end,
			})

			-- LSP servers and clients are able to communicate to each other what features they support.
			--  By default, Neovim doesn't support everything that is in the LSP specification.
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
				-- clangd = {},
				-- gopls = {},
				-- pyright = {},
				-- python-lsp-server = {},
				-- ruff = {},
				-- rust_analyzer = {},

				-- help lspconfig-all
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
							-- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
							-- diagnostics = { disable = { 'missing-fields' } },
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
		lazy = false,
		keys = {
			{
				"<leader>cf",
				function()
					require("conform").format({ async = true, lsp_fallback = true })
				end,
				mode = "",
				desc = "format buffer",
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
				lua = { "stylua" },
				-- Conform can also run multiple formatters sequentially
				python = { "autoflake", "ruff" },
				--
				-- You can use a sub-list to tell conform to run *until* a formatter
				-- is found.
				javascript = { { "prettierd", "prettier" } },
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
					["<C-Space>"] = cmp.mapping.complete({}),

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
				},
			})
		end,
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
				max_lines = 8,
			})
			vim.keymap.set("n", "[c", function()
				require("treesitter-context").go_to_context(vim.v.count1)
			end, { silent = true, desc = "top context" })
		end,
	},

	{ -- colored brackets and parentheses and more
		"p00f/nvim-ts-rainbow",
		config = function()
			---@diagnostic disable-next-line: missing-fields
			require("nvim-treesitter.configs").setup({
				rainbow = {
					enable = true,
					-- list of languages you want to disable the plugin for
					-- disable = { "jsx", "cpp" }
					-- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
					extended_mode = true,
					-- Do not enable for files with more than n lines, int
					max_file_lines = 1000,
					-- colors = {}, -- table of hex strings
					-- termcolors = {} -- table of colour name strings
				},
			})
		end,
	},

	{ -- leap around a page, hop, use s or S to highlight blocks of code quickly
		"folke/flash.nvim",
		event = "VeryLazy",
		--@type Flash.Config
		opts = {},
		config = function()
			require("flash").setup({
				labels = "tnseriaodhcplfuwyxgmvkbjzq",
				-- disable f,F,T,t,;,, modes, no highlights
				modes = {
					search = { enabled = false },
					char = { enabled = false },
				},
			})
		end,
        -- stylua: ignore
        keys = {
          { 's', mode = { 'n', 'x', 'o' }, function() require('flash').jump() end, desc = 'flash' },
          { 'S', mode = { 'n', 'o', 'x' }, function() require('flash').treesitter() end, desc = 'flash treesitter' },
          { '<c-s>', mode = { 'c' }, function() require('flash').toggle() end, desc = 'toggle flash search' },
        },
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
			vim.keymap.set(
				"n",
				"<leader>cb",
				require("gitsigns").toggle_current_line_blame,
				{ desc = "blame git line" }
			)
		end,
	},

	{ -- terminal, toggle, lazygit, run python code, multiple terminals with <num><C-/>
		"akinsho/toggleterm.nvim",
		version = "*",

		config = function()
			require("toggleterm").setup({
				open_mapping = [[<C-/>]],
				size = function(term)
					if term.direction == "horizontal" then
						return 20
					elseif term.direction == "vertical" then
						return vim.o.columns * 0.4
					end
				end,
				float_opts = {
					border = "",
					winblend = 10,
				},
			})

			function _G.set_terminal_keymaps()
				local opts = { buffer = 0 }
				vim.keymap.set("t", "<esc><esc>", [[<C-\><C-n>]], opts)
				vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
				vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd j<CR>]], opts)
				vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd k<CR>]], opts)
				vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
			end

			-- if you only want these mappings for toggle term use term://*toggleterm#* instead
			vim.cmd("autocmd! TermOpen term://*toggleterm#* lua set_terminal_keymaps()")

			-- lazygit terminal custom
			local Terminal = require("toggleterm.terminal").Terminal
			local lazygit = Terminal:new({
				cmd = "lazygit",
				dir = "git_dir",
				hidden = true,
				direction = "float",
				-- function to run on opening the terminal
				on_open = function(term)
					vim.cmd("startinsert!")
					vim.api.nvim_buf_set_keymap(
						term.bufnr,
						"n",
						"q",
						"<cmd>close<CR>",
						{ noremap = true, silent = true }
					)
				end,
			})

			function Toggle_lazygit()
				lazygit:toggle()
			end

			-- lazygit terminal keymap
			vim.api.nvim_set_keymap(
				"n",
				"<leader>g",
				"<cmd>lua Toggle_lazygit()<CR>",
				{ desc = "lazygit", noremap = true, silent = true }
			)

			-- run python down
			vim.keymap.set("n", "<leader>rr", '<cmd>TermExec cmd="python3 %"<cr>', { desc = "run python file down" })

			-- run python side
			vim.keymap.set(
				"n",
				"<leader>rs",
				'<cmd>TermExec cmd="python3 %" direction=vertical<cr>',
				{ desc = "run python file on side ->" }
			)
			-- run python install modules from cwd
			vim.keymap.set(
				"n",
				"<leader>ri",
				'<cmd>TermExec cmd="python3 -m pip install ."<cr>',
				{ desc = "run python pip install ." }
			)

			vim.keymap.set("n", "<leader>t", "<cmd>ToggleTerm direction=vertical<cr>", { desc = "terminal vertical" })
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
			-- - gsaiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
			-- - gsd'   - [S]urround [D]elete [']quotes
			-- - gsr)'  - [S]urround [R]eplace [)] [']
			require("mini.surround").setup({
				-- Module mappings. Use `''` (empty string) to disable one.
				mappings = {
					add = "gsa", -- Add surrounding in Normal and Visual modes
					delete = "gsd", -- Delete surrounding
					replace = "gsr", -- Replace surrounding
				},
			})

			-- delete buffer, buffer remove
			require("mini.bufremove").setup()
			vim.keymap.set("n", "<leader>d", ":lua MiniBufremove.delete()<cr>", { desc = "buffer delete" })

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

			require("mini.hipatterns").setup({
				highlighters = {
					-- Highlight hex color strings (`#rrggbb`) using that color
					hex_color = require("mini.hipatterns").gen_highlighter.hex_color(),
				},
			})

			require("mini.comment").setup({})
		end,
	},

	{ -- undo and redo visually
		"mbbill/undotree",
		config = function()
			vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = "undotree" })
		end,
	},

	{ -- save restore autosession
		"rmagatti/auto-session",
		config = function()
			require("auto-session").setup({
				log_level = "error",
				auto_session_suppress_dirs = { "~/", "~/Downloads", "/" },
			})
			vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

			local keymap = vim.keymap
			keymap.set("n", "<leader>qr", "<cmd>SessionRestore<cr>", { desc = "restore session" })
			keymap.set("n", "<leader>qs", "<cmd>SessionSave<cr>", { desc = "save session" })
			keymap.set("n", "<leader>qd", "<cmd>SessionDelete<cr>", { desc = "delete session" })
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

	{ "eandrju/cellular-automaton.nvim" },

	{ "tommcdo/vim-exchange" },

	-- dim inactive portions of your code
	{ "folke/twilight.nvim", opts = { dimming = { alpha = 0.35 } } },

	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("lualine").get_config()
			require("lualine").setup({
				options = { section_separators = "" },
				sections = {
					lualine_a = { "progress", "searchcount" },
					lualine_b = { "diff", { "diagnostics", sections = { "error", "warn" } } },
					lualine_c = { { "filename", path = 1 } },
					lualine_x = {},
					lualine_y = {},
					lualine_z = {},
				},
				inactive_sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = { "filename" },
					lualine_x = {},
					lualine_y = {},
					lualine_z = {},
				},
			})
		end,
	},
}
