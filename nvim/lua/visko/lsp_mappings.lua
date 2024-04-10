local tsbuiltin = require('telescope.builtin')

local function bufmap(mode, lhs, rhs, opts)
    local localopts = { buffer = bufnr, silent = true }
    vim.keymap.set(mode, lhs, rhs, localopts)
end

local M = {}

function M.setup_lsp_keymaps(lspclient, bufnr)

    vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'

    bufmap('n', '<leader>s', tsbuiltin.lsp_dynamic_workspace_symbols)
    bufmap('n', '<leader>j', vim.diagnostic.goto_next)
    bufmap('n', '<leader>k', vim.diagnostic.goto_prev)
    bufmap('n', '<leader>n', vim.diagnostic.goto_next)
    bufmap('n', '<leader>e', vim.diagnostic.goto_prev)

    bufmap({'n', 'v'}, 'ga', vim.lsp.buf.code_action)
    bufmap('n', 'K', vim.lsp.buf.hover)
    bufmap('n', '<leader>i', ':TroubleToggle<cr>')

    bufmap('n', 'gd', vim.lsp.buf.definition)
    bufmap('n', 'gD', vim.lsp.buf.implementation)
    bufmap('n', '1gD', vim.lsp.buf.type_definition)
    bufmap('n', 'gR', function() vim.lsp.buf.references({ includeDeclaration = false }) end)
    bufmap('n', 'gr', vim.lsp.buf.rename)
    bufmap('n', 'ge', vim.diagnostic.open_float)

    if lspclient.name == "rust-analyzer" then
        bufmap('n', '<leader>d', ':RustLsp externalDocs<cr>')
    end
end

local lang_settings = {
    ["rust-analyzer"] = {
        autoformat = true,
        inlayHints = true
    }
}

function M.on_attach(client, bufnr)
    if client.name == "pyright" then
        client.server_capabilities.completionProvider = false
    end

    if client.server_capabilities.documentSymbolProvider then
        local navic = require("nvim-navic")
        navic.attach(client, bufnr)
    end

    if lang_settings[client.name] and lang_settings[client.name]["inlayHints"] then
        local lsp_hints = require("lsp-inlayhints")
        lsp_hints.on_attach(client, bufnr)
        lsp_hints.show()
    end


    if client.server_capabilities.documentFormattingProvider and lang_settings[client.name] and lang_settings[client.name]["autoformat"] then
        vim.cmd([[
            augroup LspFormat
            autocmd! * <buffer>
            autocmd BufWritePre <buffer> lua vim.lsp.buf.format()
            augroup END
        ]])
    end
end

return M
