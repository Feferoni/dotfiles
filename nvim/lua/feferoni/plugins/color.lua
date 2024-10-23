local function SetColorScheme()
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { fg = "none", bg = "none" })

    -- Custom highlighting for Copilot
    vim.api.nvim_set_hl(0, "CopilotSuggestion", { fg = "#83a598" })
    vim.api.nvim_set_hl(0, "CopilotAnnotation", { fg = "#83a598" })

    vim.api.nvim_set_hl(0, 'TelescopeResultsDiffAdd', { fg = '#98C379' })   -- green for staged
    vim.api.nvim_set_hl(0, 'TelescopeResultsDiffChange', { fg = '#E06C75' }) -- red for unstaged
    vim.api.nvim_set_hl(0, 'TelescopeResultsDiffDelete', { fg = '#E06C75' }) -- red for deleted
    vim.api.nvim_set_hl(0, 'TelescopeResultsDiffUntracked', { fg = '#E06C75' }) -- red for untracked

    -- This is for flash plugin color scheme
    vim.api.nvim_set_hl(0, "CustomBackdrop", { fg = "none" })

    local set_theme_path = "$HOME/.config/tinted-theming/set_theme.lua"
    local is_set_theme_file_readable = vim.fn.filereadable(vim.fn.expand(set_theme_path)) == 1 and true or false

    if is_set_theme_file_readable then
        vim.cmd("let base16colorspace=256")
        vim.cmd("source " .. set_theme_path)
    end
end

return {
    'tinted-theming/base16-vim',
    priority = 1000,
    config = function()
        SetColorScheme()
    end
}
