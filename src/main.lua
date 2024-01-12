local WIDTH = 800
local HEIGHT = 500

local WindowManager = require('ui.manager')
local KeyboardSynth = require('audio.keyboard_synth')
local Graph = require('ui.graph')
local Oscillator = require('oscillators.oscillator')
local Osc = require('ui.components.oscillator')
local osc = Osc:new()

local left = Graph:new()


-- List of all tables that will be notified of events
local event_listeners = { left, KeyboardSynth, WindowManager }


-- Function that calls every table in event_listeners on every event
setmetatable(love, {__index = function(_, k)
    return function(...)
        local arg = {...}

        for _, tab in ipairs(event_listeners) do
            if type(tab[k]) == 'function' then
                tab[k](tab, unpack(arg))
            end
        end
    end
end})


function love.load()
    love.window.setMode(WIDTH, HEIGHT, {resizable=true})

    WindowManager.width = WIDTH
    WindowManager.height = HEIGHT

    osc:set_size(200, 300)

    left:load()
    left:set_size(love.graphics.getWidth() / 2 - 50, love.graphics.getHeight())

    KeyboardSynth:init()
    left:set_oscillator(KeyboardSynth.oscillator)

    WindowManager:add(left)
    WindowManager:add(osc)
end


function love.update(dt)
    KeyboardSynth:update(dt)
    WindowManager:update(dt)
    print(osc:output())
end

function love.draw()
    WindowManager:draw()
end
