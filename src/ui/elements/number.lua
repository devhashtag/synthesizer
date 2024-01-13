local Object = require('oop.object')
local Text = require('ui.elements.text')

Number = Object:new()
Number.x = 0
Number.y = 0
Number.value = 0
Number.text = Text:new()

function Number:draw()
    self.text.text = tostring(self.value)
    self.text:draw()
end

function Number:keypressed(key)
    if key == 'j' then
        self.value = self.value - 1
    end

    if key == 'k' then
        self.value = self.value + 1
    end
end

return Number
