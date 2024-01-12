local Component = require('ui.components.component')
local Audio = Component:new()

-- Default settings
Audio.samplerate = 44100
Audio.bitcount = 16
Audio.channelcount = 1
Audio.buffercount = 2
Audio.buffersize = Audio.samplerate / 30

-- Constructor
function Audio:new()
    local audio = Component:new()

    audio.qsource = love.audio.newQueueableSource(audio.samplerate, audio.bitcount, audio.channelcount, audio.buffercount)
    audio.buffer = love.sound.newSoundData(audio.buffersize, audio.samplerate, audio.bitcount, audio.channelcount)
    audio.input = audio.input()
    audio.n = 0

    return audio
end

function Audio:update(dt)
    while self.qsource:getFreeBufferCount() > 0 do
        local i = 0
        while i < self.buffersize do
            local sample = self.input.sample_at(self.n / self.samplerate)

            self.buffer:setSample(i, sample)

            i = i + 1
            self.n = self.n + 1
        end

        self.qsource:queue(self.buffer)
        self.qsource:play()
    end
end

return Audio
