local function SetColorScheme()
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { fg = "none", bg = "none" })
    vim.api.nvim_set_hl(0, "CopilotSuggestion", { fg = "#83a598" })
    vim.api.nvim_set_hl(0, "CopilotAnnotation", { fg = "#83a598" })

    local theme = os.getenv("BASE16_THEME")
    if theme then
        vim.cmd('colorscheme base16-' .. theme)
    end
end

return {
    'tinted-theming/base16-vim',
    priority = 1000,
    config = function()
        SetColorScheme()
    end
}
