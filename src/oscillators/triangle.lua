local oscillator = require('oscillators.oscillator')
local Triangle = oscillator:new()

-- make triangle a blueprint (a triangle can be instantiated by calling :new)
function Triangle:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Triangle:sample()
    local phase = self.phase
    local a = phase / (2 * math.pi)

    self:update_phase()

    return 2 * math.abs(2 * (a - math.floor(a + 0.5))) - 1
    -- return 4 * math.abs(phase - math.floor(phase+3/4) + 1/4) - 1
end

return Triangle
