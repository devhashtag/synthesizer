local Synth = { }

-- Default settings
Synth.samplerate = 44100
Synth.bitcount = 16
Synth.channelcount = 1
Synth.buffercount = 2
Synth.buffersize = Synth.samplerate / 30

-- Constructor
function Synth:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Synth:init(oscillator)
    self.qsource = love.audio.newQueueableSource(self.samplerate, self.bitcount, self.channelcount, self.buffercount)
    self.buffer = love.sound.newSoundData(self.buffersize, self.samplerate, self.bitcount, self.channelcount)

    self.oscillator = oscillator
end

local n = 0

function Synth:update(dt)
    while self.qsource:getFreeBufferCount() > 0 do
        local i = 0
        while i < self.buffersize do
            local sample = self.oscillator:sample_at(n / self.samplerate)

            self.buffer:setSample(i, sample)

            i = i + 1
            n = n + 1
        end

        self.qsource:queue(self.buffer)
        self.qsource:play()
    end
end

return Synth
