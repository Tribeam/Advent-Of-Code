local app = {}

function app:parse(tbl, raw)
    return tbl
end

function app:part1(input)
    
    local elves = {}
    local elves_count = 0
    local food_count = 0

    -- go through all the elves
    for i, line in ipairs(input) do

        -- setup next elf
        if(line == "") then
            elves_count = elves_count + 1
            food_count = 0

        -- add food to current elf and add to total elf calories
        else
            food_count = food_count + 1
            if(elves[elves_count] == nil) then elves[elves_count] = {total = 0} end
            elves[elves_count][food_count] = line
            elves[elves_count].total = elves[elves_count].total + tonumber(line)
        end
    end

    -- sort table by total cals
    table.sort(elves, function (k1, k2) return k1.total > k2.total end)

    -- log things
    log("1st place total: " .. elves[1].total)
    log("2nd place total: " .. elves[2].total)
    log("3rd place total: " .. elves[3].total)
    log("all 3 total: " .. elves[1].total + elves[2].total + elves[3].total)

end

function app:part2(input)
    app:part1(input)
end

return app