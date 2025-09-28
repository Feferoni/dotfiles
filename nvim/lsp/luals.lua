return {
    cmd = { 'lua-language-server' },
    filetypes = { 'lua' },
    root_markers = { '.luarc.json', '.luarc.jsonc', '.git/' },
    settings = {
        Lua = {
            signatureHelp = { enabled = true },
            runtime = {
                version = 'LuaJIT',
                pathStrict = true,
            },
            diagnostics = {
                globals = { 'vim' },
                disable = { 'redundant-parameter', 'duplicate-set-field', },
            },
            hint = vim.fn.has('nvim-0.10') > 0 and {
                -- https://github.com/LuaLS/lua-language-server/wiki/Settings#hint
                enable = true,         -- inlay hints
                paramType = true,      -- Show type hints at the parameter of the function.
                paramName = "Literal", -- Show hints of parameter name (literal types only) at the function call.
                arrayIndex = "Auto",   -- Show hints only when the table is greater than 3 items, or the table is a mixed table.
                setType = true,        -- Show a hint to display the type being applied at assignment operations.
            } or nil,
            completion = { callSnippet = "Disable" },
            workspace = {
                maxPreload = 8000,
                checkThirdParty = false,
                library = {
                    vim.env.VIMRUNTIME,
                }
            },
        },

    }
}
