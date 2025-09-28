local isLogging = false
local HOME = os.getenv("HOME")
local logFile = HOME .. "/.local/share/nvim/verbose.log"

local function toggleVerboseLogging()
    if isLogging then
        vim.cmd('set verbose=0')
        vim.cmd('set verbosefile=')
        isLogging = false
        print("Verbose logging stopped.")
    else
        local f = io.open(logFile, "r")
        if f ~= nil then
            io.close(f)
            os.remove(logFile)
        end
        vim.cmd('set verbosefile=' .. logFile)
        vim.cmd('set verbose=20')
        isLogging = true
        print("Verbose logging started, outputting to " .. logFile)
    end
end

---@diagnostic disable-next-line: missing-fields
vim.api.nvim_create_user_command('ToggleVerboseLog', toggleVerboseLogging, {})
