local app = 
{
    -- internal var, tells core what input to send
    options =
    {
        input = "example", -- "input", "example", "jumbo"
    },

    -- app vars
}

function app:part1(lines, raw)


    local almanac = 
    {
        seed_to_plant = {}
        {}, -- 1 seed to soil
        {}, -- 2 soil-to-fertilizer
        {}, -- 3 fertilizer-to-water
        {}, -- 4 water-to-light
        {}, -- 5 light-to-temperature
        {}, -- 6 temperature-to-humidity
        {}, -- 7 humidity-to-location
    }

    local map_to_fill = almanac.seeds_to_plant

    local l = 1
    while(l <= #lines) do

        -- seeds to plant
        local op = lines[l]:sub(1, 5) 
        if(op == "seeds") then
            local split1 = aoclib:split(lines[l], ":")
            almanac.seeds_to_plant = aoclib:split(split1[2], " ")

        -- seed-to-soil
    elseif(op == "seed-") then map_to_fill = 1
        
        -- soil to fert
    elseif(op == "soil-") then map_to_fill = 2

        -- fert to water
    elseif(op == "ferti") then map_to_fill = 3

        -- water to light
    elseif(op == "water") then map_to_fill = 4

        -- light to temp
    elseif(op  == "light") then map_to_fill = 5

        -- temp to humid
    elseif(op == "tempe") then map_to_fill = 6
       
        -- humid to loc
    elseif(op == "humid") then map_to_fill = 7
    
        -- first char of line is a number
    elseif(aoclib:isNumber(lines[l]:sub(1, 1))) then
            local split = aoclib:split(lines[l], " ")
            almanac[map_to_fill][#almanac[map_to_fill]+1].dest = split[1]
            almanac[map_to_fill][#almanac[map_to_fill]+1].src = split[2]
            almanac[map_to_fill][#almanac[map_to_fill]+1].len = split[3]
        end
        l = l + 1
    end

    -- source to dest of len

    -- for each map
    for m, v in ipairs(maps) do



    end
end

function app:part2(lines, raw)

end

return app