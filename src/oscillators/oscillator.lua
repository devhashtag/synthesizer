local Oscillator = {
    n_sample = 0,
    frequency = 440,
    samplerate = 44100
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

function Oscillator:sample_at(t)
    return math.sin(2 * math.pi * self.frequency * t)
end

function Oscillator:sample()
    local t = self.n_sample / self.samplerate

    self.n_sample = self.n_sample + 1

    return self:sample_at(t)
end


return Oscillator
