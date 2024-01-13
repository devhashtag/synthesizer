local Window = require('ui.window')

Component = Window:new()

function Component:new()
    local component = Window.new(self)

    component.inputs = {}
    component.outputs = {}

    return component
end

function Component:create_input(input)
    table.insert(self.inputs, input)
end

function Component:create_output(output)
    local f =  function(...) return output(self, ...) end

    table.insert(self.outputs, f)
end

function Component:input(i)
    i = i or 1

    if i < 0 or i > #self.inputs then
        error('Component input is out of bounds', 1)
    end

    return self.inputs[i]
end

function Component:output(i)
    i = i or 1

    if i < 0 or i > #self.outputs then
        error('Component output is out of bounds')
    end

    return self.outputs[i]
end

return Component
