local Component = require('ui.components.component')
local Text = require('ui.elements.text')
local Audio = Component:new()

-- Default settings
Audio.samplerate = 44100
Audio.bitcount = 16
Audio.channelcount = 1
Audio.buffercount = 2
Audio.buffersize = Audio.samplerate / 30
Audio.text = Text:new()
Audio.text.text = 'Speaker'
Audio.text.x = 10
Audio.text.y = 10

-- Constructor
function Audio:new()
    local audio = Component.new(self)

    audio.qsource = love.audio.newQueueableSource(audio.samplerate, audio.bitcount, audio.channelcount, audio.buffercount)
    audio.buffer = love.sound.newSoundData(audio.buffersize, audio.samplerate, audio.bitcount, audio.channelcount)
    audio.n = 0

    -- Set default size
    audio:set_inner_size(80, 50)

    return audio
end

function Audio:draw()
    self.text:draw()
end

function Audio:update()
    while self.qsource:getFreeBufferCount() > 0 do
        local i = 0
        while i < self.buffersize do
            local sample = self.inputs[1](self.n / self.samplerate)

            self.buffer:setSample(i, sample)

            i = i + 1
            self.n = self.n + 1
        end

        self.qsource:queue(self.buffer)
        self.qsource:play()
    end
end

return Audio
