vim.schedule(function()
    vim.opt.tabstop = 4
    vim.opt.shiftwidth = 4
    vim.bo.softtabstop = 4
    vim.opt.expandtab = true
    vim.bo.cindent = true
end)

vim.b.did_indent = 1
