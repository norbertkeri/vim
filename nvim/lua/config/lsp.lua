local lsp_installer = require("nvim-lsp-installer")

vim.fn.sign_define("DiagnosticSignError",
{text = " ", texthl = "DiagnosticSignError"})
vim.fn.sign_define("DiagnosticSignWarn",
{text = " ", texthl = "DiagnosticSignWarn"})
vim.fn.sign_define("DiagnosticSignInfo",
{text = " ", texthl = "DiagnosticSignInfo"})
vim.fn.sign_define("DiagnosticSignHint",
{text = "", texthl = "DiagnosticSignHint"})

lsp_installer.on_server_ready(function(server)
    local opts = {}
    if server.name == "sumneko_lua" then
        local myopts = {
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
                    },
                    -- Do not send telemetry data containing a randomized but unique identifier
                    telemetry = {
                        enable = false,
                    },
                },
            }
        }
        server:setup(myopts)
    elseif server.name == "rust_analyzer" then
        local rustopts = {
            tools = {
                autoSetHints = true,
                hover_with_actions = false,
                inlay_hints = {
                    show_parameter_hints = true,
                    parameter_hints_prefix = "",
                    other_hints_prefix = "",
                },
            },
            server = vim.tbl_deep_extend("force", server:get_default_options(), opts, {
                settings = {
                    ["rust-analyzer"] = {
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
            }),
        }
        require("rust-tools").setup(rustopts)
        server:attach_buffers()
    else
        server:setup(opts)
    end
end)

local lspkind = require('lspkind')
local cmp = require'cmp'
cmp.setup({
  formatting = {
    format = lspkind.cmp_format({
      mode = 'symbol', -- show only symbol annotations
      maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
    })
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
    { name = 'vsnip' }, -- Not sure I actually use snippets
    { name = 'path' },
    --{ name = 'buffer' },
  },
  completion = {
      keyword_length = 3,
  },
})
-- Kill the horrible underline on errors
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, { underline = false })

_G.LspDiagnosticsShowPopup = function()
    return vim.diagnostic.open_float(0, {scope="cursor", focusable=false})
end

-- Show diagnostics in a pop-up window on hover
_G.LspDiagnosticsPopupHandler = function()
  local current_cursor = vim.api.nvim_win_get_cursor(0)
  local last_popup_cursor = vim.w.lsp_diagnostics_last_cursor or {nil, nil}

  -- Show the popup diagnostics window,
  -- but only once for the current cursor location (unless moved afterwards).
  if not (current_cursor[1] == last_popup_cursor[1] and current_cursor[2] == last_popup_cursor[2]) then
    vim.w.lsp_diagnostics_last_cursor = current_cursor
    local _, winnr = _G.LspDiagnosticsShowPopup()
    if winnr ~= nil then
      vim.api.nvim_win_set_option(winnr, "winblend", 20)  -- opacity for diagnostics
    end
  end
end


vim.cmd [[
augroup LSPDiagnosticsOnHover
  autocmd!
  autocmd CursorHold *   lua _G.LspDiagnosticsPopupHandler()
augroup END
]]

require "lsp_signature".setup({
    hint_prefix = "",
    extra_trigger_chars = {"(", ","},
})

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = "rounded",
})
