local _ = require("visko.helpers")
local plugins = {
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {
            preset = "modern",
            keys = {
                scroll_up = "<c-b>",
                scroll_down = "<c-f>",
            },
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        },
        keys = {
            {
                "<leader>?",
                function()
                    require("which-key").show({ global = false })
                end,
                desc = "Buffer Local Keymaps (which-key)",
            },
        },
    },
    {
        "lewis6991/gitsigns.nvim",
        opts = {
            on_attach = function(bufnr)
                local gs = package.loaded.gitsigns
                local wk = package.loaded["which-key"]
                local map = require("visko.helpers").vim.create_bufmap(bufnr)
                wk.add({
                    {
                        "<leader>D",
                        desc = "Diff hunk related movement",
                        group = "gitsigns",
                        mode = "n",
                        buffer = bufnr,
                    },
                    { "D", desc = "Diff hunk related movement", group = "gitsigns", mode = "o", buffer = bufnr },
                })
                map("n", "<leader>Dj", gs.next_hunk, "Next hunk")
                map("n", "<leader>Dk", gs.prev_hunk, "Prev hunk")
                map("o", "Dj", gs.prev_hunk, "Next hunk")
                map("o", "Dk", gs.prev_hunk, "Prev hunk")
            end,
        },
    },
    {
        "MagicDuck/grug-far.nvim",
        config = function()
            local grug = require("grug-far")
            local opts = { prefills = { flags = "--smart-case" } }
            grug.setup(opts)

            local map = require("visko.helpers").vim.mapkey

            map("n", "<leader>F", function()
                grug.grug_far()
            end, "Grug far")
            map("n", "!",
                function() grug.grug_far({ startInInsertMode = false, prefills = { search = vim.fn.expand("<cword>") } }) end,
                "Grug far current word")
            map("v", "!", function()
                grug.with_visual_selection({ startInInsertMode = false })
            end, "Grug far current selection")
        end,
    },
    {
        "folke/trouble.nvim",
        opts = {
            auto_preview = false,
            focus = true,
            multiline = false,
            modes = {
                lsp_references = {
                    auto_refresh = false,
                    params = {
                        include_declaration = false,
                    },
                },
                diagnostics = {
                    groups = {},
                    format = "{severity_icon} {filename} {message:md} {item.source} {code} {pos}",
                },
                cascade = {
                    mode = "diagnostics", -- inherit from diagnostics mode
                    filter = function(items)
                        local severity = vim.diagnostic.severity.HINT
                        for _, item in ipairs(items) do
                            severity = math.min(severity, item.severity)
                        end
                        return vim.tbl_filter(function(item)
                            return item.severity == severity
                        end, items)
                    end,
                },
            },
        },
    },
    { "eldritch-theme/eldritch.nvim", opts = {} },
    { "j-hui/fidget.nvim", opts = {} },
    {
        "kylechui/nvim-surround",
        opts = {
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
        },
    },
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        opts = {
            modes = {
                char = {
                    highlight = { backdrop = false },
                },
            },
        },
        keys = {
            {
                "s",
                mode = { "n", "x", "o" },
                function()
                    require("flash").jump()
                end,
                desc = "Flash",
            },
            --{ "S", mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
            {
                "r",
                mode = "o",
                function()
                    require("flash").remote()
                end,
                desc = "Remote Flash",
            },
            {
                "R",
                mode = { "o", "x" },
                function()
                    require("flash").treesitter_search()
                end,
                desc = "Treesitter Search",
            },
            {
                "<c-s>",
                mode = { "c" },
                function()
                    require("flash").toggle()
                end,
                desc = "Toggle Flash Search",
            },
        },
    },
    {
        "saecki/crates.nvim",
        tag = "v0.3.0",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {},
    },
    {
        "mg979/vim-visual-multi",
        branch = "master",
        config = function()
            vim.g.VM_maps = {
                ["Skip Region"] = "s",
                ["Undo"] = "u",
                ["Redo"] = "<C-r>",
            }

            local map = require("visko.helpers").vim.mapkey
            map("n", "<C-S-k>", "<Plug>(VM-Add-Cursor-Up)", "Add mutlticursor up")
            map("n", "<C-S-j>", "<Plug>(VM-Add-Cursor-Down)", "Add multicursor down")
        end,
    },
    "folke/neodev.nvim",
    { "echasnovski/mini.ai", opts = {} },
    "mbbill/undotree",
    {
        "norcalli/nvim-colorizer.lua",
        config = function()
            require("colorizer").setup({ "*" }, {
                rgb_fn = true,
            })
        end,
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
    {
        "gbprod/yanky.nvim",
        config = function()
            local actions = require("telescope.actions")
            local mapping = require("yanky.telescope.mapping")
            local map = require("visko.helpers").vim.mapkey
            require("yanky").setup({
                ring = {
                    storage = "memory",
                    cancel_event = "move",
                },
                system_clipboard = {
                    sync_with_ring = false,
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
                                ["<c-p>"] = actions.nop,
                            },
                        },
                    },
                },
            })
            map({ "n", "x" }, "p", "<Plug>(YankyPutAfter)", "Put")
            map({ "n", "x" }, "P", "<Plug>(YankyPutBefore)", "Put before")
            map("n", "<leader>P", ":Telescope yank_history<cr>", "Telescope yank history")
            map("n", "<leader>p", "<Plug>(YankyCycleForward)", "Put next")
            map("n", "<leader>n", "<Plug>(YankyCycleBackward)", "Put prev")
            map({ "n", "x" }, "y", "<Plug>(YankyYank)", "Yank") -- do not go back to the start of the yanked text
        end,
    },
    {
        "stevearc/conform.nvim",
        opts = {
            format_on_save = {
                -- These options will be passed to conform.format()
                timeout_ms = 500,
                lsp_format = "fallback",
            },
            formatters_by_ft = {
                lua = { "stylua" },
            },
        },
    },
    {
        "otavioschwanck/arrow.nvim",
        opts = {
            show_icons = true,
            leader_key = "<f2>", -- Recommended to be a single key
            buffer_leader_key = "<f3>", -- Per Buffer Mappings
            global_bookmarks = true,
            mappings = {
                open_horizontal = "s",
            },
        },
    },
}

return plugins
