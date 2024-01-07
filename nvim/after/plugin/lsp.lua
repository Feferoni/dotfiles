local mason = require("mason")
mason.setup()

require('fidget').setup({})

local null_ls = require("null-ls")
null_ls.setup({
    sources = {
        -- null_ls.builtins.formatting.black,
        null_ls.builtins.formatting.yapf,
        -- null_ls.builtins.formatting.autopep8,
        -- null_ls.builtins.formatting.isort,
    },
})

local lsp = require('lsp-zero')
lsp.preset({})

lsp.set_preferences({
    suggest_lsp_servers = false,
    sign_icons = {
        error = 'E',
        warn = 'W',
        hint = 'H',
        info = 'I'
    }
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
                -- nvim_lsp_signature_help = "[LSP_SIG]",
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
            -- entry_filter = function(entry, _)
            --     return require('cmp.types').lsp.CompletionItemKind[entry:get_kind()] ~= 'Text'
            -- end
        },
        { name = 'luasnip' },
        -- { name = 'nvim_lsp_signature_help' },
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

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

local lsp_config = require('lspconfig')
lsp_config.cmake.setup({
    capabilities = capabilities,
    cmd = {
        "cmake-language-server"
    }
})

lsp_config.bashls.setup({
    capabilities = capabilities,
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
})

lsp_config.jedi_language_server.setup({
    capabilities = capabilities,
    cmd = { "jedi-language-server" },
    filetypes = { "python" },
    single_file_support = true,
})

lsp_config.lua_ls.setup({
    capabilities = capabilities,
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
})

lsp_config.clangd.setup({
    capabilities = capabilities,
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
})


lsp.on_attach(function(client, bufnr)
    if client.server_capabilities.signatureHelpProvider then
        vim.keymap.set("n", "<C-s>", function()
            vim.cmd('LspOverloadsSignature')
        end, { noremap = true, silent = true })
        vim.keymap.set("i", "<C-s>", function()
            vim.cmd('LspOverloadsSignature')
        end, { noremap = true, silent = true })
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
    local nmap = function(keys, func, desc)
        if desc then
            desc = 'LSP: ' .. desc
        end

        vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
    end

    nmap('rn', function()
        vim.lsp.buf.rename()
        vim.cmd("wa")
    end, '[R]e[n]ame')
    nmap('ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
    nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
    nmap('gi', vim.lsp.buf.implementation, '[G]oto [I]mplementation')

    nmap('<leader>gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
    nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
    nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
    nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
    nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
    nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

    nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
    nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
    nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
    nmap('<leader>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, '[W]orkspace [L]ist Folders')

    require("clangd_extensions.inlay_hints").setup_autocmd()
    require("clangd_extensions.inlay_hints").set_inlay_hints()
    nmap('<leader>ti', require("clangd_extensions.inlay_hints").toggle_inlay_hints, '[T]oggle [I]nlay Hints')
    nmap('gh', '<cmd>ClangdSwitchSourceHeader<cr>', '[G]oto [H]eader <-> source')

    vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
        if vim.lsp.buf.format then
            vim.lsp.buf.format()
        elseif vim.lsp.buf.formatting then
            vim.lsp.buf.formatting()
        end
    end, { desc = 'Format current buffer with LSP' })
end)

lsp.setup()

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
