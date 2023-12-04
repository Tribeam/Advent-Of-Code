


local aoclib = {}

-- split string
function aoclib:split(input, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = {}
    for str in string.gmatch(input, "([^" .. sep .. "]+)") do
        table.insert(t, str)
    end
    return t
end

-- string replace
function aoclib:replace(input, find, replace)
    return input:gsub(find, replace)
end

-- check if var is a number
function aoclib:isNumber(input)
    if(tonumber(input)) then return true end
    return false
end

-- check if var is a string
function aoclib:isString(input)
    if(type(input) == "string") then return true end
    return false
end

-- build a grid table
function aoclib:buildGrid(w, h, char)
    char = char or ""
    local grid = {}
    for y = 1, w do
        grid[y] = {}
        for x = 1, h do
            grid[y][x] = char
        end
    end
    return grid
end

-- print a grid
function aoclib:logGrid(grid)
    local str = "\n"
    for y = 1, #grid do
        for x = 1, #grid[y] do
            str = str .. grid[y][x]
        end
        str = str .. "\n"
    end
    log(str)
end

-- print a table
function aoclib:logTable(tbl, indent)
    indent = indent or 0
    for k, v in pairs(tbl) do
        formatting = string.rep("  ", indent) .. k .. ": "
        if type(v) == "table" then
            log(formatting)
            self:logTable(v, indent + 1)
        else
            log(formatting .. tostring(v))
        end
    end
end

return aoclib