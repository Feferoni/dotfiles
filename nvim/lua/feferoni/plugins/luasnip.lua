local traits = {
    -- Each entry is: {trait_name, description}
    {
        "is_trivial",
        "Type is trivial: has trivial default constructor, copy constructor, move constructor, copy assignment, move assignment, and destructor"
    },
    {
        "is_trivially_copyable",
        "Type can be copied by simple memcpy: all copy/move operations are trivial or deleted, and destructor is trivial"
    },
    {
        "is_standard_layout",
        "Type has standard layout: same memory layout as equivalent C struct/class, useful for C compatibility and memory mapping"
    },
    {
        "is_pod",
        "Type is Plain Old Data: both trivial and standard layout, behaves like a C struct/union type"
    },

    -- Construction/destruction
    {
        "is_default_constructible",
        "Type can be default constructed: has public default constructor or no user-declared constructors"
    },
    {
        "is_trivially_default_constructible",
        "Type's default constructor is trivial: compiler-generated or empty"
    },
    {
        "is_nothrow_default_constructible",
        "Type's default constructor cannot throw exceptions"
    },
    {
        "is_copy_constructible",
        "Type can be copy constructed: has public copy constructor"
    },
    {
        "is_trivially_copy_constructible",
        "Type's copy constructor is trivial: simple member-wise copy"
    },
    {
        "is_nothrow_copy_constructible",
        "Type's copy constructor cannot throw exceptions"
    },
    {
        "is_move_constructible",
        "Type can be move constructed: has public move constructor or copy constructor"
    },
    {
        "is_trivially_move_constructible",
        "Type's move constructor is trivial: simple member-wise move"
    },
    {
        "is_nothrow_move_constructible",
        "Type's move constructor cannot throw exceptions"
    },
    {
        "is_destructible",
        "Type can be destroyed: has accessible destructor"
    },
    {
        "is_trivially_destructible",
        "Type's destructor is trivial: compiler-generated or empty"
    },
    {
        "is_nothrow_destructible",
        "Type's destructor cannot throw exceptions"
    },

    -- Assignment
    {
        "is_copy_assignable",
        "Type can be copy assigned: has public copy assignment operator"
    },
    {
        "is_trivially_copy_assignable",
        "Type's copy assignment is trivial: simple member-wise copy"
    },
    {
        "is_nothrow_copy_assignable",
        "Type's copy assignment cannot throw exceptions"
    },
    {
        "is_move_assignable",
        "Type can be move assigned: has public move assignment operator or copy assignment"
    },
    {
        "is_trivially_move_assignable",
        "Type's move assignment is trivial: simple member-wise move"
    },
    {
        "is_nothrow_move_assignable",
        "Type's move assignment cannot throw exceptions"
    },

    -- Type categories
    {
        "is_void",
        "Type is void"
    },
    {
        "is_null_pointer",
        "Type is std::nullptr_t"
    },
    {
        "is_integral",
        "Type is integral: bool, char, short, int, long, etc."
    },
    {
        "is_floating_point",
        "Type is floating point: float, double, long double"
    },
    {
        "is_array",
        "Type is an array"
    },
    {
        "is_enum",
        "Type is an enumeration"
    },
    {
        "is_union",
        "Type is a union"
    },
    {
        "is_class",
        "Type is a class/struct"
    },
    {
        "is_function",
        "Type is a function type"
    },
    {
        "is_pointer",
        "Type is a pointer"
    },
    {
        "is_lvalue_reference",
        "Type is an lvalue reference"
    },
    {
        "is_rvalue_reference",
        "Type is an rvalue reference"
    },
    {
        "is_member_object_pointer",
        "Type is a pointer to member object"
    },
    {
        "is_member_function_pointer",
        "Type is a pointer to member function"
    },

    -- Type properties
    {
        "is_const",
        "Type is const-qualified"
    },
    {
        "is_volatile",
        "Type is volatile-qualified"
    },
    {
        "is_signed",
        "Type is a signed arithmetic type"
    },
    {
        "is_unsigned",
        "Type is an unsigned arithmetic type"
    },
    {
        "is_bounded_array",
        "Type is an array with known bounds"
    },
    {
        "is_unbounded_array",
        "Type is an array with unknown bounds"
    },
    {
        "is_abstract",
        "Type is an abstract class (has at least one pure virtual function)"
    },
    {
        "is_final",
        "Type is marked as final (cannot be inherited from)"
    },
    {
        "is_aggregate",
        "Type is an aggregate: array or class with no user-declared constructors, private/protected members, virtual functions, or inheritance"
    },
    {
        "is_empty",
        "Type is an empty class (no non-static data members)"
    },
    {
        "is_polymorphic",
        "Type is polymorphic: has at least one virtual function"
    },
    {
        "is_sealed",
        "Type cannot be used as a base class"
    }
}

local function generate_assertions(args)
    local ls = require("luasnip")
    local sn = ls.snippet_node
    local t = ls.text_node

    local nodes = {}
    local class_name = args[1][1]

    for _, trait in ipairs(traits) do
        local name, description = trait[1], trait[2]
        table.insert(nodes, t({
            string.format("// %s", name),
            string.format("// Description: %s", description),
            string.format("static_assert(std::%s_v<%s>, \"%s must satisfy %s\");",
                name, class_name, class_name, name),
            ""
        }))
    end

    return sn(nil, nodes)
end

return {
    'L3MON4D3/LuaSnip',
    event = "VeryLazy",
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
        require('luasnip.loaders.from_vscode').lazy_load()

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
        ls.add_snippets("cpp", {
            s("pragma_keep", {
                t("// IWYU pragma: keep")
            }),
        })
        ls.add_snippets("cpp", {
            s("gcov_excl_start", {
                t("// GCOV_EXCL_START")
            }),
        })
        ls.add_snippets("cpp", {
            s("gcov_excl_stop", {
                t("// GCOV_EXCL_STOP")
            }),
        })
        ls.add_snippets("cpp", {
            s("lcov_excl_start", {
                t("// LCOV_EXCL_START")
            }),
        })
        ls.add_snippets("cpp", {
            s("lcov_excl_stop", {
                t("// LCOV_EXCL_STOP")
            }),
        })
        ls.add_snippets("cpp", {
            s("typetraits", {
                t({ "// Generated type traits for " }),
                i(1, "ClassName"),
                t({ "", "", "#include <type_traits>", "", "namespace {", "" }),
                d(2, generate_assertions, { 1 }),
                t({ "} // namespace", "" })
            })
        })
        ls.add_snippets("cpp", {
            s("nolint_performance_unnecessary_value_param", {
                t("// NOLINT(performance-unnecessary-value-param)")
            }),
        })
    end
}
