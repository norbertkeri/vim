local tsbuiltin = require("telescope.builtin")

local M = {}

function M.setup_lsp_keymaps(lspclient, bufnr)
    local bufmap = require("visko.helpers").vim.create_bufmap(bufnr)

    vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

    bufmap("n", "<leader>s", tsbuiltin.lsp_dynamic_workspace_symbols, "Workspace symbols")
    bufmap("n", "<leader>j", vim.diagnostic.goto_next, "Next diagnostic")
    bufmap("n", "<leader>k", vim.diagnostic.goto_prev, "Prev diagnostic")

    bufmap("n", "K", vim.lsp.buf.hover, "Hover")
    bufmap("n", "<leader>i", ":Trouble cascade toggle<cr>", "Open Trouble")

    bufmap("n", "gd", vim.lsp.buf.definition, "Go to definition")
    bufmap("n", "gD", vim.lsp.buf.implementation, "Go to implementation")
    bufmap("n", "1gD", vim.lsp.buf.type_definition, "Go to type definition")
    bufmap("n", "gR", function()
        require("trouble").open({
            mode = "lsp_references",
        })
    end, "Find references")
    bufmap("n", "gr", vim.lsp.buf.rename, "LSP rename")
    bufmap("n", "ge", vim.diagnostic.open_float, "LSP open float")
    bufmap({ "n", "v" }, "ga", vim.lsp.buf.code_action, "Code actions")
    bufmap("n", "<leader>H", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
    end, "Toggle inlay hints")
end

local lang_settings = {
    ["rust-analyzer"] = {
        autoformat = true,
    },
    ["lua_ls"] = {
        autoformat = true,
    },
}

function M.on_attach(client, bufnr)
    if client.name == "pyright" then
        client.server_capabilities.completionProvider = false
    end

    if client.server_capabilities.documentSymbolProvider then
        local navic = require("nvim-navic")
        navic.attach(client, bufnr)
    end

    if
        client.server_capabilities.documentFormattingProvider
        and lang_settings[client.name]
        and lang_settings[client.name]["autoformat"]
    then
        vim.cmd([[
            augroup LspFormat
            autocmd! * <buffer>
            autocmd BufWritePre <buffer> lua vim.lsp.buf.format()
            augroup END
        ]])
    end
end

return M
