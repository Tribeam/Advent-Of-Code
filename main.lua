
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


core = 
{

    params =
    {
        year = 2023,            -- year to load
        day = 1,                -- day to load
    },

    -- all the paths
    paths = 
    {
        full = "",
        relative = "",
        app_relative = "",
        app_full = "",
        input = "",
        example1 = "",
        example2 = "",
        output = "",
        jumbo = "",
    },

    -- file objects
    files =
    {
        input = "",
        example1 = "",
        example2 = "",
        output = "",
        jumbo = "",
    },

    -- raw data of input files
    rawdata = 
    {
        input = "",
        example1 = "",
        example2 = "",
        jumbo = "",
    },

    -- line tables of input files
    lines =
    {
        input = {},
        example1 = {},
        example2 = {},
        jumbo = {},
    },

    times =
    {
        boot = 0,
        input = 0,
        example1 = 0,
        example2 = 0,
        jumbo = 0,
        input_total = 0,
        load = 0,
        part1 = 0,
        part2 = 0,
        apptotal = 0,
        total = 0,
    },
    memory =
    {
        boot = 0,
        input = 0,
        example1 = 0,
        example2 = 0,
        jumbo = 0,
        input_total = 0,
        load = 0,
        part1 = 0,
        part2 = 0,
        total = 0,
    },
    benchmarks = 
    {
        times = {},
        memories = {},
    },
    app = {}, -- the app's functions and vars
}

-- helper functions
function core:log(msg, ...)
    msg = string.format(msg, ...)
    print(msg)
    self.files.output:write(msg .. "\n")
    return msg
end

function core:logErr(msg, ...)
    error(self:log(msg, ...))
end

function core:benchmarkTime(name)
    if(self.benchmarks.times[name] == nil) then
        self.benchmarks.times[name] = { s=love.timer.getTime(), e=0 }
    else
        self.benchmarks.times[name].e = love.timer.getTime()
        local time = (self.benchmarks.times[name].e-self.benchmarks.times[name].s)*1000
        self.benchmarks.times[name] = nil
        return string.format("%.3fms", time)
    end
end

function core:benchmarkMemory(name)
    if(self.benchmarks.memories[name] == nil) then
        self.benchmarks.memories[name] = { s=collectgarbage("count"), e=0 }
    else
        self.benchmarks.memories[name].e = collectgarbage("count")
        local mem = self.benchmarks.memories[name].e-self.benchmarks.memories[name].s
        self.benchmarks.memories[name] = nil
        return string.format("%.2fkb", mem)
    end
end

function core:fileOpen(path, how)
    how = how or "r"
    local file = io.open(path, how)
    if(not file) then self:logErr("Could not open file '%s'", file) end
    return file
end

function core:fileOpenOptional(path, how)
    how = how or "r"
    local file = io.open(path, how)
    if(not file) then return end
    return file
end

-- core functions
function core:boot()
    self:benchmarkMemory("boot")
    self:benchmarkTime("boot")

    self.paths.full = string.format("%s/apps/%i/day%i", love.filesystem.getWorkingDirectory(), self.params.year, self.params.day)
    self.paths.relative = string.format("/apps/%i/day%i", self.params.year, self.params.day)
    self.paths.app_relative = string.format("%s/app", self.paths.relative) -- this is for the require function
    self.paths.app_full = string.format("%s/app.lua", self.paths.full) -- this is for checking if the file exists
    self.paths.input = string.format("%s/in.txt", self.paths.full)
    self.paths.example1 = string.format("%s/ex1.txt", self.paths.full)
    self.paths.example2 = string.format("%s/ex2.txt", self.paths.full)
    self.paths.output = string.format("%s/out.txt", self.paths.full)
    self.paths.jumbo = string.format("%s/jumbo.txt", self.paths.full)
    self.files.output = self:fileOpen(self.paths.output, "w")

    self.times.boot = self:benchmarkTime("boot")
    self.memory.boot = self:benchmarkMemory("boot")
end

