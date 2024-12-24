return {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        local fzflua = require('fzf-lua')
        local actions = fzflua.actions
        vim.keymap.set("n", "<leader>f", fzflua.files, { desc = "Open FzfLua files" })
        vim.keymap.set("n", "<leader>b", fzflua.buffers, { desc = "Open FzfLua buffers" })
        vim.keymap.set("n", "<leader>m", fzflua.oldfiles, { desc = "Open FzfLua MRU files" })
        vim.keymap.set("i", "<c-x><c-f>", function()
            fzflua.complete_path()
        end
        , { desc = "Complete a path in insert mode" })

        fzflua.register_ui_select(function(_, items)
            local min_h, max_h = 0.15, 0.70
            local h = (#items + 4) / vim.o.lines
            if h < min_h then
                h = min_h
            elseif h > max_h then
                h = max_h
            end
            return { winopts = { height = h, width = 0.60, row = 0.40 } }
        end)

        fzflua.setup({
            actions = {
                files = {
                    ["default"] = actions.file_edit,
                    ["ctrl-s"]  = actions.file_split,
                    ["ctrl-v"]  = actions.file_vsplit,
                    ["ctrl-t"]  = actions.file_tabedit,
                    ["ctrl-q"]  = actions.file_sel_to_qf,
                },
            },
            winopts = {
                backdrop = 20,
                -- preview = { default = 'bat_native' }
            },
            files = {
                git_icons = false,
            }
        })
    end
}
