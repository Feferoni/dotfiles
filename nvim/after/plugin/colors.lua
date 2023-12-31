function ColorMyPencils(color)
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { fg = "none", bg = "none" })
    vim.api.nvim_set_hl(0, "CopilotSuggestion", { fg = "#83a598" })
    vim.api.nvim_set_hl(0, "CopilotAnnotation", { fg = "#83a598" })

    local fn = vim.fn
    local cmd = vim.cmd
    local set_theme_path = "$HOME/.config/tinted-theming/set_theme.lua"
    local is_set_theme_file_readable = fn.filereadable(fn.expand(set_theme_path)) == 1 and true or false

    if is_set_theme_file_readable then
        cmd("let base16colorspace=256")
        cmd("source " .. set_theme_path)
    end
end
ColorMyPencils()

local SetColor = function ()
    -- vim.api.nvim_set_hl(0, "FloatBorder", { fg = "none", bg = "none" })
    -- vim.api.nvim_set_hl(0, "NormalFloat", { fg = "none", bg = "none" })
end

local myGroup = vim.api.nvim_create_augroup("SetColor", { clear = true })

vim.api.nvim_create_autocmd("VimEnter", {
    group = myGroup,
    callback = SetColor
})
