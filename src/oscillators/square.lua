local sign = require('common').sign
local oscillator = require('oscillators.oscillator')
local Square = oscillator:new()

-- make square a blueprint (a square can be instantiated by calling :new)
function Square:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Square:sample()
    return sign(getmetatable(self):sample())
end


return Square
