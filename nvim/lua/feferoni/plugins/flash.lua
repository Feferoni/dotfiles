return {
    "folke/flash.nvim",
    event = "VeryLazy",
    keys = {
        {
            "f",
            mode = { "x", "n", "o" },
            function()
                require("flash").jump()
            end,
            desc = "Flash jump"

        },
    },
    config = function()
        require("flash").setup({
            labels = "asdfhjklgqwertyuiopzxcvbnm",
            search = {
                multi_window = false,
                forward = true,
                wrap = true,
                mode = "exact",
                incremental = true,
                exclude = {
                    "notify",
                    "noice",
                    "cmp_menu",
                    function(win)
                        return not vim.api.nvim_win_get_config(win).focusable
                    end
                }
            },
            modes = {
                search = {
                    enabled = false,
                },
                char = {
                    enabled = false,
                    keys = { "f", "F", "t", "T", ",", ";" },
                    multi_line = true,
                },
            },
            highlight = {
                backdrop = true,
                matches = true,
                priority = 5000,
                groups = {
                    match = "FlashMatch",
                    current = "FlashCurrent",
                    backdrop = "CustomBackdrop",
                    label = "Error"
                }
            }
        })
    end
}
