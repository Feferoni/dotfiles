vim.opt.guicursor = ""

-- selection will extend up to but not including, the cursor position
-- vim.o.selection = "exclusive"
vim.o.virtualedit = "onemore"

-- disable netrw at the very start of your init.lua - to make file tree better
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.guicursor = "i-ci-ve:ver25"

vim.opt.showmatch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")


vim.opt.updatetime = 50

vim.gmapleader = " "

vim.g.base16_colorspace = 256
vim.opt.colorcolumn = "150"

vim.o.foldmethod = 'expr'
vim.o.foldexpr = 'v:lua.vim.lsp.foldexpr()'
vim.o.foldlevelstart = -1
vim.o.foldlevel = 50

vim.diagnostic.config({ virtual_text = true, })
