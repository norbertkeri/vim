local setup = function()
    require("nvim-treesitter.configs").setup({
        ensure_installed = {
            "rust",
            "css",
            "dockerfile",
            "yaml",
            "fish",
            "html",
            "javascript",
            "json",
            "python",
            "php",
            "scss",
            "toml",
            "typescript",
            "hcl",
            "lua",
            "markdown",
            "markdown_inline",
        },
        indent = {
            enable = true,
        },
        highlight = {
            enable = true,
            -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
            -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
            -- Using this option may slow down your editor, and you may see some duplicate highlights.
            -- Instead of true it can also be a list of languages
            additional_vim_regex_highlighting = false,
        },
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = "<cr>",
                node_incremental = "<cr>",
                scope_incremental = "<tab>",
                node_decremental = "<S-tab>",
            },
        },
    })
end

return {
    { "nvim-treesitter/nvim-treesitter", config = setup, build = ":TSUpdate" },
    "nvim-treesitter/nvim-treesitter-context",
}
