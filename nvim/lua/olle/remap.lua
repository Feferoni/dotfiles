vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- 
vim.keymap.set("n", "<F3>", ":set wrap!<cr>", { noremap = true, silent = true })

-- Move selected block, auto indent if moved to inside a if block
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Move line below to end of current line
vim.keymap.set("n", "J", "mzJ`z")

-- Move half page down/up while keeping cursor in the middle
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Let search terms stay in the middle of screen
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Good times on twitch, don't know what this is from, figure out later?
vim.keymap.set("n", "<leader>vwm", function()
    require("vim-with-me").StartVimWithMe()
end)
vim.keymap.set("n", "<leader>svwm", function()
    require("vim-with-me").StopVimWithMe()
end)

-- deletes the currently marked thing to the void register, then copies the new thing into that, will keep the old copy buffer after the delete
vim.keymap.set("x", "<leader>p", [["_dP]])

-- leader y to paste into the copy clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- ctrl + c to escape insert mode
vim.keymap.set("i", "<C-c>", "<Esc>")

-- this is some shit?
-- vim.keymap.set("n", "Q", "<nop>")

-- ctrl + f to do something with tmux, figure out what
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")


vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

-- quick fix navigation, look more into this
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- replace word your on
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
-- makes current file executable 
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- uses telescope to check references
vim.keymap.set('n', 'fr', function() require('telescope.builtin').lsp_references({ noremap = true, silent = true }) end)

vim.keymap.set("i", "<M-.>", "copilot#Next()", {expr=true, silent=true})
vim.keymap.set("i", "<M-,>", "copilot#Previous()", {expr=true, silent=true})
vim.keymap.set("i", "<M-->", "copilot#Dismiss()", {expr=true, silent=true})
vim.keymap.set("i", "<M-m>", "copilot#Suggest()", {expr=true, silent=true})

-- source object?
vim.keymap.set("n", "<leader><leader>", function()
    vim.cmd("so")
    vim.print("Resourced file")
end)

-- debugging
vim.keymap.set("n", "<leader>b", ":lua require'dap'.toggle_breakpoint()<CR>")
vim.keymap.set("n", "<leader>B", ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>")
vim.keymap.set("n", "<F5>", ":lua require'dap'.continue()<CR>")
vim.keymap.set("n", "<F10>", ":lua require'dap'.step_over()<CR>")
vim.keymap.set("n", "<F11>", ":lua require'dap'.step_into()<CR>")
vim.keymap.set("n", "<F12>", ":lua require'dap'.step_out()<CR>")
vim.keymap.set("n", "<leader>dr", ":lua require'dap'.repl.open()<CR>")
vim.keymap.set("n", "<leader>td", ":lua require'dap-go'.debug_test()<CR>")
