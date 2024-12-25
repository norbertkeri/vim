local overrides = {
    ["*"] = {
        FlashCurrent = { fg = "#FFFF20" },
        FlashLabel = { fg = "#EE3300" },
        FlashMatch = { fg = "#FFFFFF" },
    },
}

vim.api.nvim_create_autocmd({ "ColorScheme", "VimEnter" }, {
    group = vim.api.nvim_create_augroup('Color', {}),
    pattern = "*",
    callback = function()
        local scheme = vim.g.colors_name
        local override = overrides["*"]
        if overrides[scheme] then
            extend(override, overrides[scheme])
        end
        for group, colors in pairs(override) do
            vim.api.nvim_set_hl(0, group, colors)
        end
    end
})
