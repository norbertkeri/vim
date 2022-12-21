local M = {}

function M.merge_list(l1, l2)
    local result = {}
    for _i, e in ipairs(l1) do
        table.insert(result, e)
    end
    for _i, e in ipairs(l2) do
        table.insert(result, e)
    end
    return result
end

function M.map(func, array)
    local new_array = {}
    for i,v in ipairs(array) do
        new_array[i] = func(v)
    end
    return new_array
end

return M
