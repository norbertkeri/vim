local cargo_toml_exists = function()
    local f = io.open(vim.fn.getcwd() .. "/Cargo.toml")
    if f ~= nil then
        return true
    end
    return false
end

local has_package = function(package)
    local f = io.open(vim.fn.getcwd() .. "/Cargo.toml")
    if f ~= nil then
        local contents = f:read("*a")
        if contents:find(package) then
            return true
        end
    end
    return false
end

local sqlx = {
    name = "Recreate database",
    desc = "sqlx:database:reset",
    params = {},
    condition = {
        callback = function(search)
            return has_package("sqlx")
        end
    },
    builder = function()
        return {
            cmd = {"sqlx"},
            args = {"database", "reset", "-y"},
        }
    end,
}

local cargofix = {
    name = "Cargo fix",
    desc = "cargo:fix",
    builder = function()
        return {
            cmd = {"cargo"},
            args = {"fix", "--allow-dirty", "--allow-staged"},
        }
    end,
}
local cargofmt = {
    name = "Cargo fmt",
    desc = "cargo:fmt",
    builder = function()
        return {
            cmd = {"cargo"},
            args = {"fmt"},
        }
    end,
}

return {
    condition = {
        callback = cargo_toml_exists
    },
    generator = function(search, cb)
        cb({sqlx, cargofix, cargofmt})
    end
}
