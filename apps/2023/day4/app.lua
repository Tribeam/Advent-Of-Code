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

    local score = 0
    local cards = {}
    
    for l = 1, #lines do
        local split1 = aoclib:split(lines[l], ":")
        local split2 = aoclib:split(split1[2], "|")

        cards[l] = {}
        cards[l].win_nums = aoclib:split(split2[1], " ")
        cards[l].play_nums = aoclib:split(split2[2], " ")
        cards[l].matches = {}
        cards[l].score = 0
        cards[l].count = 1
        -- for each win number
        for w, v2 in ipairs(cards[l].win_nums) do

            -- for each play number
            for p, v3 in ipairs(cards[l].play_nums) do

                -- found match numbers
                if(v2 == v3) then 

                    -- add number to matches
                    cards[l].matches[#cards[l].matches+1] = v2

                    -- is score 0?
                    if(cards[l].score == 0) then

                        -- set score to 1
                        cards[l].score = 1
                    else
                        -- double the score
                        cards[l].score = cards[l].score*2
                    end
                end
            end
        end
        -- add card score to total score
        score = score + cards[l].score
    end
   log(score)
   return cards
end

function app:part2(lines, raw)

    local score = 0
    local cards = self:part1(lines, raw)

    -- for each card
    for c = 1, #cards do

        -- for each instance of a card
        for instance = 1, cards[c].count do

            -- for each match
            for m = 1, #cards[c].matches do
                cards[c+m].count = cards[c+m].count + 1
            end
        end
        score = score + cards[c].count
    end
    log(score)
end

return app