vim.g.mapleader = " "

vim.opt.number = true
vim.opt.foldenable = false
vim.opt.number = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- Use spaces instead of tabs
vim.opt.shiftwidth = 4
vim.opt.shiftround = true
vim.opt.expandtab = true
--vim.opt.tabstop = 4

vim.opt.wildmenu = true
vim.opt.wildmode = "list:longest"
vim.opt.wildignore:append {"*.a", "*.o", "*.bmp", "*.png", "*.gif", "*.jpg", "*.jpeg", ".git", ".hg", ".svn", "*~", "*.swp", "*.tmp", "*/.git/*", "*/.hg/*", "*/.svn/*", "app/cache/*", "app/logs", ".sass-cache", "node_modules", "web/built/*" }

-- Search related stuff
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.laststatus = 2
vim.opt.modeline = true
vim.opt.background = "dark"
--set visualbell
--set noerrorbells
--set backspace=indent,eol,start
--set encoding=utf-8
--set showcmd
--set showmatch
vim.opt.hidden = true
vim.opt.fillchars = { vert = "│", fold = "-", eob = " " }

vim.opt.swapfile = false

-- We have global undo, no need for backup files
vim.opt.backup = false

-- Number of history items to keep for commands
vim.opt.history = 1000

-- Do not put double spaces after .?! when joining lines
vim.opt.joinspaces = false

-- Mark trailing whitespace
vim.opt.list = true

-- There is some weird behaviour if I try to use vim.opt.listchars
vim.cmd([[set listchars=tab:»\ ,extends:›,precedes:‹,nbsp:·,trail:·]])

-- If a vim window is resized by the window manager, resize all splits
vim.api.nvim_create_autocmd("VimResized", { pattern = "*", command = "wincmd =" })

-- Remove the comment marker when joining lines that are comments
vim.opt.formatoptions:append("j")

-- Nice colors
vim.opt.termguicolors = true

-- Always have at least N lines at the bottom when scrolling
vim.opt.scrolloff = 10

-- Always show the sign column
vim.opt.signcolumn = "yes"

-- no idea?
vim.opt.updatetime = 300

vim.opt.diffopt:append("internal,algorithm:patience")

vim.g.markdown_fenced_languages = { 'rust', 'yaml', 'python', 'bash=sh', 'php', 'lua' }
vim.g.vim_markdown_conceal = 1

-- Map c-x c-b to autocomplete the list of open buffers
vim.cmd([[
inoremap <c-x><c-b> <c-r>=ListBuffers()<cr>
function! ListBuffers()
  let buffers = getbufinfo({'buflisted': 1, 'bufloaded': 1})
  let bufnames = map(map(buffers, 'v:val.name'), 'substitute(v:val, getcwd(), "", "")')
  call complete(col('.'), bufnames)
  return ''
endfunction
]])

-- Automatically create directories on save
vim.cmd([[
fun! AutoMakeDirectory()

    let s:directory = expand("<afile>:p:h")

    if !isdirectory(s:directory)
        call mkdir(s:directory, "p")
    endif

endfun

autocmd BufWritePre,FileWritePre * :call AutoMakeDirectory()
]])
