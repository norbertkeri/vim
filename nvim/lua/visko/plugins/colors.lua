local catppuccin = function()
    local c = require("catppuccin")
    vim.g.catppuccin_flavour = "mocha"
    c.setup({
        transparent_background = false,
        term_colors = false,
        integrations = {
            treesitter = true,
            native_lsp = {
                enabled = true,
            },
            lsp_trouble = true,
            lsp_saga = false,
            gitgutter = false,
            gitsigns = true,
            telescope = true,
            nvimtree = {
                enabled = false,
                show_root = false,
            },
            which_key = false,
            indent_blankline = {
                enabled = false,
                colored_indent_levels = false,
            },
            dashboard = false,
            neogit = false,
            vim_sneak = false,
            fern = false,
            barbar = false,
            bufferline = false,
            markdown = false,
            lightspeed = false,
            ts_rainbow = false,
            hop = false,
        },
    })

end


return {
    'challenger-deep-theme/vim',
    'maxmx03/fluoromachine.nvim',
    'ayu-theme/ayu-vim',
    'jaredgorski/spacecamp',
    'trapd00r/neverland-vim-theme',
    'morhetz/gruvbox',
    'drewtempelmeyer/palenight.vim',
    'folke/tokyonight.nvim',
    { 'catppuccin/nvim', config = catppuccin },
    'devnnys/spaceodyssey.nvim',
    'rebelot/kanagawa.nvim',
    { "diegoulloao/neofusion.nvim", priority = 1000 , config = true, opts = {} },
    {
        'EdenEast/nightfox.nvim',
        config = function()
            require('nightfox').setup({
                options = {
                    modules = {
                        cmp = true,
                        diagnostic = {
                            enable = true
                        },
                        fidget = true,
                        gitsigns = true,
                        lsp_trouble = true,
                        telescope = true,
                        treesitter = true,
                        native_lsp = true,
                    }
                }
            })
        end
    },
    'marko-cerovac/material.nvim',
    'AlphaTechnolog/onedarker.nvim',
    'mhartington/oceanic-next'
}
