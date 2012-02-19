runtime bundle/pathogen/autoload/pathogen.vim
filetype off
call pathogen#infect()
call pathogen#helptags()

runtime configs/general.vimrc
runtime configs/mappings.vimrc
runtime configs/functions.vimrc
runtime configs/plugins.vimrc

if has("gui_running")
    source ~/vault/Dropbox/Programming/vim/config/gui.vimrc
end

if has("win32") || has("win64")
    source ~/vault/Dropbox/Programming/vim/config/windows.vimrc
else
    source ~/vault/Dropbox/Programming/vim/config/linux.vimrc
end
