return {
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
}
