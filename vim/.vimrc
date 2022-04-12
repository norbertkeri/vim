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
if get(g:, "is_colemak", 0)
    runtime configs/colemak.vim
end

if has("gui_running")
    runtime configs/gui.vimrc
end
