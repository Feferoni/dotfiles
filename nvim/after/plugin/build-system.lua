local build_system = require('build-system')

build_system.setup {
    setup_source_file_path = "utils/setup",
    -- remove_commands = { "command5", "command4" },
}

vim.keymap.set("n", "<leader>0", function()
    build_system.find_build_file()
end, { noremap = true })

vim.keymap.set("n", "<leader>9", function()
    local opts = {}
    opts.add_commands = {}
    opts.add_commands["command4"] = "compdb"
    opts.add_commands["ninja_build"] = "ninja"
    opts.add_commands["ninja_clean"] = "ninja comdb"

    build_system.interactive_build(opts)
end, { noremap = true })
