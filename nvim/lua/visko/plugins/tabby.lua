local H = require('visko.helpers')

local config = function()
    local api = require('tabby.module.api')
    local buf_name = require('tabby.feature.buf_name')
    local tabline  = require('tabby.tabline')
    vim.opt.showtabline = 2
    tabline.set(function(line)
        local theme = {
            fill = 'TabLineFill',
            -- Also you can do this: fill = { fg='#f2e9de', bg='#907aa9', style='italic' }
            head = 'TabLine',
            -- current_tab = 'TabLineSel',
            current_tab = { fg = '#F8FBF6', bg = '#896a98', style = 'italic' },
            tab = 'TabLine',
            win = 'TabLine',
            tail = 'TabLine',
        }
        local windows_in_tab = (function()
            local wins = line.wins_in_tab(line.api.get_current_tab())
            if #wins.wins > 1 then
                return wins.foreach(function(win)
                    return {
                        line.sep('', theme.win, theme.fill),
                        win.is_current() and '' or '',
                        win.buf_name(),
                        line.sep('', theme.win, theme.fill),
                        hl = theme.win,
                        margin = ' ',
                    }
                end)
            end
            return ''
        end)()
        return {
            {
                { '  ', hl = theme.head },
                line.sep('', theme.head, theme.fill),
            },
            line.tabs().foreach(function(tab)
                local hl = tab.is_current() and theme.current_tab or theme.tab
                local modified = H.any(tab.wins().wins, function(w)
                    local bufid = w.buf().id
                    return vim.api.nvim_buf_get_option(bufid, 'modified')
                end) or false
                return {
                    line.sep('', hl, theme.fill),
                    --tab.is_current() and '' or '',
                    --tab.number(),
                    tab.name(),
                    modified and '' or '',
                    -- tab.close_btn(''), -- show a close button
                    line.sep('', hl, theme.fill),
                    hl = hl,
                    margin = ' ',
                }
            end),
            line.spacer(),
            -- shows list of windows in tab
            windows_in_tab,
            hl = theme.fill,
        }
    end, {
            tab_name = {
                name_fallback = function(tabid)
                    local wins = api.get_tab_wins(tabid)
                    local cur_win = api.get_tab_current_win(tabid)
                    local name = ''
                    if api.is_float_win(cur_win) then
                        name = '[Floating]'
                    else
                        name = buf_name.get(cur_win)
                    end
                    if #wins > 1 then
                        name = string.format('%s [%d]', name, #wins)
                    end
                    return name
                end
            },
        })
end

return {
    'nanozuki/tabby.nvim',
    config = config
}
