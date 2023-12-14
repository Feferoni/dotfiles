local mason = require("mason")
mason.setup()

local lsp = require('lsp-zero')

-- lsp.preset('recommended')
lsp.preset({})

local cmp = require('cmp')
local cmp_action = lsp.cmp_action()

cmp.setup({
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ['<A-k>'] = cmp.mapping.select_prev_item(cmp_select),
        ['<A-j>'] = cmp.mapping.select_next_item(cmp_select),
        ['<A-a>'] = cmp.mapping.confirm({ select = true }),
        ["<A-s>"] = cmp.mapping.complete(),
        ['<Tab>'] = nil,
        ['<S-Tab>'] = nil,
    })
})

lsp.set_preferences({
    suggest_lsp_servers = false,
    sign_icons = {
        error = 'E',
        warn = 'W',
        hint = 'H',
        info = 'I'
    }
})

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

local lsp_config = require('lspconfig')
lsp_config.elixirls.setup{
  cmd = { "/home/feferoni/git/elixir-ls/apps/elixir_ls_utils/priv/language_server.sh" },
  capabilities = capabilities,
  flags = {
    debounce_text_changes = 150,
  },
  elixirLS = {
    dialyzerEnabled = false,
    fetchDeps = false,
  };
}


lsp_config.cmake.setup({
    cmd = {
        "cmake-language-server"
    }
})

lsp_config.bashls.setup({
    cmd = {
        "bash-language-server",
        "start"
    },
})

lsp_config.pyright.setup({
    cmd = {
        "pyright-langserver",
        "--stdio"
    },
})

lsp_config.lua_ls.setup({
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

-- LSP settings.
--  This function gets run when an LSP connects to a particular buffer.
lsp.on_attach(function(_, bufnr)
    -- NOTE: Remember that lua is a real programming language, and as such it is possible
    -- to define small helper and utility functions so you don't have to repeat yourself
    -- many times.
    --
    -- In this case, we create a function that lets us more easily define mappings specific
    -- for LSP related items. It sets the mode, buffer and description for us each time.
    local nmap = function(keys, func, desc)
        if desc then
            desc = 'LSP: ' .. desc
        end

        vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
    end

    nmap('rn', vim.lsp.buf.rename, '[R]e[n]ame')
    nmap('ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
    nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
    nmap('gi', vim.lsp.buf.implementation, '[G]oto [I]mplementation')

    nmap('<leader>gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
    nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
    nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
    nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
    -- See `:help K` for why this keymap
    nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
    nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')
    -- Lesser used LSP functionality
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

    -- Create a command `:Format` local to the LSP buffer
    vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
        if vim.lsp.buf.format then
            vim.lsp.buf.format()
        elseif vim.lsp.buf.formatting then
            vim.lsp.buf.formatting()
        end
    end, { desc = 'Format current buffer with LSP' })
end)

lsp.setup()


vim.diagnostic.config({
    virtual_text = true
})

