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

local on_attach_signature_help = function(client)
    if client.server_capabilities.signatureHelpProvider then
        require('lsp-overloads').setup(client, {
            ui = {
                border = "single",
                height = nil,
                width = nil,
                wrap = true,
                wrap_at = nil,
                max_width = nil,
                max_height = nil,
                close_events = { "CursorMoved", "BufHidden", "InsertLeave" },
                focusable = true,
                focus = false,
                offset_x = 0,
                offset_y = 0,
                floating_window_above_cur_line = false,
                silent = true,
            },
            keymaps = {
                next_signature = "<C-j>",
                previous_signature = "<C-k>",
                next_parameter = "<C-l>",
                previous_parameter = "<C-h>",
                close_signature = "<C-s>"
            },
            display_automatically = false,
        })
    end
end

local setup_lsp = function(server_name, opts)
    opts = opts or {}
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
    opts.capabilities = capabilities or {}
    opts.on_attach = function(client, _)
        if client.supports_method('textDocument/hover') then
            vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'rounded' })
        end
        if client.supports_method('textDocument/signature_help') then
            vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'rounded' })
        end
        on_attach_signature_help(client)
    end
    local server = require("lspconfig")[server_name]
    server.setup(opts)
end

local setup_clangd = function(server_name)
    server_name = server_name or "clangd"
    local opts = {
        cmd = {
            "clangd",
            "-j=10",
            "--background-index",
            "--all-scopes-completion",
            "--header-insertion=never",
            "--recovery-ast",
            "--pch-storage=disk",
            "--log=info",
            "--clang-tidy",
            "--enable-config",
        },
    }
    setup_lsp(server_name, opts)
end

return {
    'neovim/nvim-lspconfig',
    event = "VeryLazy",
    dependencies = {
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
        'neovim/nvim-lspconfig',
        'jose-elias-alvarez/null-ls.nvim',
        'p00f/clangd_extensions.nvim',
        'Issafalcon/lsp-overloads.nvim',
        "j-hui/fidget.nvim",
    },
    build = function()
        pcall(vim.cmd, 'MasonInstall')
    end,
    config = function()
        require("mason").setup()
        require("mason-lspconfig").setup()
        require('fidget').setup({
            integration = {
                ["nvim-tree"] = {
                    enable = true,
                },
            },
        })
        require("null-ls").setup({
            sources = {
                require("null-ls").builtins.formatting.yapf,
            },
        })
        require("clangd_extensions").setup({
            inlay_hints = {
                inline = vim.fn.has("nvim-0.10") == 1,
                only_current_line = true,
                only_current_line_autocmd = { "CursorHold", "CursorMoved", "CursorMovedI" },
                show_parameter_hints = true,
                parameter_hints_prefix = "<- ",
                other_hints_prefix = "=> ",
                max_len_align = false,
                max_len_align_padding = 1,
                right_align = false,
                right_align_padding = 7,
                highlight = "Comment",
                priority = 100,
            },
            ast = {
                role_icons = {
                    type = "🄣",
                    declaration = "🄓",
                    expression = "🄔",
                    statement = ";",
                    specifier = "🄢",
                    ["template argument"] = "🆃",
                },
                kind_icons = {
                    Compound = "🄲",
                    Recovery = "🅁",
                    TranslationUnit = "🅄",
                    PackExpansion = "🄿",
                    TemplateTypeParm = "🅃",
                    TemplateTemplateParm = "🅃",
                    TemplateParamObject = "🅃",
                },
                highlights = {
                    detail = "Comment",
                },
            },
            memory_usage = {
                border = "none",
            },
            symbol_info = {
                border = "none",
            },
        })
        require("mason-lspconfig").setup({
            ensure_installed = {
                "bashls",
                "lua_ls",
                "clangd",
                "jedi_language_server",
            },
            handlers = {
                function(server_name)
                    local opts = {}
                    setup_lsp(server_name, opts)
                end,
                ["cmake"] = function(server_name)
                    local opts = {
                        cmd = {
                            "cmake-language-server"
                        }
                    }
                    setup_lsp(server_name, opts)
                end,
                ["bashls"] = function(server_name)
                    local opts = {
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
                    }
                    setup_lsp(server_name, opts)
                end,
                ["lua_ls"] = function(server_name)
                    local opts = {
                        cmd = {
                            "lua-language-server",
                            "--stdio"
                        },
                        autostart = true,
                        settings = {
                            Lua = {
                                diagnostics = {
                                    globals = { 'vim' }
                                }
                            }
                        }
                    }
                    setup_lsp(server_name, opts)
                end,
                ["jsonls"] = function(server_name)
                    local opts = {
                        cmd = { "vscode-json-language-server", "--stdio" },
                        root_dir = require("lspconfig").util.find_git_ancestor,
                        provideFormatter = true,
                        files = { "json", "jsonc" },
                        single_file_support = true,
                    }
                    setup_lsp(server_name, opts)
                end,
                ["clangd"] = function(server_name)
                    setup_clangd(server_name)
                end,
                ["jedi_language_server"] = function(server_name)
                    local opts = {
                        cmd = { "jedi-language-server" },
                        filetypes = { "python" },
                        single_file_support = true,
                    }
                    setup_lsp(server_name, opts)
                end,
            },

        })
        setup_clangd()
    end
}
