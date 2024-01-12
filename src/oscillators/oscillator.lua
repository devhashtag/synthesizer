local Object = require('oop.object')
local Oscillator = Object:new()

Oscillator.n_sample = 0
Oscillator.frequency = 440
Oscillator.samplerate = 4410

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
