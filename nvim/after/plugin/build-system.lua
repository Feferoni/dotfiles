local build_system = require('build-system')
local bs_build = require('build-system.build')
local bs_file = require('build-system.file')

build_system.setup {
}

vim.keymap.set("n", "<leader>0", function()
    bs_file.find_build_file()
end, { noremap = true })

vim.keymap.set("n", "<leader>9", function()
    bs_build.interactive_make_build()
end, { noremap = true })
