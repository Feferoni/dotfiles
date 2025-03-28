local function getThemePath()
    local config_path = vim.fn.isdirectory("/repo/.config") == 1 and "/repo/.config" or vim.fn.expand("~/.config")
    return config_path .. "/tinted-theming/set_theme.lua"
end

local function setColorScheme()
    local theme_path = getThemePath()

    local is_set_theme_file_readable = vim.fn.filereadable(vim.fn.expand(theme_path)) == 1 and true or false
    if is_set_theme_file_readable then
        vim.cmd("let base16colorspace=256")
        vim.cmd("source " .. theme_path)
    end

    vim.api.nvim_set_hl(0, "MatchParen", { fg = "#f0f0f0", bg = "#404040", bold = true })
    -- vim.api.nvim_set_hl(0, "CustomBackdrop", { fg = "none" })
    -- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    -- vim.api.nvim_set_hl(0, "NormalFloat", { fg = "none", bg = "none" })
end

return {
    'tinted-theming/tinted-vim',
    priority = 1000,
    config = function()
        setColorScheme()
    end
}
