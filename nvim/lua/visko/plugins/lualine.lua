local _ = require("visko.helpers")

local symbols = {
    modified = "  ",
    -- readonly = '[-]',      -- Text to show when the file is non-modifiable or readonly.
    -- unnamed = '[No Name]', -- Text to show for unnamed buffers.
    -- newfile = '[New]',     -- Text to show for newly created file before first write
}

local active_lsps = function()
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    local result = _.map(clients, function(e)
        return e["name"]
    end)
    return table.concat(result, ", ")
end

local ruler = function()
    local sbar = { '🭶', '🭷', '🭸', '🭹', '🭺', '🭻' }
    local curr_line = vim.api.nvim_win_get_cursor(0)[1]
    local lines = vim.api.nvim_buf_line_count(0)
    local i = math.floor((curr_line - 1) / lines * #sbar) + 1
    return string.rep(sbar[i], 2)
end

local filename_section = {
    "filename",
    file_status = true,     -- Displays file status (readonly status, modified status)
    newfile_status = false, -- Display new file status (new file means no write after created)
    path = 1,
    shorting_target = 40,   -- Shortens path to leave 40 spaces in the window
    -- for other components. (terrible name, any suggestions?)
    symbols = symbols,
}

local tabs_section = {
    "tabs",
    mode = 1,
    path = 0,
    use_mode_colors = true,
    symbols = symbols,

    fmt = function(name, context)
        local buflist = vim.fn.tabpagebuflist(context.tabnr)
        local result = {}

        for k, bufid in pairs(buflist) do
            name = vim.fs.basename(vim.fn.bufname(bufid))
            if string.len(name) > 0 then
                table.insert(result, name)
            end
        end

        if #result == 0 then
            return "[No name]"
        end

        return table.concat(result, " | ")
    end
}

local navic_info = {
    function()
        local navic = require("nvim-navic")
        return navic.get_location()
    end,
    cond = function()
        local navic = require("nvim-navic")
        return navic.is_available()
    end,
}

local winbar_sections = {
    lualine_a = { filename_section },
    lualine_b = { "diagnostics", "searchcount" },
    lualine_c = { navic_info },
    lualine_x = { active_lsps, "encoding" },
    lualine_y = { { "filetype", icon_only = true } },
    lualine_z = {},
}

local inactive_winbar_sections = vim.tbl_extend("force", winbar_sections, {
    lualine_c = {},
})

local project_root = function()
    local dot_git_path = vim.fn.finddir(".git", ".;")
    if dot_git_path ~= "" then
        return vim.fn.fnamemodify(dot_git_path, ":p:h:h:t")
    end
end

return {
    "nvim-lualine/lualine.nvim",
    config = function()
        vim.opt.showtabline = 0
        local arrow = require("arrow.statusline")
        require("lualine").setup({
            options = {
                icons_enabled = true,
                theme = "tokyonight",
                component_separators = { left = "", right = "" },
                section_separators = { left = "", right = "" },
                disabled_filetypes = {},
                always_divide_middle = true,
                globalstatus = true,
            },
            tabline = {},
            sections = {
                lualine_a = { tabs_section },
                lualine_b = {
                    "branch",
                    function()
                        return arrow.text_for_statusline_with_icons()
                    end,
                },
                lualine_c = {},
                lualine_x = {},
                lualine_y = { "location", ruler },
                lualine_z = { "progress", project_root },
            },
            winbar = winbar_sections,
            inactive_winbar = inactive_winbar_sections,
            extensions = {},
        })
    end,
}
