

local year = 23
local day = 1
local examplemode = true

local logfile
function log(msg)
    print(msg)
    logfile:write(tostring(msg) .. "\n")
end

function string.split(input, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = {}
    for str in string.gmatch(input, "([^" .. sep .. "]+)") do
        table.insert(t, str)
    end
    return t
end

function string.replace(input, find, replace)
    return input:gsub(find, replace)
end

function logGrid(grid)
    local str = "\n"
    for y = 1, #grid do
        
        for x = 1, #grid[y] do
            str = str .. grid[y][x]
        end
        str = str .. "\n"
    end
    log(str)
end


function love.load(args)
    local s2 = love.timer.getTime()
    local e2 = 0
    local s = love.timer.getTime()
    local e = 0

    -- error checks
    if(year == nil) then error("Error: Year is nil.") end
    if(type(tonumber(year)) ~= "number") then error("Error: Year is not a number.") end
    if(day == nil) then error("Error: Day is nil.") end
    if(type(tonumber(day)) ~= "number") then error("Error: Day is not a number.") end    

    -- make paths to app
    local fullpath = string.format("%s/apps/20%i/day%i", love.filesystem.getWorkingDirectory(), year, day)
    local relpath = string.format("/apps/20%i/day%i", year, day)

    -- open logfile
    logfile = io.open(fullpath .. "/out.txt", "w+")
    log("------------------BOOT------------------")
    log(string.format("Year: '20%i'", year))
    log(string.format("Day: '%i'", day))
    log(string.format("Example Mode: '%s'", examplemode))
    log(string.format("Relative Path: '%s'", relpath))
    log(string.format("App Path: '%s/app.lua'", relpath))
    log(string.format("Full Path: '%s'", fullpath))
    log(string.format("In Path: '%s/in.txt'", fullpath))
    log(string.format("Out Path: '%s/out.txt", fullpath))
    log(string.format("Example Path: '%s/ex.txt", fullpath))
    log(string.format("Time: '%.3fms'\n", (love.timer.getTime()-s)*1000))

    -- load input file
    log("------------------INPUT------------------")
    local filename = "in.txt"
    if(examplemode == true) then
        filename = "ex.txt"
        log("Using Example Input.")
    end
    log(string.format("Loading: '%s/%s'", fullpath, filename))
    s = love.timer.getTime()

    local inputfile = io.open(string.format("%s/%s", fullpath, filename), "r")
    local inputtable = {}
    local inputdata = ""
    if(inputfile) then
        inputdata = inputfile:read("*all")
        inputfile:seek("set", 0)
        for line in inputfile:lines() do
            inputtable[#inputtable+1] = line
        end
        inputfile:close()
    else
        error("Error: Could not find input file.")
    end
    
    log(string.format("Input Chars: '%i'", #inputdata))
    log(string.format("Input Lines: '%i'", #inputtable))
    log(string.format("Time: '%.3fms'\n", (love.timer.getTime()-s)*1000))

    -- load app
    log("------------------LOAD------------------")
    log(string.format("Loading: '%s/app.lua'", fullpath))
    s = love.timer.getTime()
    local app = require(relpath .. "/app")

    if(type(app.part1) ~= "function") then error("Error: Could not find app's part1 function.") end
    if(type(app.part2) ~= "function") then error("Error: Could not find app's part2 function.") end
    log(string.format("Time: '%.3fms'\n", (love.timer.getTime()-s)*1000))
    local memory = collectgarbage("count")

    log("------------------PART1------------------")
    log(string.format("Starting: '%s/app.lua:(part 1)'", fullpath))

    -- hacky way of appending a prefix to the logs when the app uses the log function
    function log(msg)
        msg = "App Message: " .. tostring(msg)
        print(msg)
        logfile:write(msg .. "\n")
    end

    s = love.timer.getTime()
    app:part1(inputtable, inputdata)
    e = love.timer.getTime()-s

    -- hacky way of removing the prefix to the logs when the app is done
    function log(msg)
        print(msg)
        logfile:write(tostring(msg) .. "\n")
    end

    local appmemory = collectgarbage("count")-memory
    log(string.format("Time: '%.3fms'\n", e*1000))
    
    log("------------------PART2------------------")
    log(string.format("Starting: '%s/app.lua:(part 2)'", fullpath))

    -- hacky way of appending a prefix to the logs when the app uses the log function
    function log(msg)
        msg = "App Message: " .. tostring(msg)
        print(msg)
        logfile:write(msg .. "\n")
    end

    s = love.timer.getTime()
    app:part2(inputtable, inputdata)
    e = love.timer.getTime()-s

    -- hacky way of removing the prefix to the logs when the app is done
    function log(msg)
        print(msg)
        logfile:write(tostring(msg) .. "\n")
    end

    local appmemory = collectgarbage("count")-memory
    log(string.format("Time: '%.3fms'\n", e*1000))

    -- results
    log("------------------END------------------")
    log(string.format("Boot Memory: '%.2fkb'", memory))
    log(string.format("App Memory: '%.2fkb'", appmemory))
    log(string.format("Total Memory: '%.2fkb'", appmemory+memory))
    log(string.format("Total Time: '%.3fms'\n", (love.timer.getTime()-s2)*1000))

    logfile:close()
end