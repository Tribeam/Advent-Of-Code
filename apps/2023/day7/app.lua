local app = 
{
    -- internal var, tells core what input to send
    options =
    {
        input = "example", -- "input", "example", "jumbo"
    },

    -- app vars
}

local function customSort(a, b)
    for i = 1, #a.line do
        local ca = tonumber(a.line:sub(i, i), 16)
        local cb = tonumber(b.line:sub(i, i), 16)
        if ca ~= cb then
            return ca > cb -- Higher number wins
        end
    end
end

function app:part1(lines, raw, part2)

    local score = 0
    local hands = {}
    local dups = {{}, {}, {}, {}, {}, {}, {}}
    for l, v in ipairs(lines) do

        local index = #hands+1
        hands[index] = {raw = lines[l]}

        -- change lettered cards to hex letters
        lines[l] = aoclib:replace(lines[l], "A", "E")
        lines[l] = aoclib:replace(lines[l], "T", "A")
        lines[l] = aoclib:replace(lines[l], "J", "B")
        lines[l] = aoclib:replace(lines[l], "Q", "C")
        lines[l] = aoclib:replace(lines[l], "K", "D")

        local split = aoclib:split(lines[l], " ")
        hands[index].line = split[1]
        hands[index].numbers = {}
        hands[index].bid = split[2]
        hands[index].counts = {}
        hands[index].strength = 5



        -- for each char
        for c = 1, #split[1] do

             -- convert hex letter to decimal numbers
            local index2 = tonumber(split[1]:sub(c, c), 16)
            hands[index].numbers[c] = index2
            
            -- count up each same number
            if(hands[index].counts[index2] == nil) then hands[index].counts[index2] = 0 end
            hands[index].counts[index2] = hands[index].counts[index2] + 1
        end

        -- this is becuase of a lua quirk, , since i already setup this code i dont fill like fixing it.
        -- it was suppose to be hands[index].strength = #hands[index].counts
        for k, v in pairs(hands[index].counts) do
            hands[index].strength = hands[index].strength-1
        end

        dups[hands[index].strength][#dups[hands[index].strength]+1] = hands[index]

    end

    for d = 1, #dups do
        table.sort(dups[d], customSort)
    end

    local rank = 0
    for d = 1, #dups do
        for dd = 1, #dups[d] do
            rank = rank + 1
            score = score + (dups[d][dd].bid * rank)
        end
    end

    aoclib:logTable(dups)
    log(score)
  
end

function app:part2(lines, raw)

end

return app