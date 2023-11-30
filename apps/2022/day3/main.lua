



local app = {}

-- part 1 code
function app:part1(input)

    --for each rucksack
    local score = 0

    for i, v in ipairs(input) do
        local halfcount = #v/2
        local half1 = v:sub(1, halfcount)
        local half2 = v:sub(halfcount+1)

        local foundtable = {}
        local skip = false
        for item1 = 1, halfcount do
            skip = false
            local char1 = half1:sub(item1, item1)

            for item2 = 1, halfcount do
                local char2 = half2:sub(item2, item2)

                if(char1 == char2) then
                    
                    for f, v in ipairs(foundtable) do
                        if(char1 == v or char2 == v) then
                            skip = true
                            break
                        end
                    end

                    if(not skip) then
                        foundtable[#foundtable+1] = char1
                        local ascii = string.byte(char1)

                        -- uppercase ascii range
                        if(ascii >= 0x41 and ascii <= 0x5A) then
                            score = score + (ascii-0x40)+26
                        end

                        -- lowercase ascii range
                        if(ascii >= 0x61 and ascii <= 0x7A) then
                            score = (score + (ascii-0x60))
                        end
                    end
                end
            end            
        end
    end
    log(score)
end

-- part 2 code
function app:part2(input)

end

return app