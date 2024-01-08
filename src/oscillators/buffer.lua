local Oscillator = require('oscillators.oscillator')
local Buffer = Oscillator:new()

function Buffer:new(o)
    o = o or { buffer = { } }
    setmetatable(o, self)
    self.__index = self
    return o
end

function Buffer:set_buffer(buffer)
    self.buffer = buffer

    print(#self.buffer)
end

function Buffer:sample()
    self.n_sample = self.n_sample + 1

    if self.n_sample > #self.buffer then
        return self.buffer[#self.buffer]
    else
        return self.buffer[self.n_sample]
    end
end

return Buffer
