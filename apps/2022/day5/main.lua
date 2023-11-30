




local app = 
{
    score = ""
    cmd_line_start = 0
    grid = {}
    input = {}
}

-- restructure the data to make it easier to work with
function app:inputRestructure()
    for i, v in ipairs(self.input) do
        self.input[i] = string.replace(self.input[i], "move ", "")
        self.input[i] = string.replace(self.input[i], "from ", "")
        self.input[i] = string.replace(self.input[i], "to ", "")
    end
end

-- init the grid
function app:gridInit()
    for y = 1, 64 do
        self.grid[y] = {}
        for x = 1, 9 do
            self.grid[y][x] = "-"
        end
    end
end

-- read the crate grid
function app:gridBuild()

    -- for each input line
    for i, v in ipairs(self.input) do
        if(self.input[i]:sub(1, 1) == " ") then
            self.cmd_line_start = i+2
            break 
        end

        -- start at the second char of the line, and skip over every 4 chars to the next crate letter
        local x = 1
        for char = 2, #self.input[i], 4 do
            local char = self.input[i]:sub(char,char)
            if(char == " ") then char = "-" end
            self.grid[(64-8)+i][x] = char
            x = x + 1
        end
    end
end

-- go up a column until we find a -
function app:gridFindLastCrate(x)
    for y = #self.grid, 1, -1 do
        if(self.grid[y][x] == "-") then
            return y+1
        end
    end
end


-- part 1 code
function app:part1(input)

    self.input = input

    self:inputRestructure()
    self:gridInit()
    self:gridBuild()
    logGrid(grid)


    -- go through each command
    for i = cmd_line_start, #input do
        local ops = string.split(input[i], " ")
        local amount = tonumber(ops[1])
        local from = tonumber(ops[2])
        local to = tonumber(ops[3])
        local copy = ""

        -- for the amount of crates we need to move
        for i2 = 1, amount do

            -- go up until we find a - on the 'from' stack
            local yf = gridFindLastCrate(from)
            local yt = gridFindLastCrate(to)+1

            grid[yt][to] = grid[yf][from]
            grid[yf][from] = "-"
        end
    end
    logGrid(grid)

    -- run through the grid one more time and give us our score
    for x = 1, #grid[1] do
        for y = #grid, 1, -1 do
            if(grid[y][x] == "-") then
                score = score .. grid[y+1][x]
                break;
            end
        end
    end
    log(score)
end

-- part 2 code
function app:part2(input)

end

return app