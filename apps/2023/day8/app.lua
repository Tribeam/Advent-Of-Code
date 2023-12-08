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

    lines[1] = aoclib:replace(lines[1], "L", "1")
    lines[1] = aoclib:replace(lines[1], "R", "2")
    local directions = lines[1]
    local directions_pos = 1
    local elements = {}
    local last_element = ""
    local current_element = "AAA"

    for l = 3, #lines do
        lines[l] = aoclib:replace(lines[l], "=", "")
        lines[l] = aoclib:replace(lines[l], "%(", "")
        lines[l] = aoclib:replace(lines[l], "%)", "")
        lines[l] = aoclib:replace(lines[l], ",", "")
        local split = aoclib:split(lines[l], " ")
        elements[split[1]] = { split[2], split[3] }

        if(l == #lines) then
            last_element = split[1]
        end
    end

    local steps = 0
    while(current_element ~= "ZZZ") do
        steps = steps + 1

        current_element = elements[current_element][tonumber(directions:sub(directions_pos, directions_pos))]

        directions_pos = directions_pos + 1
        if(directions_pos > #directions) then
            directions_pos = 1
        end

        if(steps % 1000000000 == 0) then
            print(steps)
        end
    end
    log(steps)
end

function app:part2(lines, raw)

end

return app