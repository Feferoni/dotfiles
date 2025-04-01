require("feferoni.core.remap")
require("feferoni.core.set")
require("feferoni.core.wsl_check")
require("feferoni.core.globals")
require("feferoni.core.autocmds")
require("feferoni.core.type_hierarchy")

vim.filetype.add({
    extension = {
        ifx = "cpp",
        sig = "cpp",
    },
})
