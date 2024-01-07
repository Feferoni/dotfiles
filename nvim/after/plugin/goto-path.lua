local goto_path = require('goto-path')
local telescope_prettier = require('feferoni.telescope_prettier')

goto_path.setup({
    replacement_table = {
        {
            "${REPLACE}", "repo/root/"
        },
    }
})

vim.keymap.set("n", "gf", function()
    local opts = {}
    opts.no_ignore = true
    opts.follow = true
    opts.telescope_prettier = telescope_prettier.project_files
    goto_path.go(opts)
end)
