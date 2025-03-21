require("feferoni.core.remap")
require("feferoni.core.set")
require("feferoni.core.wsl_check")
require("feferoni.core.globals")
require("feferoni.core.autocmds")

vim.filetype.add({
    extension = {
        ifx = "cpp",
        sig = "cpp",
    },
})
