local app = 
{
    -- internal var, tells core what input to send
    options =
    {
        input = "input", -- "input", "example", "jumbo"
    },

    -- app vars
}

function app:part1(lines, raw)
    
    -- for each line (or game)
    local score = 0
    for i, v in ipairs(lines) do

        local failed = false

        -- split game id from groups
        local split1 = string.split(v, ":")

        -- split groups
        local groups = string.split(split1[2], ";")

        -- split the colors
        for i2, v2 in ipairs(groups) do

            -- split the values
            local colors = string.split(v2, ",")
            for i3, v3 in ipairs(colors) do
                local parts = string.split(v3, " ")
                parts[2] = string.replace(parts[2], " ", "")
                parts[1] = tonumber(parts[1])

                if(parts[2] == "red" and parts[1] > 12) then
                    failed = true
                end
                if(parts[2] == "green" and parts[1] > 13) then
                    failed = true
                end
                if(parts[2] == "blue" and parts[1] > 14) then
                    failed = true
                end
            end
        end
        if(not failed) then
            log(i)
            score = score + i
        end
    end
    log(score)
end

function app:part2(lines, raw)
    -- for each line (or game)
    local score = 0
    for i, v in ipairs(lines) do

        -- split game id from groups
        local split1 = string.split(v, ":")

        -- split groups
        local groups = string.split(split1[2], ";")

        local red = 0
        local green = 0
        local blue = 0
        -- split the colors
        for i2, v2 in ipairs(groups) do

            -- split the values
            local colors = string.split(v2, ",")

            for i3, v3 in ipairs(colors) do
                local parts = string.split(v3, " ")
                parts[2] = string.replace(parts[2], " ", "")
                parts[1] = tonumber(parts[1])

                if(parts[2] == "red") then
                    if(parts[1] > red) then
                        red = parts[1]
                    end
                end

                if(parts[2] == "green") then
                    if(parts[1] > green) then
                        green = parts[1]
                    end
                end

                if(parts[2] == "blue") then
                    if(parts[1] > blue) then
                        blue = parts[1]
                    end
                end
            end
        end
        local power = red*green*blue
        score = score + power
    end
    log(score)
end

return app