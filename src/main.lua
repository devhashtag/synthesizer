local graph = require('graph')
local Synth = require('synth')
local Oscillator = require('oscillators.oscillator')
local Triangle = require('oscillators.triangle')
local Square = require('oscillators.square')

local sine = Oscillator:new()
local triangle = Triangle:new()
local square = Square:new()

local synth = Synth:new()
synth:init(square)



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
    synth:update(dt)
end

function love.load()
    graph:load()
    --table.insert(graph.viewport_changed, create_points)
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
    if key == 'f' then
        create_points(graph)
    end
end
