vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'Sets up keybinds for when a file is attached to a LSP',
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(args)
        vim.bo[args.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
        local opts = { buffer = args.buf }

        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client:supports_method('textDocument/foldingRange') then
            local win = vim.api.nvim_get_current_win()
            vim.wo[win][0].foldexpr = 'v:lua.vim.lsp.foldexpr()'
        end


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
        nmap('n', '<leader>i', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ 0 }), { 0 })
        end, 'Toggle [I]nlay hints')
        nmap('n', 'sr', function()
            opts = {}
            opts.include_current_line = true
            require('telescope.builtin').lsp_references(opts)
        end, '[S]earch [R]eferences')
        nmap('v', 'sr', function()
            vim.cmd('normal! "hy')
            opts = {}
            opts.default_text = vim.fn.getreg('h')
            opts.include_current_line = true
            require('telescope.builtin').lsp_references(opts)
        end, '[S]earch [R]eferences')

        nmap('n', '<leader>ss', require('telescope.builtin').lsp_document_symbols, '[S]search [S]ymbols')
        nmap('v', '<leader>ss', function()
            vim.cmd('normal! "hy')
            opts = {}
            opts.default_text = vim.fn.getreg('h')
            require('telescope.builtin').lsp_document_symbols(opts)
        end, '[S]search [S]ymbols')

        nmap('n', '<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
        nmap('n', '<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
        nmap('n', 'Ö', vim.lsp.buf.hover, 'Hover Documentation')
        nmap('n', '<M-ö>', vim.lsp.buf.signature_help, 'Signature Documentation')
        nmap('n', 'gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
        nmap('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
        nmap('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
        nmap('n', '<leader>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, '[W]orkspace [L]ist Folders')
        nmap('n', '<leader>f', function()
            vim.lsp.buf.format { async = true }
        end, '[F]ormat file')
        nmap('n', 'gh', '<cmd>SwitchSourceHeader<cr>', '[G]oto [H]eader <-> source')
        nmap('n', 'sh', function()
            vim.cmd([[ShowHeirarchy]])
        end, '[S]how [H] <-> source')
        nmap('n', "<leader>lr", function()
            vim.cmd('LspRestart')
        end, '[L]sp [R]estart')
    end,
})

