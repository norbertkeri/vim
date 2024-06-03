local _ = require("visko.helpers")

local symbols = {
    modified = '  ',
    -- readonly = '[-]',      -- Text to show when the file is non-modifiable or readonly.
    -- unnamed = '[No Name]', -- Text to show for unnamed buffers.
    -- newfile = '[New]',     -- Text to show for newly created file before first write
}

local active_lsps = function()
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    local result = _.map(clients, function(e)
        return e['name']
    end)
    return table.concat(result, ", ")
end

local filename_section = {
    'filename',
    file_status = true,      -- Displays file status (readonly status, modified status)
    newfile_status = false,  -- Display new file status (new file means no write after created)
    path = 1,
    shorting_target = 40,    -- Shortens path to leave 40 spaces in the window
    -- for other components. (terrible name, any suggestions?)
    symbols = symbols
}

local tabs_section = {
    'tabs',
    mode = 0,
    use_mode_colors = true,
    symbols = symbols
}

local navic_info = {
    function()
        local navic = require("nvim-navic")
        return navic.get_location()
    end,
    cond = function()
        local navic = require("nvim-navic")
        return navic.is_available()
    end
}

local mydiag = {
    function()
        local diags = vim.diagnostic.get(nil, { severity = { min = vim.diagnostic.severity.HINT } })
        local warning = 0
        local info = 0
        local hint = 0
        local error = 0
        for _, v in ipairs(diags) do
            if v.severity == vim.diagnostic.severity.HINT then
                hint = hint + 1
            elseif v.severity == vim.diagnostic.severity.INFO then
                info = info + 1
            elseif v.severity == vim.diagnostic.severity.WARN then
                warning = warning + 1
            elseif v.severity == vim.diagnostic.severity.ERROR then
                error = error + 1
            end
        end
        return string.format("E: %d W: %d I: %d H: %d", error, warning, info, hint)
    end,
    cond = function()
        return true
    end
}

local winbar_sections = {
    lualine_a = {filename_section},
    lualine_b = {'diagnostics', 'searchcount'},
    lualine_c = {navic_info},
    lualine_x = {active_lsps, 'encoding'},
    lualine_y = {{'filetype', icon_only = true}},
    lualine_z = {}
}

local inactive_winbar_sections = vim.tbl_extend('force', winbar_sections, {
    lualine_c = {},
})

return {
    'nvim-lualine/lualine.nvim',
    config = function()
        vim.opt.showtabline = 0
        require('lualine').setup {
            options = {
                icons_enabled = true,
                theme = 'auto',
                component_separators = { left = '', right = ''},
                section_separators = { left = '', right = ''},
                disabled_filetypes = {},
                always_divide_middle = true,
                globalstatus = true,
            },
            tabline = {},
            sections = {
                lualine_a = { tabs_section },
                lualine_b = { 'branch' }, -- diff
                lualine_c = {},
                lualine_x = {},
                lualine_y = {'location'},
                lualine_z = {'progress'},
            },
            winbar = winbar_sections,
            inactive_winbar = inactive_winbar_sections,
            extensions = {}
        }
    end,

}

