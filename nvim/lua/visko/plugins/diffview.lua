return {
    {
        "sindrets/diffview.nvim",
        cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local actions = require("diffview.actions")
            require("diffview").setup({
                diff_binaries = false,
                enhanced_diff_hl = true,
                use_icons = true,
                keymaps = {
                    view = {
                        -- keep tab as tabnext instead of jumping to next file
                        ["<tab>"] = false,
                        ["<leader>d"] = actions.cycle_layout,
                        ["h"] = function()
                            vim.cmd("DiffviewFileHistory %")
                        end,
                    },
                },
                hooks = {
                    diff_buf_read = function(bufnr)
                        vim.cmd("norm! zi")
                    end,
                    diff_buf_win_enter = function(bufnr)
                        vim.opt_local.foldlevel = 99
                        vim.opt_local.foldenable = false
                        vim.cmd("norm! zi")
                    end,
                },
            })
        end,
    },
}
