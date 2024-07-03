return {
    {
        "nvim-telescope/telescope.nvim",
        config = function()
            local actions = require("telescope.actions")
            local telescope = require("telescope")
            telescope.setup({
                defaults = {
                    mappings = {
                        i = {
                            ["<esc>"] = actions.close,
                            ["<c-k>"] = actions.move_selection_previous,
                            ["<c-j>"] = actions.move_selection_next,
                            ["<c-s>"] = actions.file_split,
                        },
                    },
                    dynamic_preview_title = true,
                },
                extensions = {
                    ["ui-select"] = {
                        require("telescope.themes").get_dropdown({}),
                    },
                },
            })
            telescope.load_extension("fzf")
            telescope.load_extension("ui-select")
            telescope.load_extension("yank_history")

            local builtin = require("telescope.builtin")

            vim.keymap.set("n", "<leader>f", builtin.find_files)
            vim.keymap.set("n", "<leader>b", builtin.buffers)
            vim.keymap.set("n", "<leader>m", builtin.oldfiles)
        end,
    },
    {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
    },
    "nvim-telescope/telescope-ui-select.nvim",
}
