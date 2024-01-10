local Synth = require('audio.synth')
local Oscillator = require('oscillators.oscillator')
local Complex = require('oscillators.complex')

local KeyboardSynth = Synth:new()

function KeyboardSynth:init()
    getmetatable(self):init()

    self.oscillator = Complex:new()
    self.active_notes = { }
end

function KeyboardSynth:keypressed(key)
    local osc = Oscillator:new()

    if key == 'a' then
        osc:set_note(-5)
    elseif key == 'w' then
        osc:set_note(-4)
    elseif key == 's' then
        osc:set_note(-3)
    elseif key == 'e' then
        osc:set_note(-2)
    elseif key == 'd' then
        osc:set_note(-1)
    elseif key == 'f' then
        osc:set_note(0)
    elseif key == 't' then
        osc:set_note(1)
    elseif key == 'g' then
        osc:set_note(2)
    elseif key == 'y' then
        osc:set_note(3)
    elseif key == 'h' then
        osc:set_note(4)
    elseif key == 'j' then
        osc:set_note(5)
    elseif key == 'i' then
        osc:set_note(6)
    elseif key == 'k' then
        osc:set_note(7)
    elseif key == 'o' then
        osc:set_note(8)
    elseif key == 'l' then
        osc:set_note(9)
    else
        return
    end
    self.active_notes[key] = self.oscillator:add_oscillator(osc)
end

function KeyboardSynth:keyreleased(key)
    if self.active_notes[key] == nil then
        return
    end

    self.oscillator:remove_oscillator(self.active_notes[key])
    self.active_notes[key] = nil
end

return KeyboardSynth
