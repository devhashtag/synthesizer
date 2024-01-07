local Oscillator = require('oscillators.oscillator')
local Complex = Oscillator:new()

function Complex:new(o)
    o = o or { oscillators = {} }
    setmetatable(o, self)
    self.__index = self
    return o
end

function Complex:addOscillator(oscillator)
    table.insert(self.oscillators, oscillator)
end

function Complex:sample()
    local total = 0

    for _, oscillator in ipairs(self.oscillators) do
        total = total + oscillator:sample()
    end

    return total
end

return Complex
