local _ = require("visko.helpers")
local plugins = {
    {
        "lewis6991/gitsigns.nvim",
        opts = {
            on_attach = function(bufnr)
                local gs = package.loaded.gitsigns
                local map = require("visko.helpers").vim.create_bufmap(bufnr)
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
            local opts = { transient = true, prefills = { flags = "--smart-case", filesFilter = "!*min.*\n!lazy-lock.json" } }
            grug.setup(opts)

            local map = require("visko.helpers").vim.mapkey

            map("n", "<leader>F", function()
                grug.open()
            end, "Grug far")
            map("n", "!",
                function() grug.open({ startInInsertMode = false, prefills = { search = vim.fn.expand("<cword>") } }) end,
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
    {
        "eldritch-theme/eldritch.nvim",
        opts = {}
    },
    {
        "j-hui/fidget.nvim",
        opts = {}
    },
    {
        "echasnovski/mini.surround",
        opts = {
            mappings = {
                add = 'Sa',            -- Add surrounding in Normal and Visual modes
                delete = 'Sd',         -- Delete surrounding
                find = 'Sf',           -- Find surrounding (to the right)
                find_left = 'SF',      -- Find surrounding (to the left)
                highlight = 'Sh',      -- Highlight surrounding
                replace = 'Sr',        -- Replace surrounding
                update_n_lineS = 'Sn', -- Update `n_lines`

                suffix_last = 'l',     -- Suffix to search with "prev" method
                suffix_next = 'n',     -- Suffix to search with "next" method
            },

            -- Number of lines within which surrounding is searched
            n_lines = 120,

            -- How to search for surrounding (first inside current line, then inside
            -- neighborhood). One of 'cover', 'cover_or_next', 'cover_or_prev',
            -- 'cover_or_nearest', 'next', 'prev', 'nearest'. For more details,
            -- see `:h MiniSurround.config`.
            search_method = 'cover_or_next',
        }
    },
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        opts = {
            label = {
                before = true,
                after = false,
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
        },
    },
    {
        "saecki/crates.nvim",
        tag = "stable",
        event = { "BufRead Cargo.toml" },
        config = function()
            require("crates").setup({
                completion = {
                    crates = {
                        enabled = true,
                        max_results = 8,
                        min_chars = 3
                    }
                },
                lsp = {
                    enabled = true,
                    on_attach = function(client, bufnr)
                        require("visko.lsp_mappings").setup_lsp_keymaps(client, bufnr)
                        require("visko.lsp_mappings").on_attach(client, bufnr)
                    end,
                    actions = true,
                    completion = true,
                    hover = true,
                }
            })
        end
    },
    {
        "brenton-leighton/multiple-cursors.nvim",
        version = "*", -- Use the latest tagged version
        opts = {},     -- This causes the plugin setup function to be called
        keys = {
            { "<C-S-j>", "<Cmd>MultipleCursorsAddDown<CR>",          mode = { "n", "x" }, desc = "Add cursor and move down" },
            { "<C-S-k>", "<Cmd>MultipleCursorsAddUp<CR>",            mode = { "n", "x" }, desc = "Add cursor and move up" },
            { "<C-n>",   "<Cmd>MultipleCursorsAddJumpNextMatch<CR>", mode = { "n", "x" }, desc = "Add cursor and jump to next cword" },
            { "<C-d>",   "<Cmd>MultipleCursorsJumpNextMatch<CR>",    mode = { "n", "x" }, desc = "Jump to next cword" },
        },
    },
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
        "gbprod/yanky.nvim",
        config = function()
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
            })
            map({ "n", "x" }, "p", "<Plug>(YankyPutAfter)", "Put")
            map({ "n", "x" }, "P", "<Plug>(YankyPutBefore)", "Put before")
            map("n", "<leader>p", "<Plug>(YankyCycleForward)", "Put next")
            map("n", "<leader>n", "<Plug>(YankyCycleBackward)", "Put prev")
            map({ "n", "x" }, "y", "<Plug>(YankyYank)", "Yank") -- do not go back to the start of the yanked text
        end,
    },
    {
        "otavioschwanck/arrow.nvim",
        opts = {
            show_icons = true,
            leader_key = "<f2>",
            buffer_leader_key = "<f3>",
            global_bookmarks = true,
            mappings = {
                open_horizontal = "s",
            },
        },
    },
    {
        "NeogitOrg/neogit",
        dependencies = {
            "nvim-lua/plenary.nvim",  -- required
            "sindrets/diffview.nvim", -- optional - Diff integration
            "ibhagwan/fzf-lua"
        },
        config = true
    },
    {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
            library = {
                "LazyVim",
                -- See the configuration section for more details
                -- Load luvit types when the `vim.uv` word is found
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
    }
}

return plugins
