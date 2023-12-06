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

    local score = 1

    -- setup our data
    local races = {}
    local splits = {}
    splits[1] = aoclib:split(lines[1], " ")
    splits[2] = aoclib:split(lines[2], " ")
    table.remove(splits[1], 1)
    table.remove(splits[2], 1)
    for i, v in ipairs(splits[1]) do
        races[i] = { time=splits[1][i], dist=splits[2][i] }
    end

    -- lets put "the only race" as the last race
    local the_only_race = #races+1
    races[the_only_race] = 
    {
        time=0,
        dist=0,
    }
 
    for r = 1, #races-1 do
        races[the_only_race].time = races[the_only_race].time .. races[r].time
        races[the_only_race].dist = races[the_only_race].dist .. races[r].dist
    end

    -- for each race
    for r = 1, #races do

        races[r].wins = 0

        -- for each hold time
        for h = 1, races[r].time do
            local movetime = races[r].time-h
            local movedist = h*movetime

            if(movedist > tonumber(races[r].dist)) then
                races[r].wins = races[r].wins + 1
            end
        end

        -- last race
        if(r < #races) then
            score = score * races[r].wins
        end
    end

    if(part2 == true) then score = races[#races].wins end

    log(score)
end

function app:part2(lines, raw)
    self:part1(lines, raw, true)
end

return app