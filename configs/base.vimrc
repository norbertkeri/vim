" Use this for a local .vimrc:
"
"filetype off
"call pathogen#infect()
"call pathogen#helptags()
"source ~/Dropbox/Programming/vim/config/base.vimrc

source general.vimrc
source mappings.vimrc
source functions.vimrc
source plugins.vimrc

if has("win32") || has("win64")
    source ~/Dropbox/Programming/vim/config/windows.vimrc
else
    source ~/Dropbox/Programming/vim/config/linux.vimrc
end
