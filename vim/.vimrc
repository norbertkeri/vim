let mapleader = " "
call plug#begin('~/.vimrepository/plugged')
runtime configs/plugins.vimrc
call plug#end()

runtime configs/local.vimrc
runtime configs/general.vimrc
runtime configs/mappings.vimrc
runtime configs/functions.vimrc
"runtime configs/coc.vimrc
runtime configs/lsp.vimrc
runtime configs/snippets.vimrc
if get(g:, "is_colemak", 0)
    runtime configs/colemak.vim
end

if has("gui_running")
    runtime configs/gui.vimrc
end

autocmd VimEnter * FloatermNew --name=common --height=0.8 --width=0.8 --silent --autoclose=0
"Check this: vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
