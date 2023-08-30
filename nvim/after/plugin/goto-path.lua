local goto_path = require('goto-path')

goto_path.setup({
    replacement_table = {
        {
            "${REPLACE}", "repo/root/"
        },
    }
})

vim.keymap.set("n", "gf", goto_path.go)
