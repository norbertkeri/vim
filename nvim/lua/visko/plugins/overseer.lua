return {
    'stevearc/overseer.nvim',
    config = function()
        local overseer = require("overseer")
        overseer.setup({
            task_list = {
                bindings = {
                    ["q"] = "<c-w>q"
                }
            }
        })
        vim.keymap.set("n", "<leader>oo", overseer.toggle)
        vim.keymap.set("n", "<leader>or", overseer.run_template)
        overseer.load_template("tasks")
    end
}
