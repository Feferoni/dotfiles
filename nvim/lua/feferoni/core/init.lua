require("feferoni.core.remap")
require("feferoni.core.set")
require("feferoni.core.globals")

require("feferoni.core.autocmds.init")
require("feferoni.core.user_commands.init")
require("feferoni.core.user_functions.init")

require("feferoni.core.lsp")

vim.filetype.add({
    extension = {
        ifx = "cpp",
        sig = "cpp",
    },
})
