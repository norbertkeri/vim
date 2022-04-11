set runtimepath^=~/.vimrepository/vim runtimepath+=~/.vimrepository/vim/after
let &packpath = &runtimepath
source ~/.vimrepository/vim/.vimrc
lua require('config')
