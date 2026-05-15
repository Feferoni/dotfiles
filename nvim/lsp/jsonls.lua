return {
    cmd = { "vscode-json-language-server", "--stdio" },
    root_dir = function(fname) return vim.fs.root(fname, { ".git" }) end,
    provideFormatter = true,
    files = { "json", "jsonc" },
    single_file_support = true,
}
