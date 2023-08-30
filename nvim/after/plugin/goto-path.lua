local goto_path = require('goto-path')

goto_path.setup({
    replacement_table = {
        {
            "${REPLACE}", "repo/root/"
        },
    }
})

vim.keymap.set("n", "gf", function()
    -- autocmd User TelescopePreviewerLoaded setlocal wrap
    local opts = {}
    goto_path.go(opts)
end)
