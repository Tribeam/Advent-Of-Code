








local app = {}

function app:checkRangeInside(p1r1, p1r2, p2r1, p2r2)
    if(p2r1 >= p1r1 and p2r2 <= p1r2) then
        return true
    end
    return false
end

function app:checkNumberInside(value, r1, r2)
    if(value >= r1 and value <= r2) then
        return true
    end
    return false
end

function app:parse(tbl, raw)
    return tbl
end

-- part 1 code
function app:part1(input)
    local score = 0
    for i, v in ipairs(input) do
        local p = string.split(input[i], ",")
        local ranges = { string.split(p[1], "-"), string.split(p[2], "-") }

        local p1r1 = tonumber(ranges[1][1])
        local p1r2 = tonumber(ranges[1][2])
        local p2r1 = tonumber(ranges[2][1])
        local p2r2 = tonumber(ranges[2][2])

        local scored = false

        -- does the first pair fit inside the second pair?
        if(self:checkRangeInside(p1r1, p1r2, p2r1, p2r2)) then
            score = score + 1
            scored = true
        end

        -- if the first pair doesnt fit inside the second pair.
        if(not scored) then

            -- does the second pair fit inside the first pair?
            if(self:checkRangeInside(p2r1, p2r2, p1r1, p1r2)) then
                score = score + 1
            end
        end
    end
    log(score)
end

-- part 2 code
function app:part2(input)
    local score = 0
    for i, v in ipairs(input) do
        local p = string.split(input[i], ",")
        local ranges = { string.split(p[1], "-"), string.split(p[2], "-") }


        local p1r1 = tonumber(ranges[1][1])
        local p1r2 = tonumber(ranges[1][2])
        local p2r1 = tonumber(ranges[2][1])
        local p2r2 = tonumber(ranges[2][2])

        -- is the first number of the first pair within range of the second pair?
        local scored = false
        if(self:checkNumberInside(p1r1, p2r1, p2r2)) then
            score = score + 1
            scored = true
        end

        if(not scored) then
            -- is the second number of the first pair within range of the second pair? 
            if(self:checkNumberInside(p1r2, p2r1, p2r2)) then
                score = score + 1
                scored = true
            end
        end

        if(not scored) then
            -- is the first number of the second pair within range of the first pair? 
            if(self:checkNumberInside(p2r1, p1r1, p1r2)) then
                score = score + 1
                scored = true
            end
        end

        if(not scored) then
            -- if the second number of the second pair within range of the first pair?
            if(self:checkNumberInside(p2r2, p1r1, p1r2)) then
                score = score + 1
            end
        end
    end
    log(score)
end

return app