local map = require("visko.helpers").vim.mapkey

map("n", "<F3>", ":!cargo clippy --fix --allow-dirty --allow-staged<cr>", "Clippy fix")
map("n", "J", ":RustLsp joinLines<cr>", "LSP join lines")
map("n", "<leader>d", ":RustLsp openDocs<cr>", "Open documentation")
