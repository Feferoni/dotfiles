return {
    cmd = {
        "clangd",
        "-j=10",
        "--background-index",
        "--all-scopes-completion",
        "--header-insertion=never",
        "--pch-storage=disk",
        "--log=info",
        "--clang-tidy",
        "--enable-config",
    },
    filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda' },
    root_markers = {
        '.clangd',
        '.clang-tidy',
        '.clang-format',
        'compile_commands.json',
        'compile_flags.txt',
        'configure.ac',
        '.git',
    },
    capabilities = {
        offsetEncoding = { 'utf-8', 'utf-16' },
        textDocument = {
            completion = {
                editsNearCursor = true,
                completionItem = {
                    snippetSupport = true,
                }
            },
        },
    },
    on_init = function(client, init_result)
        if init_result.offsetEncoding then client.offset_encoding = init_result.offsetEncoding end
    end,
}
