local signs = {
    DiagnosticSignError = " ",
    DiagnosticSignWarn = " ",
    DiagnosticSignInfo = " ",
    DiagnosticSignHint = " ",
}

for k, v in pairs(signs) do
    vim.fn.sign_define(k, { text = v, texthl = k })
end

vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    update_in_insert = true,
    underline = false,
    severity_sort = false,
    float = {
        border = "rounded",
        header = "",
        prefix = "",
    },
})

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "rounded",
})

vim.opt.completeopt = "menuone,noselect,noinsert"
vim.opt.shortmess:append("c")