function core:input()
    self:benchmarkMemory("input_total")
    self:benchmarkTime("input_total")

    self:benchmarkMemory("input")
    self:benchmarkTime("input")
    self.files.input = self:fileOpen(self.paths.input)
    self.rawdata.input = self.files.input:read("*all")
    self.files.input:seek("set", 0)
    for line in self.files.input:lines() do self.lines.input[#self.lines.input+1] = line end
    self.times.input = self:benchmarkTime("input")
    self.memory.input = self:benchmarkMemory("input")

    self:benchmarkMemory("example1")
    self:benchmarkTime("example1")
    self.files.example1 = self:fileOpen(self.paths.example1)
    self.rawdata.example1 = self.files.example1:read("*all")
    self.files.example1:seek("set", 0)
    for line in self.files.example1:lines() do self.lines.example1[#self.lines.example1+1] = line end
    self.times.example1 = self:benchmarkTime("example1")
    self.memory.example1 = self:benchmarkMemory("example1")

    self:benchmarkMemory("example2")
    self:benchmarkTime("example2")
    self.files.example2 = self:fileOpen(self.paths.example2)
    self.rawdata.example2 = self.files.example2:read("*all")
    self.files.example2:seek("set", 0)
    for line in self.files.example2:lines() do self.lines.example2[#self.lines.example2+1] = line end
    self.times.example2 = self:benchmarkTime("example2")
    self.memory.example2 = self:benchmarkMemory("example2")

    self:benchmarkMemory("jumbo")
    self:benchmarkTime("jumbo")
    self.files.jumbo = self:fileOpenOptional(self.paths.jumbo)
    if(self.files.jumbo) then 
        self.rawdata.jumbo = self.files.jumbo:read("*all") 
        self.files.jumbo:seek("set", 0)
        for line in self.files.jumbo:lines() do self.lines.jumbo[#self.lines.jumbo+1] = line end
    end
    self.times.jumbo = self:benchmarkTime("jumbo")
    self.memory.jumbo = self:benchmarkMemory("jumbo")

    self.times.input_total = self:benchmarkTime("input_total")
    self.memory.input_total = self:benchmarkMemory("input_total")
end

function core:app()
    self:benchmarkMemory("app")
    self:benchmarkTime("app")

    self.app = require(self.paths.app_relative)
    if(type(self.app) ~= "table") then self:logErr("Error: App did not return a table.")  end
    if(type(self.app.part1) ~= "function") then self:logErr("Error: App has no part1 function.") end
    if(type(self.app.part2) ~= "function") then self:logErr("Error: App has no part2 function.") end
    if(type(self.app.options) ~= "table") then self:logErr("Error: App has no options.") end
    if(type(self.app.options.input) ~= "string") then self:logErr("Error: App's input option is not a string.") end

    function log(msg, ...)
        msg = string.format("App Message: " .. msg, ...)
        print(msg)
        self.files.output:write(msg .. "\n")
        return msg
    end

    self.times.load = self:benchmarkTime("app")
    self.memory.load = self:benchmarkMemory("app")
end

function core:filesClose()
    self.files.input:close()
    self.files.example1:close()
    self.files.example2:close()
    self.files.output:close()
end

function core:runPart1()
    local lines = self.lines.input
    local data = self.rawdata.input
    if(self.app.options.input == "example") then
        lines = self.lines.example1
        data = self.rawdata.example1
    end
    if(self.app.options.input == "jumbo") then
        lines = self.lines.jumbo
        data = self.rawdata.jumbo
    end

    self:benchmarkMemory("part1")
    self:benchmarkTime("part1")
    self.app:part1(lines, data)
    self.times.part1 = self:benchmarkTime("part1")
    self.memory.part1 = self:benchmarkMemory("part1")
end

function core:runPart2()
    local lines = self.lines.input
    local data = self.rawdata.input
    if(self.app.options.input == "example") then
        lines = self.lines.example2
        data = self.rawdata.example2
    end
    if(self.app.options.input == "jumbo") then
        lines = self.lines.jumbo
        data = self.rawdata.jumbo
    end
    self:benchmarkMemory("part2")
    self:benchmarkTime("part2")
    self.app:part2(lines, data)
    self.times.part2 = self:benchmarkTime("part2")
    self.memory.part2 = self:benchmarkMemory("part2")
end

function core:load(args)
    self:benchmarkMemory("total")
    self:benchmarkTime("total")

    self:boot()
    self:log("------------------------BOOT------------------------")
    self:log("Params:")
    self:log("\tYear \t\t= %s", self.params.year)
    self:log("\tDay \t\t= %s", self.params.day)
    self:log("Paths:")
    self:log("\tFull \t\t= %s", self.paths.full)
    self:log("\tRelative \t= %s", self.paths.relative)
    self:log("\tApp Rel \t= %s", self.paths.app_relative)
    self:log("\tApp Full \t= %s", self.paths.app_full)
    self:log("\tInput \t\t= %s", self.paths.input)
    self:log("\tExample 1 \t= %s", self.paths.example1)
    self:log("\tExample 2 \t= %s", self.paths.example2)
    self:log("\tOutput \t\t= %s", self.paths.output)
    self:log("\tJumbo \t\t= %s", self.paths.jumbo)
    self:log("")

    self:input()
    self:log("------------------------INPUT-----------------------")
    self:log("Sizes:")
    self:log("\tInput \t\t= %s", #self.rawdata.input)
    self:log("\tExample1 \t= %s", #self.rawdata.example1)
    self:log("\tExample2 \t= %s", #self.rawdata.example2)
    self:log("\tJumbo \t\t= %s", #self.rawdata.jumbo)
    self:log("Lines:")
    self:log("\tInput \t\t= %s", #self.lines.input)
    self:log("\tExample1 \t= %s", #self.lines.example1)
    self:log("\tExample2 \t= %s", #self.lines.example2)
    self:log("\tJumbo \t\t= %s", #self.lines.jumbo)
    self:log("")

    self:app()
    self:log("------------------------APP-------------------------")
    self:log("Options:")
    self:log("\tInput \t\t= %s", self.app.options.input)
    self:log("")


    self:log("------------------------PART1-----------------------")
    self:runPart1()
    self:log("")

    self:log("------------------------PART2-----------------------")
    self:runPart2()
    self:log("")

    self.times.total = self:benchmarkTime("total")
    self.memory.total = self:benchmarkMemory("total")
    self:log("------------------------END-------------------------")
    self:log("Times:")
    self:log("\tBoot \t\t= %s", self.times.boot)
    self:log("\tInput \t\t= %s", self.times.input)
    self:log("\tInput Ex1 \t= %s", self.times.example1)
    self:log("\tInput Ex2 \t= %s", self.times.example2)
    self:log("\tInput Jumbo \t= %s", self.times.jumbo)
    self:log("\tInput Total \t= %s", self.times.input_total)
    self:log("\tApp Load \t= %s", self.times.load)
    self:log("\tPart 1 \t\t= %s", self.times.part1)
    self:log("\tPart 2 \t\t= %s", self.times.part2)
    self:log("\tTotal \t\t= %s", self.times.total)
    self:log("Memory:")
    self:log("\tBoot \t\t= %s", self.memory.boot)
    self:log("\tInput \t\t= %s", self.memory.input)
    self:log("\tInput Ex1 \t= %s", self.memory.example1)
    self:log("\tInput Ex2 \t= %s", self.memory.example2)
    self:log("\tInput Jumbo \t= %s", self.memory.jumbo)
    self:log("\tInput Total \t= %s", self.memory.input_total)
    self:log("\tApp Load \t= %s", self.memory.load)
    self:log("\tPart 1 \t\t= %s", self.memory.part1)
    self:log("\tPart 2 \t\t= %s", self.memory.part2)
    self:log("\tTotal \t\t= %s", self.memory.total)
    self:filesClose()
end

function love.load(args)
    core:load()
end