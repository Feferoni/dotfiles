local function find_binaries_and_debug()
    local handle, err = io.popen("fd -u -t x -p bin")
    if not handle then
        vim.notify("Failed to execute fd: " .. (err or "unknown error"), vim.log.levels.ERROR)
        return
    end
    local result = handle:read("*a")
    handle:close()

    local paths = {}
    for path in result:gmatch("[^\r\n]+") do
        table.insert(paths, path)
    end

    vim.ui.select(paths, {
        prompt = "Select binary to debug:",
        format_item = function(item)
            return vim.fn.fnamemodify(item, ":t") .. " (" .. item .. ")"
        end,
    }, function(choice)
        if choice then
            -- TODO: Need it to select workspace, cmake builds needs to have it in build/ for it to be correct.
            -- While zig needs it to be just in root.
            require('dap').run({
                type = 'codelldb',
                request = 'launch',
                name = "Debug selected binary",
                program = choice,
            })
        end
    end)
end

---@diagnostic disable-next-line: missing-fields
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "c", "cpp", "cc", "zig" },
    callback = function()
        vim.schedule(function()
            ---@diagnostic disable-next-line: missing-fields
            vim.api.nvim_create_user_command('DebugBinary', find_binaries_and_debug, {})
            vim.keymap.set("n", "<F5>", function()
                vim.cmd("DebugBinary");
                if vim.fn['NvimTreeClose'] ~= nil then
                    vim.cmd('NvimTreeClose')
                end
            end)
            vim.keymap.set("n", "<F1>", ":lua require'dap'.step_into()<CR>")
            vim.keymap.set("n", "<F2>", ":lua require'dap'.step_over()<CR>")
            vim.keymap.set("n", "<F3>", ":lua require'dap'.step_out()<CR>")
            vim.keymap.set("n", "<F4>", ":lua require'dap'.continue()<CR>")
            vim.keymap.set("n", "<leader>dr", ":lua require'dap'.repl.open()<CR>")
            vim.keymap.set("n", "<leader>td", ":lua require'dap-go'.debug_test()<CR>")
        end)
    end,
})

return {
    "jay-babu/mason-nvim-dap.nvim",
    event = "VeryLazy",
    dependencies = {
        'mfussenegger/nvim-dap',
        'rcarriga/nvim-dap-ui',
        'nvim-neotest/nvim-nio',
        'theHamsta/nvim-dap-virtual-text',
        'nvim-telescope/telescope-dap.nvim',
        'leoluz/nvim-dap-go',
    },
    config = function()
        require("mason-nvim-dap").setup({
            ensure_installed = { "python", "codelldb" },
            handlers = {
                function(config)
                    require('mason-nvim-dap').default_setup(config)
                end,
                python = function(config)
                    config.adapters = {
                        type = "executable",
                        command = "/usr/bin/python3",
                        args = {
                            "-m",
                            "debugpy.adapter",
                        },
                    }
                    config.configurations = {
                        {
                            name = "Debug python script",
                            type = "python",
                            request = "launch",
                            program = "${file}",
                            args = function()
                                local input_args = vim.fn.input('Script arguments: ')
                                return vim.split(input_args, " ")
                            end
                        }
                    }
                    require('mason-nvim-dap').default_setup(config) -- don't forget this!
                end,
                codelldb = function(config)
                    config.adapters = {
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
                    config.configurations = {
                        {
                            name = 'C/CPP debugging with lldb',
                            type = 'codelldb',
                            request = 'launch',
                            program = function()
                                return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
                            end,
                            cwd = '${workspaceFolder}/',
                            terminal = 'integrated',
                            stopOnEntry = false,
                            args = {},
                            sourceMap = {
                                ["/home/feferoni/git/AOC_2023_CPP/build/src/"] =
                                "/home/feferoni/git/AOC_2023_CPP/dep_cache/catch2-src/src/",
                            }
                        }

                    }
                    require('mason-nvim-dap').default_setup(config)
                end,
            },
        })

        require("nvim-dap-virtual-text").setup()
        require("dap-go").setup()
        require("dapui").setup({
            controls = {
                element = "repl",
                enabled = true,
                icons = {
                    disconnect = "",
                    pause = "",
                    play = "",
                    run_last = "",
                    step_back = "",
                    step_into = "",
                    step_out = "",
                    step_over = "",
                    terminate = ""
                }
            },
            element_mappings = {},
            expand_lines = true,
            floating = {
                border = "single",
                mappings = {
                    close = { "q", "<Esc>" }
                }
            },
            force_buffers = true,
            icons = {
                collapsed = "",
                current_frame = "",
                expanded = ""
            },
            layouts = { {
                elements = { {
                    id = "scopes",
                    size = 0.25
                }, {
                    id = "breakpoints",
                    size = 0.25
                }, {
                    id = "stacks",
                    size = 0.25
                }, {
                    id = "watches",
                    size = 0.25
                } },
                position = "right",
                size = 100
            }, {
                elements = { {
                    id = "repl",
                    size = 0.5
                }, {
                    id = "console",
                    size = 0.5
                } },
                position = "bottom",
                size = 10
            } },
            mappings = {
                edit = "e",
                expand = { "<CR>", "<2-LeftMouse>" },
                open = "o",
                remove = "d",
                repl = "r",
                toggle = "t"
            },
            render = {
                indent = 1,
                max_value_lines = 100
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

        dap.set_log_level('DEBUG')

        vim.keymap.set("n", "<F5>", function()
            vim.cmd([[lua require'dap'.continue()]])
            if vim.fn['NvimTreeClose'] ~= nil then
                vim.cmd('NvimTreeClose')
            end
        end)
        vim.keymap.set("n", "<leader>b", ":lua require'dap'.toggle_breakpoint()<CR>")
        vim.keymap.set("n", "<leader>B",
            ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>")
        vim.keymap.set("n", "<F1>", ":lua require'dap'.step_into()<CR>")
        vim.keymap.set("n", "<F2>", ":lua require'dap'.step_over()<CR>")
        vim.keymap.set("n", "<F3>", ":lua require'dap'.step_out()<CR>")
        vim.keymap.set("n", "<F4>", ":lua require'dap'.continue()<CR>")
        vim.keymap.set("n", "<leader>dr", ":lua require'dap'.repl.open()<CR>")
        vim.keymap.set("n", "<leader>td", ":lua require'dap-go'.debug_test()<CR>")
    end
}
