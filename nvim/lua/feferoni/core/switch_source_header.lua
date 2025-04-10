local function switch_source_header_handler(_, uri)
    if not uri or uri == "" then
        vim.api.nvim_echo(
            { { "Corresponding file cannot be determined" } },
            false,
            {}
        )
        return
    end
    local file_name = vim.uri_to_fname(uri)
    vim.api.nvim_cmd({
        cmd = "edit",
        args = { file_name },
    }, {})
end

vim.api.nvim_create_user_command(
    "SwitchSourceHeader",
    function()
        vim.lsp.buf_request(0, "textDocument/switchSourceHeader", {
            uri = vim.uri_from_bufnr(0),
        }, switch_source_header_handler)
    end,
    {}
)
