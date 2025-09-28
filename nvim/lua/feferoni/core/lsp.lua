vim.lsp.set_log_level("error") -- debug, info, error, off

vim.diagnostic.config({
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = ' ',
            [vim.diagnostic.severity.WARN] = ' ',
            [vim.diagnostic.severity.INFO] = ' ',
            [vim.diagnostic.severity.HINT] = ' ',
        },
    },
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    virtual_text = false,
})

vim.lsp.enable({
    'bashls',
    'clangd',
    'cmake',
    'gopls',
    'jasonls',
    'luals',
    'marksman',
    'pyright',
    'zls',
})
