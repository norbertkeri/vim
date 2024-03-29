local setup_cmp = function()
    local cmp = require'cmp'
    local documentation_window = cmp.config.window.bordered()
    documentation_window.max_height = 60

    cmp.setup({
        window = {
            completion = cmp.config.window.bordered(),
            documentation = documentation_window
        },
        snippet = {
            expand = function(args)
                vim.fn["vsnip#anonymous"](args.body)
            end,
        },
        mapping = cmp.mapping.preset.insert({
            ['<C-p>'] = cmp.mapping.select_prev_item(),
            ['<C-n>'] = cmp.mapping.select_next_item(),
            -- Add tab support
            ['<S-Tab>'] = cmp.mapping.select_prev_item(),
            ['<Tab>'] = cmp.mapping.select_next_item(),
            ['<C-b>'] = cmp.mapping.scroll_docs(-4),
            ['<C-f>'] = cmp.mapping.scroll_docs(4),
            ['<C-e>'] = cmp.mapping.abort(),
            ['<CR>'] = cmp.mapping.confirm({
                behavior = cmp.ConfirmBehavior.Replace,
                select = true,
            })
        }),

        -- Installed sources
        sources = cmp.config.sources({
            { name = 'nvim_lsp' },
            { name = 'nvim_lsp_signature_help'},
            { name = 'vsnip' }, -- Not sure I actually use snippets
        }, {
            { name = 'path' },
            { name = 'buffer', keyword_length = 5 },
        }),
    })

end

local setup_lspconfig = function()
    require("mason").setup()
    require("mason-lspconfig").setup({
        ensure_installed = { "rust_analyzer", "lua_ls", "jsonls", "bashls" }
    })

    require("neodev").setup({
    })

    local lspconfig = require('lspconfig')
    local capabilities = require("cmp_nvim_lsp").default_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true

    local servers = {
        bashls = {},
        jedi_language_server = {},
        pyright = {},
        jsonls = {},
        lua_ls = {
            settings = {
                Lua = {
                    runtime = {
                        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                        version = 'LuaJIT',
                        -- Setup your lua path
                        path = runtime_path,
                    },
                    diagnostics = {
                        -- Get the language server to recognize the `vim` global
                        globals = {'vim'},
                    },
                    workspace = {
                        -- Make the server aware of Neovim runtime files
                        library = vim.api.nvim_get_runtime_file("", true),
                        checkThirdParty = false
                    },
                    -- Do not send telemetry data containing a randomized but unique identifier
                    telemetry = {
                        enable = false,
                    },
                }
            }
        },
        yamlls = {
            settings = {
                yaml = {
                    schemas = {
                        ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*"
                    }
                }
            }
        },
        -- According to the rustacean.nvim documentation, this should not be called because it will cause conflicts
        --rust_analyzer = {},
        terraformls = {
        }
    }

    local on_attach = function(client, bufnr)
        require('visko.lsp_mappings').setup_lsp_keymaps(client, bufnr)
        require('visko.lsp_mappings').on_attach(client, bufnr)
    end

    local common_options = {
        on_attach = on_attach,
        capabilities = capabilities,
        flags = {
            debounce_text_changes = 150,
        }
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
    'hrsh7th/nvim-cmp',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-buffer',
    'hrsh7th/vim-vsnip',
    'hrsh7th/vim-vsnip-integ',
    {
        'lvimuser/lsp-inlayhints.nvim',
        opts = {}
    },
    {
        'hrsh7th/cmp-vsnip',
        config = setup_cmp
    },
    {
    'mrcjkb/rustaceanvim',
        version = "^3",
        ft = {"rust"},
        config = function(_, opts)
            vim.g.rustaceanvim = vim.tbl_deep_extend("force", {}, opts or {})
        end,
        opts = {
            -- tools = {
            --     autoSetHints = true,
            --     hover_with_actions = false,
            --     inlay_hints = {
            --         show_parameter_hints = true,
            --         parameter_hints_prefix = "",
            --         other_hints_prefix = "",
            --     },
            -- },
            server = {
                on_attach = function(client, bufnr)
                    require('visko.lsp_mappings').setup_lsp_keymaps(client, bufnr)
                    require('visko.lsp_mappings').on_attach(client, bufnr)
                end,
                settings = {
                    ["rust-analyzer"] = {
                        diagnostics = {
                            disabled = {"incorrect-ident-case"},
                        },
                        completion = {
                            postfix = {
                                enable = false
                            }
                        },
                        checkOnSave = {
                            command = "clippy"
                        },
                        procMacro = {
                            enable = true,
                            ignored = {
                                ["async-trait"] = { "async_trait" },
                                ["napi-derive"] = { "napi" },
                                ["async-recursion"] = { "async_recursion" },
                            }
                        },
                        inlayHints = {
                            bindingModeHints = {
                                enable = true
                            },
                            -- expressionAdjustmentHints = {
                            --     enable = true
                            -- },
                            closureReturnTypeHints = {
                                enable = true
                            },
                            lifetimeElisionHints = {
                                enable = true
                            },
                            typeHints = {
                                hideClosureInitialization = true
                            },
                        }
                    }
                }
            }
        }
    },
    --'simrat39/rust-tools.nvim',
    {
        'ray-x/lsp_signature.nvim',
        config = function()
            require "lsp_signature".setup({
                max_height = 60,
                max_width = 120,
                doc_lines = 40,
                hint_enable = true,
                hint_prefix = "",
                extra_trigger_chars = {"(", ","},
            })
        end
    },
    {
        'neovim/nvim-lspconfig',
        dependencies = {"SmiteshP/nvim-navic", "williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim"},
        config = setup_lspconfig
    },
    {
        "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
        keys = { { "<leader>tl", toggle_lines, desc = "Toggle lsp lines" }, },
        config = function()
            local lsp_lines = require("lsp_lines")
            lsp_lines.setup()
            vim.diagnostic.config({ virtual_text = true, virtual_lines = false, })
        end
    },
}
