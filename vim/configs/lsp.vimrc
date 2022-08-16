set completeopt=menuone,noselect,noinsert

" Avoid showing extra messages when using completion
set shortmess+=c

" Code navigation shortcuts
nnoremap <silent> gd <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
"nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gR    <cmd>lua vim.lsp.buf.references({ includeDeclaration = false })<CR>
nnoremap <silent> gr    <cmd>lua vim.lsp.buf.rename()<CR>
nnoremap <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
"nnoremap <silent> gd    <cmd>lua vim.lsp.buf.declaration()<CR>

nnoremap <silent> ge    <cmd>lua vim.diagnostic.open_float()<CR>

set updatetime=300

" Goto previous/next diagnostic warning/error
nnoremap <silent> <leader>j <cmd>lua vim.diagnostic.goto_next()<CR>
nnoremap <silent> <leader>k <cmd>lua vim.diagnostic.goto_prev()<CR>

set signcolumn=yes

let g:completion_enable_auto_paren = 1

nnoremap ga :lua vim.lsp.buf.code_action()<cr>
vnoremap ga :lua vim.lsp.buf.range_code_action()<cr>

map <leader>s :Telescope lsp_workspace_symbols<cr>
map <leader>e :Telescope diagnostics theme=get_dropdown<cr>
map <leader>d :Telescope lsp_definitions<cr>
map <leader>r :Telescope lsp_references<cr>
