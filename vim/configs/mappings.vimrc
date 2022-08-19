nnoremap <S-q> :tabclose<cr>
nmap <leader>q :tabonly<CR>
nmap / /\v

" Moving between windows
map <C-l> <C-w>l
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-h> <C-w>h

" Same, but for colemak
nnoremap <a-m> <c-w>h
nnoremap <a-n> <c-w>j
nnoremap <a-e> <c-w>k
nnoremap <a-i> <c-w>l
nnoremap <a-q> :close<cr>

"nmap <leader>f :Files<cr>
"nmap <leader>b :Buffers<cr>
"nmap <leader>m :History<cr>

nmap <leader>f :Telescope find_files<cr>
nmap <leader>b :Telescope buffers<cr>
nmap <leader>m :Telescope oldfiles<cr>

nmap <F2> :tabnew ~/.vimrepository/vim/configs/plugins.vimrc<cr>
nmap <F3> :tabnew ~/.vimrepository/vim/configs/local.vimrc<cr>
nmap <F4> :tabnew ~/.vimrepository/nvim/lua/config/init.lua<cr>

nmap <leader>F <Plug>CtrlSFPrompt
nmap ! <Plug>CtrlSFCwordExec
vmap ! <Plug>CtrlSFVwordExec
nnoremap zz yyp^i//<esc>j

nnoremap <tab> :tabnext<cr>
nnoremap <S-tab> :tabprev<cr>

nmap _ :Explore<CR>

map p <Plug>(miniyank-autoput)
map P <Plug>(miniyank-autoPut)
map <leader>p <Plug>(miniyank-cycle)
map <leader>P <Plug>(miniyank-cycleback)

nnoremap <C-c> "+yy
vnoremap <C-c> "+y
nnoremap <C-S-c> "*yy
vnoremap <C-S-c> "*y

nnoremap <C-v> "+p
nnoremap <C-S-v> "*p

au FileType netrw nnoremap <buffer> _ <Plug>NetrwBrowseUpDir<Space>
au FileType rust nnoremap <buffer> <leader>d :RustOpenExternalDocs<cr>

nnoremap <silent> <C-t>   :FloatermToggle common<CR>
tnoremap <silent> <C-t>   <C-\><C-n>:FloatermToggle common<CR>
