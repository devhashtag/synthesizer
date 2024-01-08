local graph = require('graph')
local Synth = require('synth')
local Oscillator = require('oscillators.oscillator')
local Complex = require('oscillators.complex')
local Triangle = require('oscillators.triangle')
local Square = require('oscillators.square')
local Buffer = require('oscillators.buffer')

local synth = Synth:new()

local function create_buffer(osc, length)
    local buffer = { }
    local n = 0

    while n <= length do
        table.insert(buffer, n, osc:sample())

        n = n + 1
    end

    return buffer
end

function love.load()
    local complex = Complex:new()

    complex:add_oscillator(Oscillator:new())
    complex:add_oscillator(Oscillator:new({ frequency = 550 }))

    graph:load()
    graph:set_oscillator(complex)

    synth:init(complex)
end

function love.update(dt)
    synth:update(dt)
end

function love.draw()
    graph:draw()
end

function love.wheelmoved(horizontal, vertical)
    graph:wheelmoved(horizontal, vertical)
end

function love.mousemoved(x, y, dx, dy, istouch)
    graph:mousemoved(x, y, dx, dy, istouch)
end
