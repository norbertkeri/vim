local _ = require("visko.helpers")

local plugins = {
    {
        "lewis6991/gitsigns.nvim",
        opts = {
            on_attach = function(bufnr)
                local gs = package.loaded.gitsigns
                local map = function(mode, lhs, rhs, opts)
                    opts = opts or {}
                    opts.buffer = bufnr
                    vim.keymap.set(mode, lhs, rhs, opts)
                end
                map("n", "<leader>J", gs.next_hunk)
                map("n", "<leader>K", gs.prev_hunk)
                map("o", "J", gs.prev_hunk)
                map("o", "K", gs.prev_hunk)
            end,
        },
    },
    {
        "MagicDuck/grug-far.nvim",
        config = function()
            local grug = require("grug-far")
            local opts = { prefills = { flags = "--smart-case" } }

            vim.keymap.set("n", "<leader>F", function()
                grug.grug_far()
            end)
            vim.keymap.set("n", "!", function()
                grug.grug_far({ startInInsertMode = false, prefills = { search = vim.fn.expand("<cword>") } })
            end)
            vim.keymap.set("v", "!", function()
                grug.with_visual_selection({ startInInsertMode = false })
            end)
            grug.setup(opts)
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
            vim.keymap.set("n", "<C-S-j>", "<Plug>(VM-Add-Cursor-Down)")
            vim.keymap.set("n", "<C-S-k>", "<Plug>(VM-Add-Cursor-Up)")
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
            vim.keymap.set({ "n", "x" }, "p", "<Plug>(YankyPutAfter)")
            vim.keymap.set({ "n", "x" }, "P", "<Plug>(YankyPutBefore)")
            vim.keymap.set({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)")
            vim.keymap.set({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)")
            vim.keymap.set("n", "<leader>P", ":Telescope yank_history<cr>")
            vim.keymap.set("n", "<leader>p", "<Plug>(YankyCycleForward)")
            vim.keymap.set("n", "<leader>n", "<Plug>(YankyCycleBackward)")
            vim.keymap.set({ "n", "x" }, "y", "<Plug>(YankyYank)") -- do not go back to the start of the yanked text
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
