local _ = require("visko.helpers")

local plugins = {
    { 'lewis6991/gitsigns.nvim', opts = {} },
    { 'folke/trouble.nvim', opts = {} },
    { 'numToStr/Comment.nvim', opts = {} },
    { 'j-hui/fidget.nvim',
        opts = {}
    },
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        opts = {
            modes = {
                char = {
                    autohide = true,
                    -- multi_line = false,
                    highlight = { backdrop = false }
                }
            }
        },
        keys = {
            { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
            { "S", mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
            { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
            { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
            { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
        },
    },
    {
        'saecki/crates.nvim',
        tag = 'v0.3.0',
        dependencies = { 'nvim-lua/plenary.nvim' },
        opts = {}
    },
    {
        'dyng/ctrlsf.vim',
        config = function()
            -- Autofocus
            vim.g.ctrlsf_auto_focus = { at = "start" }

            vim.g.ctrlsf_mapping = {next = "n", prev = "N", vsplit = "v", split = "s", open = {"<cr>", "o"}, popen = "p", quit = "q"}

            -- Search regexes by default
            vim.g.ctrlsf_regex_pattern = 1
            -- Only indent two lines, instead of 4 in search results
            vim.g.ctrlsf_indent = 2
            vim.keymap.set('n', '<leader>F', '<Plug>CtrlSFPrompt')
            vim.keymap.set('n', '!', '<Plug>CtrlSFCwordExec')
            vim.keymap.set('v', '!', '<Plug>CtrlSFVwordExec')
        end
    },
    {
        'mg979/vim-visual-multi',
        branch = 'master',
        config = function()
            vim.g.VM_maps = {
                ["Skip Region"] = "s",
                ["Undo"] = 'u',
                ["Redo"] = '<C-r>',
            }
            vim.keymap.set('n', '<C-S-j>', '<Plug>(VM-Add-Cursor-Down)')
            vim.keymap.set('n', '<C-S-k>', '<Plug>(VM-Add-Cursor-Up)')
        end
    },
    'folke/neodev.nvim',
    'wellle/targets.vim',
    'mbbill/undotree',
    {
        'norcalli/nvim-colorizer.lua',
        config = function ()
            require('colorizer').setup({'*'}, {
                rgb_fn = true
            })
        end
    },
    {
        "Bryley/neoai.nvim",
        dependencies = {
            "MunifTanjim/nui.nvim",
        },
        cmd = {
            "NeoAI",
            "NeoAIOpen",
            "NeoAIClose",
            "NeoAIToggle",
            "NeoAIContext",
            "NeoAIContextOpen",
            "NeoAIContextClose",
            "NeoAIInject",
            "NeoAIInjectCode",
            "NeoAIInjectContext",
            "NeoAIInjectContextCode",
        },
        keys = {
            { "<leader>as", desc = "summarize text" },
            { "<leader>ag", desc = "generate git message" },
        },
        config = function()
            require("neoai").setup({
                -- Options go here
            })
        end,
    },
    { 'gbprod/yanky.nvim', config = function()
        local actions = require("telescope.actions");
        local mapping = require("yanky.telescope.mapping")
        require("yanky").setup({
            ring = {
                storage = "memory",
                cancel_event = "move"
            },
            system_clipboard = {
                sync_with_ring = false
            },
            highlight = {
                on_put = false,
                on_yank = false,
            },
            picker = {
                telescope = {
                    mappings = {

                        i = {
                            ["<c-j>"] = actions.move_selection_next,
                            ["<c-k>"] = actions.move_selection_previous,
                            ["<c-d>"] = mapping.delete(),
                            ["<c-p>"] = actions.nop
                        }
                    }
                }
            }
        })
        vim.keymap.set({"n","x"}, "p", "<Plug>(YankyPutAfter)")
        vim.keymap.set({"n","x"}, "P", "<Plug>(YankyPutBefore)")
        vim.keymap.set({"n","x"}, "gp", "<Plug>(YankyGPutAfter)")
        vim.keymap.set({"n","x"}, "gP", "<Plug>(YankyGPutBefore)")
        vim.keymap.set("n", "<leader>P", ":Telescope yank_history<cr>")
        vim.keymap.set("n", "<leader>p", "<Plug>(YankyCycleForward)")
        vim.keymap.set("n", "<leader>n", "<Plug>(YankyCycleBackward)")
        vim.keymap.set({"n","x"}, "y", "<Plug>(YankyYank)") -- do not go back to the start of the yanked text
    end },
}

return plugins
