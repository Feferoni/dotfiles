vim.opt.formatoptions:remove('r')
vim.opt.formatoptions:remove('o')
-- vim.opt_local.foldmethod = "syntax"
vim.opt_local.foldmethod = "indent"
-- vim.opt_local.foldenable = false
vim.opt_local.foldlevelstart = 20
vim.opt_local.foldlevel = 20
-- vim.opt_local.foldnestmax = 3
vim.opt_local.foldminlines = 1

vim.bo.commentstring = "//%s"
