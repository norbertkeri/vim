return {
    'voldikss/vim-floaterm',
    config = function()
        --Check this: vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
        vim.cmd([[
            autocmd VimEnter * FloatermNew --name=common --height=0.8 --width=0.8 --silent --autoclose=0
            nnoremap <silent> <C-t>   :FloatermToggle common<CR>
            tnoremap <silent> <C-t>   <C-\><C-n>:FloatermToggle common<CR>
        ]])
    end
}
