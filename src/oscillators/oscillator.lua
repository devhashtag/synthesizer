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

function Oscillator:update_phase()
    self.phase = self.phase + (math.pi * 2 * self.frequency / self.samplerate)
end

function Oscillator:sample()
    local phase = self.phase

    self:update_phase()

    return math.sin(phase)
end


return Oscillator
