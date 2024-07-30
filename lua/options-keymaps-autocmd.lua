vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.opt.guicursor = ""

vim.g.have_nerd_font = true
vim.opt.number = true

vim.opt.sessionoptions = 'buffers,curdir,help,tabpages,winsize'

vim.opt.mouse = "a"

vim.g.netrw_keepdir = 0
vim.g.netrw_banner = 0 -- use I inside to show banner
vim.g.netrw_localcopydircmd = 'cp -r'

-- Sync clipboard between OS and Neovim.
vim.opt.clipboard:append("unnamedplus")

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
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.incsearch = true

-- Keep signcolumn on by default
vim.opt.signcolumn = "yes"

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
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Preview substitutions live, as you type!
vim.opt.inccommand = "split"

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

vim.keymap.set("n", "<c-i>", "<c-i>") -- keep c-i separate from tab keys

vim.keymap.set({ "n", "i", "v", "x" }, "<C-s>", "<Esc><cmd>w<cr>")

vim.keymap.set("n", "<leader>qq", "<cmd>qa<cr>", { desc = "close nvim" })
vim.keymap.set("n", "<leader>L", "<cmd>Lazy<cr>", { desc = "Lazy" })
vim.keymap.set("n", "<leader>M", "<cmd>Mason<cr>", { desc = "Mason" })

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "prev diag" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "next diag" })
vim.keymap.set("n", "<leader>i", vim.diagnostic.open_float, { desc = "show diag" })

local is_diag = false
vim.keymap.set('n', '<leader>x', function()
    if is_diag then
        vim.diagnostic.show()
        is_diag = not is_diag
    else
        vim.diagnostic.hide()
        is_diag = not is_diag
    end
end, { desc = "diag toggle" })

--  See `:help wincmd` for a list of all window commands
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "left win" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "right win" })
vim.keymap.set("n", "<C-k>", "<C-w><C-j>", { desc = "lower win" })
vim.keymap.set("n", "<C-j>", "<C-w><C-k>", { desc = "upper win" })

vim.keymap.set("n", "<leader>wv", "<cmd>vsplit|bnext<cr>", { desc = "vsplit -->" })
vim.keymap.set("n", "<leader>ws", "<cmd>sbn<cr>", { desc = "split down" })
vim.keymap.set("n", "<leader>wr", "<C-w>r", { desc = "rotate (swap)" })

vim.keymap.set("n", "<leader>ww", "15<C-w>>", { desc = "wider <-+->" })
vim.keymap.set("n", "<leader>wh", "15<C-w>+", { desc = "taller heighten" })

vim.keymap.set("n", "<leader>c", "<C-w>q", { desc = "win close" })

-- move lines up or down, Alt-Up/Down
vim.keymap.set("n", "<A-Down>", "<cmd>m .+1<cr>==")
vim.keymap.set("n", "<A-Up>", "<cmd>m .-2<cr>==")
vim.keymap.set("i", "<A-Down>", "<Esc><cmd>m .+1<cr>==gi")
vim.keymap.set("i", "<A-Up>", "<Esc><cmd>m .-2<cr>==gi")
vim.keymap.set("v", "<A-Down>", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "<A-Up>", ":m '<-2<CR>gv=gv")

vim.keymap.set("v", "<Tab>", ">gv")
vim.keymap.set("v", "<S-Tab>", "<gv")

-- center cursor when jump scrolling
vim.keymap.set("n", "n", "nzz")
vim.keymap.set("n", "N", "Nzz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<C-d>", "<C-d>zz")

vim.keymap.set({ "v" }, "y", "ygv<esc>", { desc = "restore cursor position after yank" })
vim.keymap.set({ "n" }, "<cr>", "i<cr><esc>l", { desc = "split line down at cursor" })
vim.keymap.set("n", "<leader>p", 'diw"0P', { desc = "word paste" })
vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set({ "x", "v" }, "p", [["_dP]], { desc = "stamp word" }) -- put word without yanking replaced
vim.keymap.set("n", "Y", "Yg$")
vim.keymap.set(
    "n",
    "<leader>r",
    [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
    { desc = "word rename all" }
)

-- get to Git log and lazygit
vim.keymap.set("n", "<leader>g", [[<cmd>!tmux neww -c 'lazygit<Cr>']], { desc = "lazygit" })

-- get to next buffer with n and prev buffer with i
vim.keymap.set("n", "<leader>n", "<cmd>bn<Cr>", { desc = "buff next" })
vim.keymap.set("n", "<leader>i", "<cmd>bp<Cr>", { desc = "buff prev" })
vim.keymap.set("n", "<leader>d", "<cmd>%bd|e#<Cr>", { desc = "buff close all other" })

-- select all using typecal ctrl-a keymap keys press
vim.keymap.set("n", "C-a", "ggVG", { desc = "select all" })

-- in highlight, add ' or " around highlight
vim.keymap.set("v", [["]], [[:s/\%V\%V\(\w\+\)/"\1"/g<CR>gv]])
vim.keymap.set("v", [[']], [[:s/\%V\%V\(\w\+\)/'\1'/g<CR>gv]])

-- [[Auto Commands]] - event functions - autocommands
-- functions that run on some event
vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking (copying) text",
    group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
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

-- start vim with telescope open find_files
-- vim.api.nvim_create_autocmd("VimEnter", {
--     callback = function()
--         if vim.fn.argv(0) == "" then
--             require("telescope.builtin").find_files()
--         end
--     end,
-- })

vim.api.nvim_create_autocmd('filetype', {
    pattern = 'netrw',
    desc = 'Better mappings for netrw',
    callback = function()
        local bind = function(lhs, rhs)
            vim.keymap.set('n', lhs, rhs, { remap = true, buffer = true })
        end
        -- edit new file
        bind('n', '%')
        -- rename file
        bind('r', 'R')
        -- move up directory
        bind('<Left>', '-^')
        -- open file | dir
        bind('<Right>', '<CR>')
        -- show hide dotfiles
        bind('.', 'gh')
    end
})
