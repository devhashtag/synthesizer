local WIDTH = 800
local HEIGHT = 500


local WindowManager = require('ui.manager')
local KeyboardSynth = require('audio.keyboard_synth')
local Graph = require('ui.graph')


-- List of all tables that will be notified of events
local event_listeners = { Graph, KeyboardSynth, WindowManager }

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


    Graph:load()

    KeyboardSynth:init()
    Graph:set_oscillator(KeyboardSynth.oscillator)

    WindowManager:add(Graph)
end

function love.update(dt)
    KeyboardSynth:update(dt)

    WindowManager:update()
end

function love.draw()
    WindowManager:draw()
end
