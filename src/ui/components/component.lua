local Window = require('ui.window')

Component = Window:new()
Component.outputs = {}
Component.inputs = {}

function Component:new(inputs, outputs)
    local o = {inputs=inputs, outputs=outputs}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Component:create_output(output)
    return function()
        return output(self)
    end
end

function Component:output(i)
    i = i or 1

    if i < 0 or i > #self.outputs then
        error('Component output is out of bounds', 1)
    end

    return function() return self.outputs[i] end
end

return Component
