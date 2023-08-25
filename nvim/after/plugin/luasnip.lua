local ls = require('luasnip')
local types = require('luasnip.util.types')

ls.config.set_config {
    -- this tells luasnip to remember to keep around the last snippet.
    -- You can jump back into it even if you move outside of the selection
    history = true,
    -- this one is cool cause if you have dynamic snippets, it updates as you type!
    updateevents = "TextChanged,TextChangedI",
    enable_autosnippets = true,
    ext_opts = {
        [types.choiceNode] = {
            active = {
                virt_text = { { "<-", "Error" } },
            },
        },
    },
}

vim.keymap.set({ "i", "s" }, "<M-l>", function()
    if ls.expand_or_jumpable() then
        ls.expand_or_jump()
    end
end, { noremap = true, silent = true })

vim.keymap.set({ "i", "s" }, "<M-h>", function()
    if ls.jumpable(-1) then
        ls.jump(-1)
    end
end, { noremap = true, silent = true })

vim.keymap.set("n", "<leader><leader>s", "<cmd>source ~/.config/nvim/after/plugin/luasnip.lua<CR>")


-- short hands for lua snippets
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require("luasnip.util.events")
local ai = require("luasnip.nodes.absolute_indexer")
local extras = require("luasnip.extras")
local l = extras.lambda
local rep = extras.rep
local p = extras.partial
local m = extras.match
local n = extras.nonempty
local dl = extras.dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local conds = require("luasnip.extras.expand_conditions")
local postfix = require("luasnip.extras.postfix").postfix
local types = require("luasnip.util.types")
local parse = require("luasnip.util.parser").parse_snippet
local ms = ls.multi_snippet
local k = require("luasnip.nodes.key_indexer").new_key

ls.add_snippets("all", {
    s("class_5",
        fmt([[
    class {}
    {{
    public:
        explicit {}();
        {}() = default;
        ~{}() = default;
        {}(const {}& other) = delete;
        {}& operator=(const {}& other) = delete;
        {}({}&& other) = delete;
        {}& operator=({}&& other) = delete;

    private:
    }};
    ]], { i(1, "className"), rep(1), rep(1), rep(1), rep(1), rep(1), rep(1), rep(1), rep(1), rep(1), rep(1), rep(1) })),
    s("class_mock",
        fmt([[
    #include <gmock.h>

    #include "{}.h"

    class Mock{} : public {}
    {{
    public: 
        
    }}
    ]], { i(1, "mockName"), rep(1), rep(1) }))
})
