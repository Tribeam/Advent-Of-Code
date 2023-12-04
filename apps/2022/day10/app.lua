
local app = 
{
    -- internal var, tells core what input to send
    options =
    {
        input = "input", -- "input", "example", "jumbo"
    },

    -- app vars
    score1 = 0,
    score2 = 0,
    pc = 1,
    cycle = 1,
    x = 1,
    addx_cycles = 0,
    screenw = 40,
    screenh = 6,
    canvas = love.graphics.newCanvas(),
    screenx = 0,
    screeny = 0,
}

function app:cpu_update(op)

    -- noop
    if(op == 0) then
        self.pc = self.pc + 1

    -- addx
    elseif(op > 0 or op < 0) then
        self.addx_cycles = self.addx_cycles + 1
        if(self.addx_cycles == 2) then
            self.addx_cycles = 0
            self.x = self.x + op
            self.pc = self.pc + 1
        end
    end

    self.cycle = self.cycle + 1
    if(self.cycle == 20 or self.cycle == 60 or self.cycle == 100 or self.cycle == 140 or self.cycle == 180 or self.cycle == 220) then
        self.score1 = self.score1 + (self.cycle * self.x)
    end
end

function app:gpu_update()

    self.screenx = self.screenx + 1 

    if(self.x >= self.screenx - 1 and self.x <= self.screenx + 1) then
        love.graphics.setColor(1, 0.5, 0.2, 1)
    else
        love.graphics.setColor(0.2, 0.5, 1, 1) 
    end

    love.graphics.rectangle("fill", self.screenx*8, self.screeny*8, 24, 8)
    
    if(self.screenx % 40 == 0) then
        self.screeny = self.screeny + 1
        self.screenx = 0
    end
    
end

function app:part1(lines, raw, part2)

    -- some data restructure
    if(not part2) then
        for l, v in ipairs(lines) do
            lines[l] = aoclib:replace(lines[l], "noop", "0")
            lines[l] = aoclib:replace(lines[l], "addx ", "")
            lines[l] = tonumber(lines[l])
        end
    end
    while(self.pc <= #lines) do
        self:cpu_update(lines[self.pc])
        self:gpu_update()
    end

    if(not part2) then
        log(self.score1)
    end

end

function app:part2(lines)

    --reset everything from what part1 did
    self.score1 = 0
    self.score2 = 0
    self.pc = 1
    self.cycle = 1
    self.x = 1
    self.addx_cycles = 0
    self.screenw = 40
    self.screenh = 6
    self.canvas = love.graphics.newCanvas()
    self.screenx = 0
    self.screeny = 0

    love.graphics.setCanvas(self.canvas)
    love.graphics.clear(0, 0, 0, 1)
    
    self:part1(lines, nil, true)
    log(self.score2)

    love.graphics.setCanvas()
end

function app:draw()
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(self.canvas, 1, 1)
end


return app