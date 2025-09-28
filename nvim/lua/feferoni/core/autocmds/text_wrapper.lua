function registerTextWrapperBinding(keymap, wrap_word)
    vim.keymap.set('n', keymap, function()
        vim.cmd('normal! "zyiw')
        local word = vim.fn.getreg('z')
        vim.cmd('normal! diw')
        vim.api.nvim_put({ wrap_word .. '(' .. word .. ')' }, 'c', false, false)
    end, { buffer = true, silent = true })

    vim.keymap.set('x', keymap, function()
        vim.cmd('normal! "zy')
        local text = vim.fn.getreg('z')
        vim.cmd('normal! gvd')
        vim.api.nvim_put({ wrap_word .. '(' .. text .. ')' }, 'c', false, false)
    end, { buffer = true, silent = true })
end

vim.api.nvim_create_autocmd("FileType", {
    pattern = "cpp",
    callback = function()
        registerTextWrapperBinding("mm", "std::move")
        registerTextWrapperBinding("mf", "std::forward")
    end,
})

