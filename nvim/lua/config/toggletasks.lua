require('toggletasks').setup {
    telescope = {
        spawn = {
            show_running = true
        }
    }
}

require('telescope').load_extension('toggletasks')
vim.keymap.set('n', '<space>ts', require('telescope').extensions.toggletasks.spawn, { desc = 'toggletasks: spawn' })
