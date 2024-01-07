local mason = require("mason")
mason.setup()

require('fidget').setup({
    integration = {
        ["nvim-tree"] = {
            enable = true,
        },
    },
})

local null_ls = require("null-ls")
null_ls.setup({
    sources = {
        -- null_ls.builtins.formatting.black,
        null_ls.builtins.formatting.yapf,
        -- null_ls.builtins.formatting.autopep8,
        -- null_ls.builtins.formatting.isort,
    },
})

local kind_icons = {
    Text = "",
    Method = "m",
    Function = "󰊕",
    Constructor = "",
    Field = "",
    Variable = "",
    Class = "",
   Interface = "",
    Module = "",
    Property = " ",
    Unit = "",
    Value = "󰎠",
    Enum = "",
    Keyword = "󰌋",
    Snippet = "",
    Color = "󰏘",
    File = "󰈙",
    Reference = "",
    Folder = "󰉋",
    EnumMember = "",
    Constant = "󰏿",
    Struct = "",
    Event = "",
    Operator = "󰆕",
    TypeParameter = " ",
}

local ls = require('luasnip')
local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }
cmp.setup({
    sorting = {
        comparators = {
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.recently_used,
            require("clangd_extensions.cmp_scores"),
            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
        },
    },
    snippet = {
        expand = function(args)
            ls.lsp_expand(args.body)
        end,
    },
    formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(entry, item)
            item.menu = ({
                buffer = "[Buffer]",
                nvim_lsp = "[LSP]",
                luasnip = "[Snippet]",
            })[entry.source.name] or 0
            item.dup = ({
                vsnip = 0,
                nvim_lsp = 0,
                nvim_lua = 0,
                buffer = 0,
            })[entry.source.name] or 0
            item.kind = string.format("%s", kind_icons[item.kind])
            return item
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<A-k>'] = cmp.mapping.select_prev_item(cmp_select),
        ['<A-j>'] = cmp.mapping.select_next_item(cmp_select),
        ['<A-a>'] = cmp.mapping.confirm({ select = true }),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ["<A-s>"] = cmp.mapping.complete(),
        ['<Tab>'] = nil,
        ['<S-Tab>'] = nil,
    }),
    sources = cmp.config.sources({
        {
            name = 'nvim_lsp',
        },
        { name = 'luasnip' },
        { name = "path" },
    }, {
        { name = 'buffer' },
    }),
    duplicates = {
        nvim_lsp = 1,
        luasnip = 1,
        buffer = 1,
        path = 1,
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    experimental = {
        ghost_text = false,
        native_menu = false,
    },
})
require("luasnip.loaders.from_vscode").lazy_load()


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

local setup_lsp = function (server_name, opts)
    opts = opts or {}
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
    opts.capabilities = capabilities or {}
    opts.on_attach = function (client, _)
        on_attach_signature_help(client)
    end

    local server = require("lspconfig")[server_name]
    server.setup(opts)
end

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
                },
                settings = {
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
        ["clangd"] = function(server_name)
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
        nmap('i', "<C-s>", function ()
            vim.cmd('LspOverloadsSignature')
        end, "LspoverloadsSignature")
        nmap('n', "<C-s>", function ()
            vim.cmd('LspOverloadsSignature')
        end, "LspoverloadsSignature")
    end,
})

vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'rounded' })
vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'rounded' })

vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = false,
    float = {
        focusable = false,
        style = "minimal",
        boarder = "rounded",
        source = "always",
        header = "",
        prefix = "",
    },
})
