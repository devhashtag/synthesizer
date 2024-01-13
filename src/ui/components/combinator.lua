local Component = require('ui.components.component')
local Combinator = Component:new()

function Combinator:new()
    local combinator = Component.new(self)

    combinator:set_inner_size(40, 40)
    combinator:create_output(combinator.total_output)

    return combinator
end

function Combinator:draw()
    local padding = 10

    love.graphics.setColor(1, 1, 1)
    love.graphics.line(self.width / 2, padding, self.width / 2, self.height - padding)
    love.graphics.line(padding, self.height / 2, self.width - padding, self.height / 2)
end

function Combinator:total_output(n)
    local total = 0

    for i=1, #self.inputs do
        total = total + self.inputs[i](n)
    end

    return total
end


return Combinator
