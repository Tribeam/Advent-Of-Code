




local app = {}

-- part 1 code
function app:part1(input)


    local score = ""
    local cmd_line_start = 0
    local grid = {}

    -- lets restructure the data to make it easier to work with
    for i, v in ipairs(input) do
        input[i] = string.replace(input[i], "move ", "")
        input[i] = string.replace(input[i], "from ", "")
        input[i] = string.replace(input[i], "to ", "")
    end


    -- build our crate grid
    for y = 1, 64 do
        grid[y] = {}
        for x = 1, 9 do
            grid[y][x] = "-"
        end
    end

    -- read the crate grid
    for i, v in ipairs(input) do
        if(input[i]:sub(1, 1) == " ") then
            cmd_line_start = i+2
            break 
        end

        -- start at the second char of the line, and skip over every 4 chars to the next crate letter
        local x = 1
        for char = 2, #input[i], 4 do
            local char = input[i]:sub(char,char)
            if(char == " ") then char = "-" end
            grid[(64-8)+i][x] = char
            x = x + 1
        end
    end

    -- visualize our grid
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
            for y = #grid, 1, -1 do
                if(grid[y][from] == "-") then
                    
                    copy = grid[y+1][from]
                    grid[y+1][from] = "-"
                    break;
                end
            end

            -- go up until we find a - on the 'to' stack
            for y = #grid, 1, -1 do
                if(grid[y][to] == "-") then
                    grid[y][to] = copy
                    break;
                end
            end
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