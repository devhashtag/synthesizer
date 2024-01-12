local Component = require('ui.components.component')
local Oscillator = require('oscillators.oscillator')
local Text = require('ui.elements.text')
local OscillatorComponent = Component:new()

OscillatorComponent.text = Text:new()
OscillatorComponent.oscillator = Oscillator:new()

function OscillatorComponent:draw()
    Component:draw()

    self.text.text = tostring(self.oscillator.frequency)
    self.text.x = 10
    self.text.y = 10
    self.text:draw()
end

function OscillatorComponent:resize()
    Component.resize(self)
end

function OscillatorComponent:output()
    return self.oscillator:sample()
end

table.insert(OscillatorComponent.outputs, OscillatorComponent:create_output(OscillatorComponent.output))

return OscillatorComponent
