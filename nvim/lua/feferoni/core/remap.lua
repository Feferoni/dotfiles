vim.g.mapleader = " "
-- vim.keymap.set("n", "<leader>pv", vim.cmd.Ex) -- use file tree instead

-- selection will extend up to but not including, the cursor position
-- vim.o.selection = "exclusive"
-- vim.o.virtualedit = "onemore"

-- Toggle wrap lines
vim.keymap.set("n", "<F6>", ":set wrap!<cr>", { noremap = true, silent = true })
vim.keymap.set('n', '<esc>', "<cmd>nohl<CR>", { noremap = true, silent = true })

-- Move selected block, auto indent if moved to inside a if block
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Move line below to end of current line
vim.keymap.set("n", "J", "mzJ`z")

-- Let search terms stay in the middle of screen
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- deletes the currently marked thing to the void register, then copies the new thing into that, will keep the old copy buffer after the delete
vim.keymap.set("x", "<leader>p", [["_dP]])

-- deletes the currently marked thing, and puts it into void register. Keeping the old copy buffer after the delete
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- does nothing
vim.keymap.set("n", "Q", "<nop>")

-- Diagnostic keymaps
vim.keymap.set('n', 'gp', vim.diagnostic.goto_prev)
vim.keymap.set('n', 'gn', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)
-- Lsp keymaps
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

-- quick fix navigation, look more into this
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")

-- Move half page down/up while keeping cursor in the middle
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
-- ctrl + c to escape insert mode
vim.keymap.set("i", "<C-c>", "<Esc>")

-- replace word your on
-- replace word your on
vim.keymap.set("n", "<leader>sr", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
    { desc = '[S]earch and [R]eplace current word without confirmation' })
vim.keymap.set("n", "<leader>SR", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gc<Left><Left><Left>]],
    { desc = '[S]earch and [R]eplace current word with confirmation' })
vim.keymap.set("v", "<leader>sr", [["hy:%s/<C-r>h/<C-r>h/gI<left><left><left>]],
    { desc = '[S]earch and [R]eplace current selection without confirmation' })
vim.keymap.set("v", "<leader>SR", [["hy:%s/<C-r>h/<C-r>h/gc<left><left><left>]],
    { desc = '[S]earch and [R]eplace current selection with confirmation' })

-- makes current file executable
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true, desc = 'turn file into executable' })

-- uses telescope to check references
vim.keymap.set('n', '<leader>gr',
    function() require('telescope.builtin').lsp_references({ noremap = true, silent = true }) end)

vim.keymap.set("i", "<M-.>", "copilot#Next()", { expr = true, silent = true, desc = 'Copilot next' })
vim.keymap.set("i", "<M-,>", "copilot#Previous()", { expr = true, silent = true, desc = 'Copilot prev' })
vim.keymap.set("i", "<M-->", "copilot#Dismiss()", { expr = true, silent = true, desc = 'Copilot dismiss' })
vim.keymap.set("i", "<M-m>", "copilot#Suggest()", { expr = true, silent = true, desc = 'Copilot suggest' })

vim.keymap.set("n", "<leader><leader>", function()
    vim.cmd("so")
    vim.print("Resourced file")
end)

local copy_text_to_clipboard = function(text)
    local command = 'printf "' .. text .. '" | xclip -selection clipboard'
    vim.fn.system(command)
end

if require("feferoni.core.wsl_check").is_wsl() then
    vim.keymap.set({ "n", "v" }, "<leader>y", ":w !clip.exe<CR><CR>")
else
    vim.keymap.set({ "n" }, "<leader>y", [["+y]])
    vim.keymap.set({ "n", "v" }, "<leader>Y", [["+Y]])
    vim.keymap.set({ "n", "v" }, "yy", [["+yy"]], {})
end

vim.keymap.set("n", "<leader>Y", [["+Y]])


vim.keymap.set("n", "<leader>cfp", function()
    local path = require('plenary.path')
    local current_file = path:new(vim.fn.expand('%:p'))
    local current_folder = tostring(current_file:parent())
    copy_text_to_clipboard(current_folder .. "/")
end, { desc = '[C]opy [F]ile [P]ath' })
