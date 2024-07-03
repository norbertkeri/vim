vim.keymap.set('n', '<F3>', ":!cargo +nightly clippy --fix -Z unstable-options --allow-dirty --allow-staged<cr>")
vim.keymap.set('n', 'J', ':RustLsp joinLines<cr>')
vim.keymap.set('n', '<leader>d', ':RustLsp openDocs<cr>', { silent = true })
