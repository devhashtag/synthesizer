local constants = require('constants.ui')

-- A window that can be displayed
local Window = {
    x=0,
    y=0,
    width=0,
    height=0,
    outer_width=0,
    outer_height=0
}

function Window:new(o)
    o = o or { }
    setmetatable(o, self)
    self.__index = self
    return o
end

function Window:set_size(width, height)
    self.outer_width = width
    self.outer_height = height
    self.width = width - 2 * constants.BORDER_THICKNESS
    self.height = height - constants.BORDER_THICKNESS - constants.BAR_HEIGHT
end

function Window:update()

end

function Window:draw()

end

function Window:resize()

end

return Window
