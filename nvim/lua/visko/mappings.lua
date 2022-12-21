vim.keymap.set('n', '<S-q>', ':tabclose<cr>')
vim.keymap.set('n', '<a-q>', ':tabclose<cr>')
vim.keymap.set('n', '<leader>q', ':tabonly<cr>')
vim.keymap.set('n', '/', '/\\v')

-- Moving between windows
vim.keymap.set('n', '<C-l>', '<C-w>l')
vim.keymap.set('n', '<C-j>', '<C-w>j')
vim.keymap.set('n', '<C-k>', '<C-w>k')
vim.keymap.set('n', '<C-h>', '<C-w>h')

-- Same, but for colemak
vim.keymap.set('n', '<a-m>', '<c-w>h')
vim.keymap.set('n', '<a-n>', '<c-w>j')
vim.keymap.set('n', '<a-e>', '<c-w>k')
vim.keymap.set('n', '<a-i>', '<c-w>l')
vim.keymap.set('n', '<a-t>', ':close<cr>')

vim.keymap.set('n', '<tab>', ':tabnext<cr>')
vim.keymap.set('n', '<S-tab>', ':tabprev<cr>')

vim.keymap.set('n', '<C-c>', "+yy")
vim.keymap.set('n', '<C-S-c>', "*yy")
vim.keymap.set('n', '<C-v>', '"+p')
vim.keymap.set('n', '<C-S-v>', '"*p')

vim.keymap.set('v', '<C-c>', "+y")
vim.keymap.set('v', '<C-S-c>', "*y")

-- Move lines in visual with shift-j and shift-k
vim.keymap.set('v', '<s-J>', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', '<s-K>', ":m '<-2<CR>gv=gv")
vim.keymap.set('v', '<s-N>', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', '<s-E>', ":m '<-2<CR>gv=gv")

--[[
nmap <F2> :tabnew ~/.vimrepository/vim/configs/plugins.vimrc<cr>
nmap <F3> :tabnew ~/.vimrepository/vim/configs/local.vimrc<cr>
nmap <F4> :tabnew ~/.vimrepository/nvim/lua/config/init.lua<cr>

]]--
