return {
    "stevearc/conform.nvim",
    event = "VeryLazy",
    config = function()
        require("conform").setup({
            formatters = {
                yapf = {
                    args = {
                        "--style={based_on_style: pep8, column_limit: 100 indent_width: 4 spaces_before_comment: 2}"
                    },
                },
                shfmt = {
                    args = {
                        "-i", "4", -- Use 4 spaces for indentation
                        "-ci",     -- Switch cases will be indented
                        "-bn",     -- Binary ops like && and | may start a line
                        "-sr",     -- Redirect operators will be followed by a space
                    },
                },
            },
            formatters_by_ft = {
                python = { 'yapf' },
                sh = { 'shfmt' },
                bash = { 'shfmt' },
                zsh = { 'shfmt' },
            },
            format_on_save = {
                timeout_ms = 500,
                lsp_fallback = true,
            },
        })

        vim.keymap.set({ 'n', 'v' }, '<leader>f', function()
            require('conform').format({
                async = true,
                lsp_fallback = true,
            })
        end, { desc = 'Format file or range (in visual mode)' })
    end
}
