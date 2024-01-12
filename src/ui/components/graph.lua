local Component = require('ui.components.component')
local Graph = require('ui.graph')
local GraphComponent = Component:new()

function GraphComponent:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end
