local WIDTH = 800
local HEIGHT = 500

local WindowManager = require('ui.manager')
local KeyboardSynth = require('audio.keyboard_synth')
local Graph = require('ui.graph')
local Oscillator = require('oscillators.oscillator')

local left = Graph:new()
local right = Graph:new()


-- List of all tables that will be notified of events
local event_listeners = { left, right, KeyboardSynth, WindowManager }


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

    left:load()
    right:load()

    left:set_size(love.graphics.getWidth() / 2 - 50, love.graphics.getHeight())
    right:set_size(love.graphics.getWidth() / 2 - 50, love.graphics.getHeight())
    right.x = love.graphics.getWidth() / 2 + 25

    KeyboardSynth:init()
    left:set_oscillator(KeyboardSynth.oscillator)
    right:set_oscillator(Oscillator:new())

    WindowManager:add(left)
    WindowManager:add(right)
end

function love.update(dt)
    KeyboardSynth:update(dt)
    WindowManager:update(dt)
end

function love.draw()
    WindowManager:draw()
end
