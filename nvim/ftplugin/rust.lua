vim.cmd([[
map <buffer> <F3> :!cargo +nightly clippy --fix -Z unstable-options --allow-dirty --allow-staged<cr>
nnoremap <buffer> J :lua require'rust-tools.join_lines'.join_lines()<cr>
]])
