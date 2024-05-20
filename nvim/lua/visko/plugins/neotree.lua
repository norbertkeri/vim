return {
    'nvim-neo-tree/neo-tree.nvim',
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
    },
    config = function()
        vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])
        vim.api.nvim_set_keymap("n", "_", ":Neotree float reveal_force_cwd<cr>", { noremap = true })
        require("neo-tree").setup({
            use_default_mappings = false,
            source_selector = {
                winbar = true,
                statusline = true
            },
            close_if_last_window = true,
            popup_border_style = "rounded",
            git_status = {
            window = {
                    position = "float",
                    mappings = {
                        ["A"]  = "git_add_all",
                        ["u"] = "git_unstage_file",
                        ["a"] = "git_add_file",
                        ["r"] = "git_revert_file",
                        ["c"] = "git_commit",
                    }
                }
            },
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
                    ["<cr>"] = { "open" },
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
                    ["_"] = "close_window",
                    ["<esc>"] = "close_window",
                    ["R"] = "refresh",
                    ["?"] = "show_help",
                    ["<tab>"] = "next_source",
                    ["O"] = { "show_help", nowait=false, config = { title = "Order by", prefix_key = "O" }},
                    ["Oc"] = { "order_by_created", nowait = false },
                    ["Od"] = { "order_by_diagnostics", nowait = false },
                    ["Og"] = { "order_by_git_status", nowait = false },
                    ["Om"] = { "order_by_modified", nowait = false },
                    ["On"] = { "order_by_name", nowait = false },
                    ["Os"] = { "order_by_size", nowait = false },
                    ["Ot"] = { "order_by_type", nowait = false },
                }
            },
            filesystem = {
                bind_to_cwd = false,
                commands = {
                    drag_and_drop = function(state)
                        local node = state.tree:get_node()
                        local path = node:get_id()
                        -- Linux: open file in default application
                        vim.api.nvim_command(string.format("silent !dragon-drop -T -x '%s'", path))
                    end,
                },
                filtered_items = {
                    always_show = {
                        ".gitignore"
                    },
                    hide_dotfiles = false,
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
                        ["<c-d>"] = "drag_and_drop",
                    }
                }
            }
        })
    end
}
