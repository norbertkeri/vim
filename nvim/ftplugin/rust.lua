local map = require("visko.helpers").vim.mapkey

map("n", "<F3>", ":!cargo clippy --fix --allow-dirty --allow-staged<cr>", "Clippy fix")
map("n", "J", ":RustLsp joinLines<cr>", "LSP join lines")
map("n", "<leader>d", ":RustLsp openDocs<cr>", "Open documentation")

for _, method in ipairs({ "textDocument/diagnostic", "workspace/diagnostic" }) do
    local default_diagnostic_handler = vim.lsp.handlers[method]
    vim.lsp.handlers[method] = function(err, result, context, config)
        if err ~= nil and err.code == -32802 then
            return
        end
        return default_diagnostic_handler(err, result, context, config)
    end
end
