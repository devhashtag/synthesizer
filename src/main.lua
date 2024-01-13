local WIDTH = 800
local HEIGHT = 500

local WindowManager = require('ui.manager')
local KeyboardSynth = require('audio.keyboard_synth')
local Graph = require('ui.graph')
local Osc = require('ui.components.oscillator')
local Audio = require('ui.components.audio')
local Combinator = require('ui.components.combinator')

local osc = Osc:new()
local comb = Combinator:new()
local audio = Audio:new()

-- Object for handling love events
local main = { }

-- List of all tables that will be notified of events
local event_listeners = { main, KeyboardSynth, WindowManager }



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
    WindowManager:add(osc)
    WindowManager:add(audio)
    WindowManager:add(comb)

    audio.x = WIDTH - audio.outer_width
    comb.x = WIDTH - comb.outer_width
    comb.y = HEIGHT - comb.outer_height

    KeyboardSynth:init()
    osc:set_size(200, 300)


    comb:create_input(osc:output())
    audio:create_input(comb:output())
end

function love.update(dt)
    KeyboardSynth:update(dt)
    WindowManager:update(dt)
    audio:update(dt)
end

function love.draw()
    WindowManager:draw()
end

function main:keypressed(key)
    if key == 'q' then
        error()
    end
end
