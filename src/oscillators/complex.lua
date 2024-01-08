local Oscillator = require('oscillators.oscillator')
local Complex = Oscillator:new()

function Complex:new(o)
    o = o or { counter = 0, oscillators = {} }
    setmetatable(o, self)
    self.__index = self
    return o
end

function Complex:add_oscillator(oscillator)
    self.counter = self.counter + 1
    self.oscillators[self.counter] = oscillator

    for _, osc in pairs(self.oscillators) do
        print(osc.frequency)
    end

    return self.counter
end

function Complex:remove_oscillator(id)
    self.oscillators[id] = nil
end

function Complex:sample_at(t)
    local total = 0
    local n = 0

    for _, oscillator in pairs(self.oscillators) do
        total = total + oscillator:sample_at(t)
        n = n + 1
    end

    return total / n
end

function Complex:sample()
    local total = 0
    local n = 0

    for _, oscillator in pairs(self.oscillators) do
        total = total + oscillator:sample()
        n = n + 1
    end

    return total / n
end

return Complex
