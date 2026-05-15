return {
    root_dir = function(fname) return vim.fs.root(fname, { ".git" }) end,
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
