vim.cmd([[
map <buffer> <F3> :!cargo +nightly clippy --fix -Z unstable-options --allow-dirty --allow-staged<cr>
map <buffer> <F4> :lua require("lsp-inlayhints").toggle()<cr>
nnoremap <buffer> J :RustLsp joinLines<cr>
]])
