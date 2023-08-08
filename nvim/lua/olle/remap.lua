vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("n", "<F6>", ":set wrap!<cr>", { noremap = true, silent = true })

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

-- leader y to paste into the copy clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- does nothing 
vim.keymap.set("n", "Q", "<nop>")

-- ctrl + f to do something with tmux, figure out what
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

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
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
-- makes current file executable 
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- uses telescope to check references
vim.keymap.set('n', '<leader>gr', function() require('telescope.builtin').lsp_references({ noremap = true, silent = true }) end)

vim.keymap.set("i", "<M-.>", "copilot#Next()", {expr=true, silent=true})
vim.keymap.set("i", "<M-,>", "copilot#Previous()", {expr=true, silent=true})
vim.keymap.set("i", "<M-->", "copilot#Dismiss()", {expr=true, silent=true})
vim.keymap.set("i", "<M-m>", "copilot#Suggest()", {expr=true, silent=true})

-- source object
vim.keymap.set("n", "<leader><leader>", function()
    vim.cmd("so")
    vim.print("Resourced file")
end)

