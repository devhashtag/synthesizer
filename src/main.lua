local graph = require('graph')
local Synth = require('synth')
local Oscillator = require('oscillators.oscillator')
local Triangle = require('oscillators.triangle')
local Square = require('oscillators.square')
local Complex = require('oscillators.complex')

local synth = Synth:new()

function love.load()
    graph:load()

    -- table.insert(graph.viewport_changed, sample_points())

    synth:init(Oscillator:new())
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

function love.keypressed(key, scancode, isrepeat)
end
