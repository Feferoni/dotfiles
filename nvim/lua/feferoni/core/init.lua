require("feferoni.core.remap")
require("feferoni.core.set")
require("feferoni.core.wsl_check")
require("feferoni.core.globals")
require("feferoni.core.autocmds")
require("feferoni.core.type_hierarchy")
require("feferoni.core.switch_source_header")
require("feferoni.core.diagnostic")

vim.filetype.add({
    extension = {
        ifx = "cpp",
        sig = "cpp",
    },
})
