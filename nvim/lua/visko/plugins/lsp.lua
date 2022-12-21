local setup_cmp = function()
    local cmp = require'cmp'
    cmp.setup({
        preselect = cmp.PreselectMode.None,
        window = {
            completion = cmp.config.window.bordered(),
            documentation = cmp.config.window.bordered(),
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
            ['<C-d>'] = cmp.mapping.scroll_docs(-4),
            ['<C-f>'] = cmp.mapping.scroll_docs(4),
            ['<C-l>'] = cmp.mapping.complete(),
            ['<C-e>'] = cmp.mapping.abort(),
            ['<CR>'] = cmp.mapping.confirm({
                behavior = cmp.ConfirmBehavior.Insert,
                select = false,
            })
        }),

        -- Installed sources
        sources = {
            { name = 'nvim_lsp' },
            { name = 'nvim_lsp_signature_help'},
            { name = 'vsnip' }, -- Not sure I actually use snippets
            { name = 'path' },
            --{ name = 'buffer' },
        },
    })
end

local setup_lspconfig = function()
    local lsp_installer = require("nvim-lsp-installer")
    lsp_installer.setup {}

    --[[
    require("neodev").setup({
    })
    --]]

    local lspconfig = require('lspconfig')
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
    capabilities.textDocument.completion.completionItem.snippetSupport = true

    local servers = {
        bashls = {},
        jedi_language_server = {},
        pyright = {},
        jsonls = {},
        --[[
        sumneko_lua = {
            settings = {
                Lua = {
                    completion = {
                        callSnippet = "Replace"
                    }
                }
            }
        }
        --]]
        --[[
        sumneko_lua = {
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
        ]]--
        yamlls = {
            settings = {
                yaml = {
                    schemas = {
                        ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*"
                    }
                }
            }
        },
        rust_analyzer = {
            tools = {
                autoSetHints = true,
                hover_with_actions = false,
                inlay_hints = {
                    show_parameter_hints = true,
                    parameter_hints_prefix = "",
                    other_hints_prefix = "",
                },
            },
            server = {
                settings = {
                    ["rust-analyzer"] = {
                        diagnostics = {
                            disabled = {"incorrect-ident-case"}
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
                            enable = true
                        },
                    }
                }
            }
        }
    }

    local autoformat = false

    local navic = require("nvim-navic")
    local on_attach = function(client, bufnr)
        require('visko.lsp_mappings').setup_lsp_keymaps(client, bufnr)

        if client.server_capabilities.documentSymbolProvider then
            navic.attach(client, bufnr)
        end
        if client.server_capabilities.documentFormattingProvider and autoformat then
            vim.cmd([[
                augroup LspFormat
                autocmd! * <buffer>
                autocmd BufWritePre <buffer> lua vim.lsp.buf.format()
                augroup END
            ]])
        end
    end

    local common_options = {
        on_attach = on_attach,
        capabilities = capabilities,
        flags = {
            debounce_text_changes = 150,
        }
    }

    for server, opts in pairs(servers) do
        if server == "rust_analyzer" then
            -- rust-tools is special, and expects lsp server related configuration in the "server" key (everything else just uses the top level table)
            opts.server = vim.tbl_deep_extend("force", {}, common_options, opts.server or {})
            require("rust-tools").setup(opts)
        else
            opts = vim.tbl_deep_extend("force", {}, common_options, opts or {})
            lspconfig[server].setup(opts)
        end

    end

end
return {
    'williamboman/nvim-lsp-installer',
    'onsails/lspkind.nvim',
    'hrsh7th/nvim-cmp',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-buffer',
    'hrsh7th/vim-vsnip',
    'hrsh7th/vim-vsnip-integ',
    {
        'hrsh7th/cmp-vsnip',
        config = setup_cmp
    },
    {
        'simrat39/rust-tools.nvim',
        --config = setup_rust_tools
    },
    {
        'ray-x/lsp_signature.nvim',
        config = function()
            require "lsp_signature".setup({
                hint_prefix = "",
                extra_trigger_chars = {"(", ","},
            })
        end
    },
    {
        'neovim/nvim-lspconfig',
        dependencies = {"SmiteshP/nvim-navic"},
        config = setup_lspconfig
    },
}
