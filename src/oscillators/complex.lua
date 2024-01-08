local Oscillator = require('oscillators.oscillator')
local Complex = Oscillator:new()

function Complex:new(o)
    o = o or { oscillators = {} }
    setmetatable(o, self)
    self.__index = self
    return o
end

function Complex:add_oscillator(oscillator)
    table.insert(self.oscillators, oscillator)
end

function Complex:sample_at(t)
    local total = 0

    for _, oscillator in ipairs(self.oscillators) do
        total = total + oscillator:sample_at(t)
    end

    return total
end

function Complex:sample()
    local total = 0

    for _, oscillator in ipairs(self.oscillators) do
        local sample = oscillator:sample()

        total = total + sample
    end

    self.n_sample = self.n_sample + 1

    return total / #self.oscillators
end

return Complex
