local app = {}

-- part 1 code
function app:init1(input)

    local score = 0

    -- replace the x y z chars with the a b c chars
    -- then replace a b c with rock paper scissor, 
    -- so we can make things easier to understand
    for i, v in ipairs(input) do
        input[i] = string.replace(input[i], "X", "A")
        input[i] = string.replace(input[i], "Y", "B")
        input[i] = string.replace(input[i], "Z", "C")
        input[i] = string.replace(input[i], "A", "rock")
        input[i] = string.replace(input[i], "B", "paper")
        input[i] = string.replace(input[i], "C", "scissors")
    end

    --for each line
    for i, v in ipairs(input) do
        local players = string.split(v, " ")
        local outcome = ""

        -- draw
        if(players[1] == players[2]) then
            outcome = "draw"
        else
            if(players[1] == "rock" and players[2] == "paper") then outcome = "win" end
            if(players[1] == "paper" and players[2] == "scissors") then outcome = "win" end
            if(players[1] == "scissors" and players[2] == "rock") then outcome = "win" end

            if(players[1] == "rock" and players[2] == "scissors") then outcome = "loss" end
            if(players[1] == "paper" and players[2] == "rock") then outcome = "loss" end
            if(players[1] == "scissors" and players[2] == "paper") then outcome = "loss" end
        end
        if(outcome == "win") then score = score + 6 end
        if(outcome == "draw") then score = score + 3 end

        if(players[2] == "rock") then score = score + 1 end
        if(players[2] == "paper") then score = score + 2 end
        if(players[2] == "scissors") then score = score + 3 end

    end
    log(string.format("Total Score: %s", score))
end

-- part 2 code
function app:init2(input)

    local score = 0

    -- replace the x y z chars with win draw loss
    -- then replace a b c with rock paper scissor, 
    -- so we can make things easier to understand
    for i, v in ipairs(input) do
        input[i] = string.replace(input[i], "X", "loss")
        input[i] = string.replace(input[i], "Y", "draw")
        input[i] = string.replace(input[i], "Z", "win")
        input[i] = string.replace(input[i], "A", "rock")
        input[i] = string.replace(input[i], "B", "paper")
        input[i] = string.replace(input[i], "C", "scissors")
    end

    --for each line
    for i, v in ipairs(input) do
        local players = string.split(v, " ")
        local choice = ""

        if(players[2] == "draw") then 
            score = score + 3
            choice = players[1] 
        end
        if(players[2] == "win") then
            score = score + 6
            if(players[1] == "rock") then choice = "paper" end
            if(players[1] == "paper") then choice = "scissors" end
            if(players[1] == "scissors") then choice = "rock" end
        end
        if(players[2] == "loss") then
            if(players[1] == "rock") then choice = "scissors" end
            if(players[1] == "paper") then choice = "rock" end
            if(players[1] == "scissors") then choice = "paper" end
        end       

        if(choice == "rock") then score = score + 1 end
        if(choice == "paper") then score = score + 2 end
        if(choice == "scissors") then score = score + 3 end
    end
    log(string.format("Total Score: %s", score))
end

return app