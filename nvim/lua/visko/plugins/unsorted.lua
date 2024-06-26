local _ = require("visko.helpers")

local plugins = {
    { 'lewis6991/gitsigns.nvim', opts = {} },
    {
        'MagicDuck/grug-far.nvim',
        config = function()
            local grug = require('grug-far');
            local opts = { prefills = { flags = '--smart-case' } };

            vim.keymap.set('n', '<leader>F', function() grug.grug_far() end);
            vim.keymap.set('n', '!', function() grug.grug_far({ startInInsertMode = false, prefills = { search = vim.fn.expand("<cword>") } }) end);
            vim.keymap.set('v', '!', function() grug.with_visual_selection({ startInInsertMode = false }) end);
            grug.setup(opts);
        end
    },
    { 'folke/trouble.nvim',
        opts = {
            auto_preview = false,
            focus = true,
            multiline = false,
            modes = {
                diagnostics = {
                    groups = {
                        { "filename", format = "{file_icon} {basename:Title} {count}" },
                    },
                },
            },

        }
    },
    { 'eldritch-theme/eldritch.nvim', opts = {} },
    { 'j-hui/fidget.nvim',
        opts = {}
    },
    { 'kylechui/nvim-surround', opts = {
        keymaps = {
            insert = "<C-s>",
            insert_line = "<C-S>",
            normal = "yS",
            normal_cur = "ySc",
            normal_line = "ySl",
            normal_cur_line = "ySL",
            visual = "S",
            visual_line = "gS",
            delete = "dS",
            change = "cS",
            change_line = "<nop>",
        },
    } },
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        opts = {
            modes = {
                char = {
                    highlight = { backdrop = false }
                }
            }
        },
        keys = {
            { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
            --{ "S", mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
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
