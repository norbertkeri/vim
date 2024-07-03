local M = {}

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

return M
