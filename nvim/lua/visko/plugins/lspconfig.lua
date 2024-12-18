local helpers = require('visko.helpers')
local hide_rust_modules = {
    "OwoColorize",
}

local completion_filters = {
    rust = function(items)
        local result = {}
        for _, item in ipairs(items) do
            local import_path = vim.tbl_get(item, "data", "imports", 1, "imported_name")
            if not helpers.in_table(import_path, hide_rust_modules) then
                table.insert(result, item)
            end
        end
        return result
    end,
}

local setup_lspconfig = function()
    require("mason").setup()
    require("mason-lspconfig").setup({
        ensure_installed = { "rust_analyzer", "lua_ls", "jsonls", "bashls" },
    })

    require("neodev").setup({})

    local lspconfig = require("lspconfig")

    local servers = {
        bashls = {},
        jedi_language_server = {},
        pyright = {},
        jsonls = {},
        fish_lsp = {},
        lua_ls = {
            settings = {
                Lua = {
                    runtime = {
                        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                        version = "LuaJIT",
                        -- Setup your lua path
                        path = runtime_path,
                    },
                    diagnostics = {
                        -- Get the language server to recognize the `vim` global
                        globals = { "vim" },
                    },
                    workspace = {
                        -- Make the server aware of Neovim runtime files
                        library = vim.api.nvim_get_runtime_file("", true),
                        checkThirdParty = false,
                    },
                    -- Do not send telemetry data containing a randomized but unique identifier
                    telemetry = {
                        enable = false,
                    },
                    format = {
                        enable = true,
                        defaultConfig = {
                            indent_style = "space",
                            indent_size = 4
                        }

                    }
                },
            },
        },
        yamlls = {
            settings = {
                yaml = {
                    -- schemas = {
                    --     ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
                    -- },
                },
            },
        },
        -- According to the rustacean.nvim documentation, this should not be called because it will cause conflicts
        --rust_analyzer = {},
        terraformls = {},
    }

    local on_attach = function(client, bufnr)
        require("visko.lsp_mappings").setup_lsp_keymaps(client, bufnr)
        require("visko.lsp_mappings").on_attach(client, bufnr)
    end

    local capabilities = require('blink.cmp').get_lsp_capabilities()
    local common_options = {
        on_attach = on_attach,
        capabilities = capabilities,
        -- flags = {
        --     debounce_text_changes = 150,
        -- },
    }

    for server, opts in pairs(servers) do
        opts = vim.tbl_deep_extend("force", {}, common_options, opts or {})
        lspconfig[server].setup(opts)
    end
end

local function toggle_lines()
    local lsp_lines = require("lsp_lines")
    lsp_lines.toggle()
    vim.diagnostic.config({ virtual_text = not vim.diagnostic.config().virtual_text })
end

return {
    {
        "neovim/nvim-lspconfig",
        dependencies = { "SmiteshP/nvim-navic", "williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim" },
        config = setup_lspconfig,
    },
    {
        "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
        keys = { { "<leader>tl", toggle_lines, desc = "Toggle lsp lines" } },
        config = function()
            local lsp_lines = require("lsp_lines")
            lsp_lines.setup()
            vim.diagnostic.config({ virtual_text = true, virtual_lines = false })
        end,
    },

    {
        'saghen/blink.cmp',
        lazy = false, -- lazy loading handled internally
        -- optional: provides snippets for the snippet source
        dependencies = 'rafamadriz/friendly-snippets',

        -- use a release tag to download pre-built binaries
        version = 'v0.*',
        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            keymap = {
                ['<C-n>'] = { 'select_next', 'fallback', },
                ['<Tab>'] = {
                    function(cmp)
                        if cmp.snippet_active() then
                            return cmp.snippet_forward()
                        else
                            return cmp.select_next()
                        end
                    end,
                    'fallback'
                },
                ['<S-Tab>'] = {
                    function(cmp)
                        if cmp.snippet_active() then
                            return cmp.snippet_backward()
                        else
                            return cmp.select_prev()
                        end
                    end,
                    'fallback'
                },
                ['<C-p>'] = { 'select_prev', 'fallback', },
                ['<C-d>'] = { 'show', 'show_documentation', 'hide_documentation', 'fallback' },
                ['<cr>'] = { 'select_and_accept', 'fallback', },
                ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
                ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
            },
            completion = {
                ghost_text = { enabled = true },
                documentation = {
                    auto_show = true,
                    update_delay_ms = 10,
                    window = {
                        max_width = 80,
                        max_height = 40,
                        border = 'rounded',
                        winblend = 20,
                    }
                },
                menu = {
                    winblend = 20,
                    min_width = 25,
                    max_height = 40,
                    border = 'rounded',
                    draw = {
                        treesitter = { 'lsp' },
                        columns = { { 'kind_icon', 'label', gap = 1 }, { 'label_description', 'kind', gap = 1 } },
                        components = {
                            label = {
                                text = function(ctx) return ctx.label .. ctx.label_detail end,
                            },

                            label_description = {
                                text = function(ctx)
                                    if vim.bo.filetype ~= "rust" then
                                        return ctx.label_description
                                    end
                                end,
                            },
                        }
                    },
                },
            },
            appearance = {
                -- Sets the fallback highlight groups to nvim-cmp's highlight groups
                -- Useful for when your theme doesn't support blink.cmp
                -- will be removed in a future release
                use_nvim_cmp_as_default = true,
                -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
                -- Adjusts spacing to ensure icons are aligned
                nerd_font_variant = 'mono'
            },

            signature = {
                enabled = true,
                window = {
                    winblend = 20,
                    border = 'rounded',
                }
            },
            sources = {
                providers = {
                    snippets = {
                        enabled = false
                    },
                    buffer = {
                        min_keyword_length = 3,
                    },
                    lsp = {
                        transform_items = function(_, items)
                            if completion_filters[vim.bo.filetype] ~= nil then
                                return completion_filters[vim.bo.filetype](items)
                            end
                            return items
                        end
                    }
                }
            },
            fuzzy = {
                use_typo_resistance = false
            }
        },
        -- allows extending the providers array elsewhere in your config
        -- without having to redefine it
        opts_extend = { "sources.default" }
    },
}
