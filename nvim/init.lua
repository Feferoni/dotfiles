vim.loader.enable()

local log_path = vim.lsp.get_log_path()
if vim.uv.fs_stat(log_path) then
    io.open(log_path, "w"):close()
end

require("feferoni.core")
require("feferoni.lazy")
