
local app = 
{
    -- internal var, tells core what input to send
    options =
    {
        input = "jumbo", -- "input", "example", "jumbo"
    },

    -- app vars
    numbers = { "one", "two", "three", "four", "five", "six", "seven", "eight", "nine" },
}

function app:part1(lines)

    local score = 0

    -- for each line
    for i, v in ipairs(lines) do
        local num1
        local num2

        -- for each char on the line forward
        for c = 1, #v do
            local char = v:sub(c, c)

            -- is the char a number?
            if(type(tonumber(char)) == "number") then
                num1 = char
                break;
            end
        end

        -- for each char on the line backwards
        for c = #v, 1, -1 do
            local char = v:sub(c, c)

            -- is the char a number?
            if(type(tonumber(char)) == "number") then
                num2 = char
                break;
            end
        end

        -- combine the 2 numbers
        final_line_number = tonumber(num1 .. num2)

        -- add number to score
        score = score + final_line_number
    end
    log(score)
end

function app:part2(lines)

    local score = 0

    -- for each line
    for i, v in ipairs(lines) do
        local num1
        local num2

        -- for each char on the line forward
        for c = 1, #v do
            local char = v:sub(c, c)

            -- is the char a number?
            if(type(tonumber(char)) == "number") then
                num1 = char
                break;

            -- is the char a letter?
            elseif(type(char) == "string") then
                local num = 0

                for i2, v2 in ipairs(self.numbers) do
                    if(v:sub(c,c+#v2-1) == v2) then
                        num = i2
                        break
                    end
                end

                -- if not 0 we know we found the number
                if(num > 0) then
                    num1 = num
                    break
                end
            end
        end

        -- for each char on the line backwards
        for c = #v, 1, -1 do
            local char = v:sub(c, c)

            -- is the char a number?
            if(type(tonumber(char)) == "number") then
                num2 = char
                break;

            -- is the char a letter?
            elseif(type(char) == "string") then
                local num = 0

                for i2, v2 in ipairs(self.numbers) do
                    if(v:sub(c-#v2+1,c) == v2) then
                        num = i2
                        break
                    end
                end
                
                -- if not 0 we know we found the number
                if(num > 0) then
                    num2 = num
                    break;
                end
            end
        end

        -- combine the 2 numbers
        final_line_number = tonumber(num1 .. num2)

        -- add number to score
        score = score + final_line_number
    end
    log(score)
end

return app