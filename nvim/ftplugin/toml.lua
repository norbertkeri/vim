if vim.fn.expand("%:t") == "Cargo.toml" then
    local crates = require("crates")
    local opts = { silent = true }

    vim.keymap.set("n", "<leader>g", crates.show_dependencies_popup, opts)
    vim.keymap.set("n", "<leader>h", crates.open_homepage, opts)
    vim.keymap.set("n", "<leader>d", crates.open_documentation, opts)
    vim.keymap.set("n", "<leader>r", crates.open_repository, opts)
    vim.keymap.set("n", "<leader>c", crates.open_crates_io, opts)
end
