local Oscillator = {
    phase = 0,
    frequency = 440,
    samplerate = 44100,
}

function Oscillator:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Oscillator:set_note(note)
    self.frequency = 440.0 * 2^(note/12)
end

function Oscillator:sample()
    self.phase = self.phase + (math.pi * 2 * self.frequency / self.samplerate)

    return math.sin(self.phase)
end

local triangle = Oscillator:new()
function triangle:sample()
    self.phase = self.phase + (math.pi * 2 * self.frequency / self.samplerate)

    return 4 * math.abs(self.phase - math.floor(self.phase+3/4) + 1/4) - 1
end
triangle.frequency = 440

return Oscillator
