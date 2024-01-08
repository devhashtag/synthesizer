local graph = require('graph')
local Synth = require('synth')
local Oscillator = require('oscillators.oscillator')
local Complex = require('oscillators.complex')
local Triangle = require('oscillators.triangle')
local Square = require('oscillators.square')
local Buffer = require('oscillators.buffer')

local synth = Synth:new()
local complex = Complex:new()
local active_notes = { }


function love.load()
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

function love.keypressed(key)
    local osc = Oscillator:new()

    if key == 'a' then
        osc:set_note(-4)
    elseif key == 's' then
        osc:set_note(-3)
    elseif key == 'd' then
        osc:set_note(-2)
    elseif key == 'f' then
        osc:set_note(-1)
    elseif key == 'g' then
        osc:set_note(0)
    elseif key == 'h' then
        osc:set_note(1)
    elseif key == 'j' then
        osc:set_note(2)
    else
        return
    end
    local id = complex:add_oscillator(osc)
    active_notes[key] = id
end

function love.keyreleased(key)
    if active_notes[key] == nil then
        return
    end

    complex:remove_oscillator(active_notes[key])
    active_notes[key] = nil
end
