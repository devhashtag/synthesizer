local Synth = { }

-- Default settings
Synth.samplerate = 44100
Synth.bitcount = 8
Synth.channelcount = 1
Synth.buffercount = 2
Synth.buffersize = Synth.samplerate/10

-- Constructor
function Synth:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

local qsource = love.audio.newQueueableSource(samplerate, bitcount, channelcount, buffercount)
local buffer = love.sound.newSoundData(buffersize, samplerate, bitcount, channelcount)

local sq_phase = 0
local sq_frequency = 440
local function square()
    sq_phase = sq_phase + sq_frequency / samplerate

    if sq_phase % 2 < 1 then
        return -1
    end

    return 1
end


local tr_phase = 0
local tr_frequency = 440

local function og_triangle()
    tr_phase = tr_phase + tr_frequency / samplerate

    if tr_phase % 2 < 1 then
        return 2 * (tr_phase % 2) - 1
    end

    return 1 - 2 * (tr_phase % 1)
end

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


local sine = Oscillator:new()
sine.frequency = 1


local function create_points(ggraph)
    local xmax = ggraph.xmax
    local points = { }
    local i = 1

    local ssine = Oscillator:new()
    ssine.frequency = 1

    while ssine.phase < xmax do
        local point = { }
        point.y = ssine:sample()
        point.x = ssine.phase
        points[i] = point

        i = i + 1
    end

    ggraph.plot_points(points)
end

function love.update(dt)
    while qsource:getFreeBufferCount() > 0 do
        for i = 0, buffersize - 1 do
            buffer:setSample(i, sine:sample())
        end
        qsource:queue(buffer)
        -- qsource:play()
    end
end
