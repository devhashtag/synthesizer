local sign = require('common').sign
local Oscillator = require('oscillators.oscillator')
local Square = Oscillator:new()

function Square:sample_at(t)
    return sign(math.sin(2 * math.pi * self.frequency * t))
end

return Square
