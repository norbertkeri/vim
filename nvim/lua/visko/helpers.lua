local M = {
    vim = {},
}

function M.merge_list(l1, l2)
    local result = {}
    for _, e in ipairs(l1) do
        table.insert(result, e)
    end
    for _, e in ipairs(l2) do
        table.insert(result, e)
    end
    return result
end

function M.map(array, func)
    local new_array = {}
    for i, v in ipairs(array) do
        new_array[i] = func(v)
    end
    return new_array
end

function M.any(array, predicate)
    for _, v in ipairs(array) do
        if predicate(v) then
            return v
        end
    end
end

function M.vim.mapkey(mode, lhs, rhs, desc, opts)
    opts = opts or {}
    if opts.silent ~= nil then
        opts.silent = true
    end
    opts.desc = desc
    vim.keymap.set(mode, lhs, rhs, opts)
end

function M.vim.create_bufmap(bufnr)
    return function(mode, lhs, rhs, desc, opts)
        opts = opts or {}
        opts.buffer = bufnr
        M.vim.mapkey(mode, lhs, rhs, desc, opts)
    end
end

function M.in_table(needle, haystack)
    for _, v in pairs(haystack) do
        if v == needle then
            return true
        end
    end
    return false
end

return M
