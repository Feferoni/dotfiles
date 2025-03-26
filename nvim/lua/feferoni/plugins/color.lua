local function SetColorScheme()
    local set_theme_path = "/repo/.config/tinted-theming/set_theme.lua"
    local is_set_theme_file_readable = vim.fn.filereadable(vim.fn.expand(set_theme_path)) == 1 and true or false

    if is_set_theme_file_readable then
        vim.cmd("let base16colorspace=256")
        vim.cmd("source " .. set_theme_path)
    end


    vim.api.nvim_set_hl(0, "MatchParen", { fg = "#f0f0f0", bg = "#404040", bold = true })
    ---@diagnostic disable: missing-fields
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { fg = "none", bg = "none" })
    -- This is for flash plugin color scheme
    vim.api.nvim_set_hl(0, "CustomBackdrop", { fg = "none" })
    ---@diagnostic enable: missing-fields
end

return {
    'tinted-theming/tinted-vim',
    priority = 1000,
    config = function()
        SetColorScheme()
    end
}
