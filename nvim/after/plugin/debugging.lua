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

dap.adapters.lldb = {
    type = 'server',
    host = '127.0.0.1',
    port = "${port}",
    executable = {
        command = 'codelldb',
        args = { '--port', '${port}' }
    },
    options = {
        max_retries = 20
    }
}

dap.configurations.cpp = {
    {
        name = 'Launch file',
        type = 'lldb',
        request = 'launch',
        program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = '${workspaceFolder}/build',
        terminal = 'integrated',
        stopOnEntry = false,
        args = {},
    }
}

dap.configurations.c = dap.configurations.cpp

dap.set_log_level('DEBUG')

vim.keymap.set("n", "<leader>b", ":lua require'dap'.toggle_breakpoint()<CR>")
vim.keymap.set("n", "<leader>B", ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>")
vim.keymap.set("n", "<F5>", ":lua require'dap'.continue()<CR>")
vim.keymap.set("n", "<F1>", ":lua require'dap'.step_over()<CR>")
vim.keymap.set("n", "<F2>", ":lua require'dap'.step_into()<CR>")
vim.keymap.set("n", "<F3>", ":lua require'dap'.step_out()<CR>")
vim.keymap.set("n", "<leader>dr", ":lua require'dap'.repl.open()<CR>")
vim.keymap.set("n", "<leader>td", ":lua require'dap-go'.debug_test()<CR>")
