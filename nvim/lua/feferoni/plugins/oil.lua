return {
    'stevearc/oil.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons', },
    config = function()
        require('oil').setup({
            default_file_explorer = false,
            columns = { "icon" },
            keymaps = {
                ["<C-h>"] = false,
                ["<C-l>"] = false,
                ["<M-h>"] = "actions.select_split"
            },
            view_options = {
                show_hidden = true,
            },
        })
        vim.keymap.set("n", "<leader>_", function() vim.cmd("Oil") end, { desc = "Open parent directory" })
        vim.keymap.set("n", "<leader>-", require("oil").toggle_float)
    end
}
