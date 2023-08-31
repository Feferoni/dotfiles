vim.api.nvim_create_autocmd("FileType", {
    pattern = "lua",
    callback = function()
        vim.schedule(function()
            vim.cmd("setlocal tabstop=4 shiftwidth=4 expandtab")
        end)
    end,
    -- command = "lua setlocal tabstop=4 shiftwidth=4 expandtab"
})

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    pattern = {"*"},
    callback = function()
        save_cursor = vim.fn.getpos(".")
        vim.cmd([[%s/\s\+$//e]])
        vim.fn.setpos(".", save_cursor)
    end,
})
