local Window = require('ui.window')

Component = Window:new()
Component.inputs = {}
Component.outputs = {}

function Component:create_output(output)
    return function()
        return output(self)
    end
end

function Component:input(i)
    i = i or 1

    if i < 0 or i > #self.inputs then
        error('Component input is out of bounds', 1)
    end

    return function() return self.inputs[i] end
end

function Component:output(i)
    i = i or 1

    if i < 0 or i > #self.outputs then
        error('Component output is out of bounds', 1)
    end

    return function() return self.outputs[i] end
end

return Component
