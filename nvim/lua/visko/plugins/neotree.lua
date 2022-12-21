return {
    'nvim-neo-tree/neo-tree.nvim',
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
    },
    config = function()
        vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])
        vim.api.nvim_set_keymap("n", "_", ":Neotree reveal float<cr>", { noremap = true })
        require("neo-tree").setup({
            source_selector = {
                winbar = true,
                statusline = true
            },
            close_if_last_window = true,
            popup_border_style = "NC",
            window = {
                popup = {
                    position = { col = "100%", row = "2" },
                    size = function(state)
                        local root_name = vim.fn.fnamemodify(state.path, ":~")
                        local root_len = string.len(root_name) + 4
                        return {
                            width = math.max(root_len, 50),
                            height = vim.o.lines - 6
                        }
                    end
                },
                mappings = {
                    ["o"] = { "open" },
                    ["u"] = { "navigate_up" },
                    ["P"] = { "toggle_preview", config = { use_float = false } },
                    ["s"] = "open_split",
                    ["v"] = "open_vsplit",
                    ["t"] = "open_tabnew",
                    --["P"] = "toggle_preview", -- enter preview mode, which shows the current node without focusing
                    ["c"] = "close_node",
                    ["C"] = "close_all_nodes",
                    --["Z"] = "expand_all_nodes",
                    ["a"] = { 
                        "add",
                        -- some commands may take optional config options, see `:h neo-tree-mappings` for details
                        config = {
                            show_path = "none" -- "none", "relative", "absolute"
                        }
                    },
                    ["A"] = "add_directory", -- also accepts the optional config.show_path option like "add".
                    ["d"] = "delete",
                    ["r"] = "rename",
                    ["y"] = "copy_to_clipboard",
                    ["x"] = "cut_to_clipboard",
                    ["p"] = "paste_from_clipboard",
                    ["m"] = "move", -- takes text input for destination, also accepts the optional config.show_path option like "add".
                    ["q"] = "close_window",
                    ["<esc>"] = "close_window",
                    ["R"] = "refresh",
                    ["?"] = "show_help",
                    ["<tab>"] = "next_source",
                }
            },
            filesystem = {
                filtered_items = {
                    always_show = {
                        ".gitignore"
                    },
                    never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
                    ".DS_Store",
                    "thumbs.db"
                },
                never_show_by_pattern = { -- uses glob style patterns
                "*.orig"
            },
            group_empty_dirs = false, -- when true, empty folders will be grouped together
            use_libuv_file_watcher = false, -- This will use the OS level file watchers to detect changes
        },
        window = {
            mappings = {
                ["gn"] = "prev_git_modified",
                ["gp"] = "next_git_modified",
            }
        }
    }
})

end
}
