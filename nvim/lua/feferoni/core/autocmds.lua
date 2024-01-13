vim.api.nvim_create_autocmd("FileType", {
    pattern = "lua",
    callback = function()
        vim.schedule(function()
            vim.cmd("setlocal tabstop=4 shiftwidth=4 expandtab")
        end)
    end,
})

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    pattern = { "*" },
    callback = function()
        local save_cursor = vim.fn.getpos(".")
        vim.cmd([[%s/\s\+$//e]])
        vim.fn.setpos(".", save_cursor)
    end,
})

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
        local opts = { buffer = ev.buf }

        local nmap = function(mode, keys, func, desc)
            if desc then
                desc = 'LSP: ' .. desc
                opts.desc = desc
            end

            vim.keymap.set(mode, keys, func, opts)
        end

        nmap('n', 'rn', function()
            vim.lsp.buf.rename()
            vim.cmd("wa")
        end, '[R]e[n]ame')
        nmap('n', 'ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
        nmap('n', 'gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
        nmap('n', 'gi', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
        nmap('n', '<leader>gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
        nmap('n', '<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
        nmap('n', '<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
        nmap('n', '<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
        nmap('n', 'K', vim.lsp.buf.hover, 'Hover Documentation')
        nmap('n', '<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')
        nmap('n', 'gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
        nmap('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
        nmap('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
        nmap('n', '<leader>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, '[W]orkspace [L]ist Folders')
        nmap('n', '<leader>f', function()
            vim.lsp.buf.format { async = true }
        end, '[F]ormat file')
        require("clangd_extensions.inlay_hints").setup_autocmd()
        require("clangd_extensions.inlay_hints").set_inlay_hints()
        nmap('n', '<leader>ti', require("clangd_extensions.inlay_hints").toggle_inlay_hints, '[T]oggle [I]nlay Hints')
        nmap('n', 'gh', '<cmd>ClangdSwitchSourceHeader<cr>', '[G]oto [H]eader <-> source')
        nmap('i', "<C-s>", function()
            vim.cmd('LspOverloadsSignature')
        end, "LspoverloadsSignature")
        nmap('n', "<C-s>", function()
            vim.cmd('LspOverloadsSignature')
        end, "LspoverloadsSignature")
    end,
})

local SetColor = function()
    -- vim.api.nvim_set_hl(0, "FloatBorder", { fg = "none", bg = "none" })
    -- vim.api.nvim_set_hl(0, "NormalFloat", { fg = "none", bg = "none" })
end

local myGroup = vim.api.nvim_create_augroup("SetColor", { clear = true })

vim.api.nvim_create_autocmd("VimEnter", {
    group = myGroup,
    callback = SetColor
})
