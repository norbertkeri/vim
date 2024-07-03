local completion_filters = {
    rust = function(entry, _)
        local hide = {
            "color_eyre::owo_colors"
        }
        local item = entry:get_completion_item()
        local import_path = vim.tbl_get(item, 'data', 'imports', 1, 'full_import_path')
        for _, v in ipairs(hide) do
            if import_path and string.find(import_path, v) then
                return false
            end
        end
        return true
    end
}

local completion_kinds = {
    Text = { 1, "" },
    Method = { 2, "" },
    Function = { 3, "" },
    Constructor = { 4, "" },
    Field = { 5, "" },
    Variable = { 6, "" },
    Class = { 7, '' },
    Interface = { 8, "" },
    Module = { 9, "" },
    Property = { 10, "ﰠ" },
    Unit = { 11, "" },
    Value = { 12, "" },
    Enum = { 13, "" },
    Keyword = { 14, "" },
    Snippet = { 15, "" },
    Color = { 16, "" },
    File = { 17, "" },
    Reference = { 18, "" },
    Folder = { 19, "" },
    EnumMember = { 20, "" },
    Constant = { 21, "" },
    Struct = { 22, "" },
    Event = { 23, "" },
    Operator = { 24, '' },
    TypeParameter = { 25, ' '},
}

local setup_cmp = function()
    local cmp = require'cmp'
    local documentation_window = cmp.config.window.bordered()
    documentation_window.max_height = 60

    cmp.setup({
        window = {
            completion = cmp.config.window.bordered(),
            documentation = documentation_window
        },
        formatting = {
            fields = {"kind", "abbr", "menu"},
            format = function(entry, vim_item)
                vim_item.kind = (completion_kinds[vim_item.kind][2] or '') .. " "
                -- vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- show icons with the name of the item kind

                -- set a name for each source
                vim_item.menu = ({
                    buffer = "[Buffer]",
                    nvim_lsp = "[LSP]",
                    luasnip = "[Snippet]",
                    nvim_lua = "[Lua]",
                    latex_symbols = "[LaTeX]",
                })[entry.source.name]

                return vim_item
            end,
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
            { name = "crates" },
            { name = 'nvim_lsp', entry_filter = function(entry, ctx)
                local filter = completion_filters[vim.bo.filetype]
                if filter ~= nil then
                    return filter(entry, ctx)
                end
                return true
            end },
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
        fish_lsp = {},
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
        'hrsh7th/cmp-vsnip',
        config = setup_cmp
    },
    {
        'ray-x/lsp_signature.nvim',
        config = function()
            require "lsp_signature".setup({
                max_height = 60,
                max_width = 120,
                doc_lines = 3,
                hint_enable = false,
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
