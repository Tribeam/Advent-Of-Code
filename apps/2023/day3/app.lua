local app = 
{
    -- internal var, tells core what input to send
    options =
    {
        input = "input", -- "input", "example", "jumbo"
    },

    -- app vars
}

function app:part1(lines, raw, part2)

    local score = 0

    local gear_spots = {}
    local number_spots = {}
    local grid = {}
    local xsize = #lines[1]
    local ysize = #lines

    grid = aoclib:buildGrid(xsize, ysize)
    -- convert the input into a grid
    -- for each line
    for l, v in ipairs(lines) do

        -- for each char
        local c = 1
        while(c <= #lines[l]) do
            local result = ""

            -- max number seems to be 999, so only check for 3 digits
            local char1 = v:sub(c, c)
            local char2 = v:sub(c+1, c+1)
            local char3 = v:sub(c+2, c+2)

            -- check if digits exist and stack them onto the result
            if(aoclib:isNumber(char1)) then 
                result = result .. char1

                if(aoclib:isNumber(char2)) then 
                    result = result .. char2 
                    if(aoclib:isNumber(char3)) then 
                        result = result .. char3 
                    end
                end
                -- save the x, y, digit_count, and the number itself
                number_spots[#number_spots+1] = {c, l, #result, tonumber(result)}
                
            -- is a gear
            elseif(char1 == "*") then
                -- save the spot the gear is in
                gear_spots[#gear_spots+1] = {c, l}
                result = char1
            else
                result = char1
            end

            -- set number or char into grid spot
            for c2 = 1, #result do
                grid[l][c+(c2-1)] = result:sub(c2, c2)
            end
            c = c + #result
        end
    end

    -- send the grid to part2
    if(part2 == true) then return grid, gear_spots, number_spots end

    -- run through the numbers
    local x = 1
    local y = 1

    for i, v in ipairs(number_spots) do

        -- setup search area
        local x_start = v[1]-1
        local y_start = v[2]-1
        local x_end = v[1]+v[3]
        local y_end = v[2]+1

        function anon()
            for y = y_start, y_end do
                for x = x_start, x_end do
                    if(grid[y] ~= nil and grid[y][x] ~= nil) then
                        if(grid[y][x] ~= "." and aoclib:isNumber(grid[y][x])) then
                            score = score + v[4]
                            return
                        end
                    end
                end
            end
        end
        anon()
    end

    print(score)

end

function app:part2(lines)
    local grid, gear_spots, number_spots = self:part1(lines, nil, true)

    local score = 0
    -- for each gear
    for g, v in ipairs(gear_spots) do

        love.graphics.setColor(0, 1, 0, 0.5)
        love.graphics.rectangle("fill", v[1]*12, v[2]*12, 12, 12)

        -- setup search area
        local x_start = v[1]-1
        local y_start = v[2]-1
        local x_end = v[1]+1
        local y_end = v[2]+1

        local numbers_found = {}

        -- search around the gear for numbers
            for y = y_start, y_end do
                for x = x_start, x_end do
                    local found_already = nil
                    -- is this a valid grid spot?
                    if(grid[y] ~= nil and grid[y][x] ~= nil) then
                        -- is this grid spot a number?
                        if(aoclib:isNumber(grid[y][x])) then
                            for d = x-2, x+2 do
                                
                                for n, v2 in ipairs(number_spots) do
                                    
                                    if(d == v2[1] and y == v2[2]) then
                                        
                                        for j, jv in ipairs(numbers_found) do
                                            if(jv == v2[4]) then found_already = true end
                                        end
                                        if(not found_already) then
                                            numbers_found[#numbers_found+1] = v2[4]
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end

        if(#numbers_found == 2) then
            score = score + (numbers_found[1]*numbers_found[2])
        end
    end
    print(score)
end

return app