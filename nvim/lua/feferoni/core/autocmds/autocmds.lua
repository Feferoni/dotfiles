---@diagnostic disable-next-line: missing-fields
vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- Prevent snippet placeholder replacements from overwriting the unnamed register
local select_reg_group = vim.api.nvim_create_augroup('preserve-reg-in-select', { clear = true })
vim.api.nvim_create_autocmd("ModeChanged", {
    group = select_reg_group,
    pattern = "*:s",
    callback = function()
        vim.g._sel_reg = vim.fn.getreg('"')
        vim.g._sel_reg_type = vim.fn.getregtype('"')
    end,
})
vim.api.nvim_create_autocmd("ModeChanged", {
    group = select_reg_group,
    pattern = "s:*",
    callback = function()
        vim.schedule(function()
            if vim.g._sel_reg then
                vim.fn.setreg('"', vim.g._sel_reg, vim.g._sel_reg_type)
            end
        end)
    end,
})

---@diagnostic disable-next-line: missing-fields
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    pattern = { "*" },
    callback = function()
        local save_cursor = vim.fn.getpos(".")
        vim.cmd([[%s/\s\+$//e]])
        vim.fn.setpos(".", save_cursor)
    end,
})
