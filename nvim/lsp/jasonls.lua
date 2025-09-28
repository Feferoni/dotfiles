return {
    cmd = { "vscode-json-language-server", "--stdio" },
    root_dir = require("lspconfig").util.find_git_ancestor,
    provideFormatter = true,
    files = { "json", "jsonc" },
    single_file_support = true,
}
