---@diagnostic disable-next-line: missing-fields
vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'Sets up keybinds for when a file is attached to a LSP',
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
        nmap('n', 'gh', '<cmd>ClangdSwitchSourceHeader<cr>', '[G]oto [H]eader <-> source')
        nmap('n', "<leader>lr", function()
            vim.cmd('LspRestart')
        end, '[L]sp [R]estart')
    end,
})

local setup_lsp = function(server_name, opts)
    opts = opts or {}

    local capabilities = require('blink.cmp').get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities())

    capabilities.textDocument.completion.completionItem.snippetSupport = true
    opts.capabilities = capabilities or {}

    -- opts.on_attach = function(client, _)
    -- end

    local server = require("lspconfig")[server_name]
    server.setup(opts)
end

return {
    'neovim/nvim-lspconfig',
    event = "VeryLazy",
    dependencies = {
        'williamboman/mason.nvim',
        'neovim/nvim-lspconfig',
        "j-hui/fidget.nvim",
    },
    build = function()
        pcall(vim.cmd, 'MasonInstall')
    end,
    config = function()
        require("mason").setup()
        require('fidget').setup({
            integration = {
                ["nvim-tree"] = {
                    enable = true,
                },
            },
        })

        setup_lsp("cmake", {
            cmd = {
                "cmake-language-server"
            }
        })
        setup_lsp("bashls", {
            cmd = {
                "bash-language-server",
                "start"
            },
            filetypes = {
                "sh",
                "zsh",
                "conf"
            },
            single_file_support = true,
        })
        setup_lsp("lua_ls", {
            settings = {
                Lua = {
                    runtime = {
                        version = 'LuaJIT',
                        pathStrict = true,
                    },
                    diagnostics = {
                        disable = { 'redundant-parameter', 'duplicate-set-field', },
                    },
                    hint = vim.fn.has('nvim-0.10') > 0 and {
                        -- https://github.com/LuaLS/lua-language-server/wiki/Settings#hint
                        enable = true,         -- inlay hints
                        paramType = true,      -- Show type hints at the parameter of the function.
                        paramName = "Literal", -- Show hints of parameter name (literal types only) at the function call.
                        arrayIndex = "Auto",   -- Show hints only when the table is greater than 3 items, or the table is a mixed table.
                        setType = true,        -- Show a hint to display the type being applied at assignment operations.
                    } or nil,
                    completion = { callSnippet = "Disable" },
                    workspace = {
                        maxPreload = 8000,
                        checkThirdParty = false,
                        library = {
                            vim.env.VIMRUNTIME,
                        }
                    },
                },

            }
        })
        setup_lsp("jsonls", {
            cmd = { "vscode-json-language-server", "--stdio" },
            root_dir = require("lspconfig").util.find_git_ancestor,
            provideFormatter = true,
            files = { "json", "jsonc" },
            single_file_support = true,
        })
        setup_lsp("pyright", {
            root_dir = require("lspconfig").util.find_git_ancestor,
            filetypes = { "python" },
            single_file_support = true,
            version = {},
            settings = {
                python = {
                    analysis = {
                        autoSearchPaths = true,
                        useLibraryCodeForTypes = true,
                        diagnosticMode = 'openFilesOnly',
                    },
                },
            },
        })
        setup_lsp("clangd", {
            cmd = {
                "clangd",
                "-j=10",
                "--background-index",
                "--all-scopes-completion",
                "--header-insertion=never",
                "--cross-file-rename",
                "--recovery-ast",
                "--pch-storage=disk",
                "--log=info",
                "--clang-tidy",
                "--enable-config",
            },
        })
        setup_lsp("gopls", {
            filetypes = { "go", "gomod", "gowork", "gotmpl" }
        })
        setup_lsp("marksman", {})
        setup_lsp("html", {})
        setup_lsp("zls", {})
        setup_lsp("rust_analyzer", {})
        vim.lsp.set_log_level("off")
    end
}
