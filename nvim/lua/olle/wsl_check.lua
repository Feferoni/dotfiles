local M = {}

M.is_wsl = function()
    local handle = io.popen('grep -ic Microsoft /proc/version')
    if handle == nil then
        return false
    end

    local result = handle:read("*a")
    handle:close()
    return result:match("1") ~= nil
end

return M
