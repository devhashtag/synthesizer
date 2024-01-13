local Component = require('ui.components.component')
local Oscillator = require('oscillators.oscillator')
local Number = require('ui.elements.number')
local OscillatorComponent = Component:new()

OscillatorComponent.number = Number:new()

function OscillatorComponent:new()
    local oscillator = Component.new(self)

    oscillator:create_output(oscillator.main_output)
    oscillator.oscillator = Oscillator:new()
    oscillator.number = Number:new()
    oscillator.number.value = oscillator.oscillator.frequency

    return oscillator
end

function OscillatorComponent:update()
    self.oscillator.frequency = self.number.value
end

function OscillatorComponent:draw()
    Component:draw()

    self.number.x = 10
    self.number.y = 10
    self.number:draw()
end

function OscillatorComponent:resize()
    Component.resize(self)
end

function OscillatorComponent:main_output(n)
    return self.oscillator:sample_at(n)
end

function OscillatorComponent:keypressed(key)
    self.number:keypressed(key)
end


return OscillatorComponent
