---@diagnostic disable-next-line: missing-fields
vim.api.nvim_create_autocmd("FileType", {
    pattern = "lua",
    callback = function()
        vim.schedule(function()
            vim.cmd("setlocal tabstop=4 shiftwidth=4 expandtab")
        end)
    end,
})

---@diagnostic disable-next-line: missing-fields
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
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

local SetColor = function()
    -- vim.api.nvim_set_hl(0, "FloatBorder", { fg = "none", bg = "none" })
    -- vim.api.nvim_set_hl(0, "NormalFloat", { fg = "none", bg = "none" })
end

local myGroup = vim.api.nvim_create_augroup("SetColor", { clear = true })

---@diagnostic disable-next-line: missing-fields
vim.api.nvim_create_autocmd("VimEnter", {
    group = myGroup,
    callback = SetColor
})
