





local logfile
function log(msg)
    print(msg)
    logfile:write(tostring(msg) .. "\n")
end

function love.load(args)
    local s2 = love.timer.getTime()
    local e2 = 0
    local s = love.timer.getTime()
    local e = 0

    local year = args[1]
    local day = args[2]
    dolog = args[3]

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
    log(string.format("Relative Path: '%s'", relpath))
    log(string.format("App Path: '%s/main.lua'", relpath))
    log(string.format("Full Path: '%s'", fullpath))
    log(string.format("In Path: '%s/in.txt'", fullpath))
    log(string.format("Out Path: '%s/out.txt", fullpath))
    log(string.format("Time: '%.3fms'\n", (love.timer.getTime()-s)*1000))

    -- load input file
    log("------------------INPUT------------------")
    log(string.format("Loading: '%s/in.txt'", fullpath))
    s = love.timer.getTime()

    local inputfile = io.open(fullpath .. "/in.txt", "r")
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
    log(string.format("Loading: '%s/main.lua'", fullpath))
    s = love.timer.getTime()
    local app = require(relpath .. "/main")
    if(type(app.init) ~= "function") then error("Error: Could not find app's init function.") end
    log(string.format("Time: '%.3fms'\n", (love.timer.getTime()-s)*1000))
    local memory = collectgarbage("count")

    -- run app
    log("------------------START------------------")
    log(string.format("Starting: '%s/main.lua'", fullpath))
    s = love.timer.getTime()
    app:init(inputtable, inputdata)
    e = love.timer.getTime()-s
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