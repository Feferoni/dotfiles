return {
    'Feferoni/goto-path.nvim',
    dependencies = {
        'nvim-telescope/telescope.nvim',
    },
    config = function()
        local goto_path = require('goto-path')
        goto_path.setup()

        vim.keymap.set('n', 'gf', function ()
            local opts = {}
            opts.no_ignore = true
            opts.follow = true
            goto_path.goto_file(opts)
        end, { silent = true, remap = true, desc = '[G]oto [F]ile' })
    end
}
