return {
    'L3MON4D3/LuaSnip',
    event = "VeryLazy",
    build = "make install_jsregexp",
    version = "v2.1.1",
    dependencies = {
        'rafamadriz/friendly-snippets',
    },
    config = function()
        local ls = require('luasnip')
        local types = require('luasnip.util.types')

        ls.config.set_config {
            history = true,
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

        vim.keymap.set({ "i" }, "<C-K>", function() ls.expand() end, { silent = true })

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

        vim.keymap.set({ "i", "s" }, "<M-k>", function()
            if ls.choice_active() then
                ls.change_choice(1)
            end
        end, { silent = true })

        vim.keymap.set({ "i", "s" }, "<M-j>", function()
            if ls.choice_active() then
                ls.change_choice(-1)
            end
        end, { silent = true })


        -- ls.filetype_extend("c", { "cdoc" })
        -- ls.filetype_extend("cpp", { "cppdoc" })
        -- ls.filetype_extend("python", { "pydoc" })
        -- ls.filetype_extend("sh", { "shelldoc" })

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



        local get_comment_prefix = function()
            local comment_string = vim.bo.commentstring
            return comment_string:match("^(.-)%%s") or comment_string
        end

        local function currentDate()
            return os.date("%Y-%m-%d")
        end

        local function currentUsername()
            return os.getenv("USER")
        end

        ls.add_snippets("all", {
            s("TODO", {
                f(get_comment_prefix, {}),
                t(" TODO("),
                f(currentUsername, {}),
                t(") - "),
                f(currentDate, {}),
                t(" - "),
                i(1, "COMMENT HERE"),
            })
        })
    end
}
