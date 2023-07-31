local _ = require("visko.helpers")

local active_lsps = function()
    local clients = vim.lsp.get_active_clients()
    local result = _.map(clients, function(e)
        return e['name']
    end)
    return table.concat(result, ", ")
end

return {
    'nvim-lualine/lualine.nvim',
    config = function()
        local navic = require("nvim-navic")
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
            sections = {
                lualine_a = { 'mode' },
                lualine_b = { 'branch', 'diff', 'diagnostics' },
                lualine_c = {
                     { function()
                            return navic.get_location()
                        end,
                        cond = function()
                            return navic.is_available()
                        end
                    },
                 },
                lualine_x = {active_lsps, 'encoding', 'fileformat', 'location'},
                lualine_y = {'filetype'},
                lualine_z = {'progress'}
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = {'filename'},
                lualine_x = {'location'},
                lualine_y = {},
                lualine_z = {}
            },
            extensions = {}
        }
    end
}

