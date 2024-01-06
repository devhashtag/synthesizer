local oscillator = require('oscillators.oscillator')
local Square = oscillator:new()

local function sign(x)
    if x < 0 then
        return -1
    else
        return 1
    end
end

-- make square a blueprint (a square can be instantiated by calling :new)
function Square:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Square:sample()
    return sign(self:sample())
end


return Square
