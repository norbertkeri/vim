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

_G.LspDiagnosticsShowPopup = function()
    return vim.diagnostic.open_float({ scope = "cursor", focusable = false })
end

-- Show diagnostics in a pop-up window on hover
_G.LspDiagnosticsPopupHandler = function()
    local current_cursor = vim.api.nvim_win_get_cursor(0)
    local last_popup_cursor = vim.w.lsp_diagnostics_last_cursor or { nil, nil }

    -- Show the popup diagnostics window,
    -- but only once for the current cursor location (unless moved afterwards).
    if not (current_cursor[1] == last_popup_cursor[1] and current_cursor[2] == last_popup_cursor[2]) then
        vim.w.lsp_diagnostics_last_cursor = current_cursor
        local _, winnr = _G.LspDiagnosticsShowPopup()
        if winnr ~= nil then
            vim.api.nvim_win_set_option(winnr, "winblend", 20) -- opacity for diagnostics
        end
    end
end

vim.cmd([[
augroup LSPDiagnosticsOnHover
  autocmd!
  autocmd CursorHold * lua _G.LspDiagnosticsPopupHandler()
augroup END
]])
-- How do I do this only if the current colorscheme does not define these groups?
--vim.cmd [[autocmd! ColorScheme * highlight NormalFloat guibg=#1f2335]]
--vim.cmd [[autocmd! ColorScheme * highlight FloatBorder guifg=white guibg=#1f2335]]

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "rounded",
})

vim.opt.completeopt = "menuone,noselect,noinsert"
vim.opt.shortmess:append("c")

vim.lsp.inlay_hint.enable()
