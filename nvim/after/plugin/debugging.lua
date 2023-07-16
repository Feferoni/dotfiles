require("nvim-dap-virtual-text").setup()
require("dap-go").setup()
require("dapui").setup({
    icons = { expanded = "▾", collapsed = "▸", circular = "↺" },
    mappings = {
        -- Use a table to apply multiple mappings
        -- expand = { "<CR>", "<2-LeftMouse>" },
        -- open = "o",
        -- remove = "d",
        -- edit = "e",
        -- repl = "r",
    },
    sidebar = {
        open_on_start = true,
        elements = {
            -- You can change the order of elements in the sidebar
            "scopes",
            "breakpoints",
            "stacks",
            "watches",
        },
        width = 40,
        position = "left", -- Can be "left" or "right"
    },
    tray = {
        open_on_start = true,
        elements = { "repl" },
        height = 10,
        position = "bottom", -- Can be "bottom" or "top"
    },
})

local dap, dapui = require("dap"), require("dapui")
dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
end


-- require("dap-go").setup()
-- require("dapui").setup()
