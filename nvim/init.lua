vim.loader.enable()

local tmux_pane = os.getenv('TMUX_PANE')
if tmux_pane then
    vim.o.shadafile = vim.fn.stdpath('state') .. 'shada/main-' .. tmux_pane:gsub('%%', '') .. '.shada'
end

local log_path = vim.lsp.get_log_path()
if vim.uv.fs_stat(log_path) then
    io.open(log_path, "w"):close()
end

require("feferoni.core")
require("feferoni.lazy")
