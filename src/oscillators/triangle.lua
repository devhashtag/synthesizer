local oscillator = require('oscillators.oscillator')
local Triangle = oscillator:new()

-- make triangle a blueprint (a triangle can be instantiated by calling :new)
function Triangle:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Triangle:sample_at(t)
    t = t * self.frequency
    return 2 * math.abs(2 * (t + 0.25 - math.floor(t + 0.75))) - 1
end

return Triangle
