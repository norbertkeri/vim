vim.keymap.set("n", "<F3>", ":!cargo clippy --fix --allow-dirty --allow-staged<cr>")
vim.keymap.set("n", "J", ":RustLsp joinLines<cr>")
vim.keymap.set("n", "<leader>d", ":RustLsp openDocs<cr>", { silent = true })
