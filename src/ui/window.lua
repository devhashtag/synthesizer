local constants = require('constants.ui')
local Object = require('oop.object')

-- A window that can be displayed
local Window = Object:new()

Window.x=0
Window.y=0
Window.width=0
Window.height=0
Window.outer_width=0
Window.outer_height=0

function Window:set_size(outer_width, outer_height)
    self.outer_width = outer_width
    self.outer_height = outer_height
    self.width = outer_width - 2 * constants.BORDER_THICKNESS
    self.height = outer_height - constants.BORDER_THICKNESS - constants.BAR_HEIGHT
end

function Window:set_inner_size(width, height)
    self.outer_width = width + 2 * constants.BORDER_THICKNESS
    self.outer_height = height + constants.BORDER_THICKNESS + constants.BAR_HEIGHT
    self.width = width
    self.height = height
end

function Window:update()

end

function Window:draw()

end

function Window:resize()

end

function Window:in_content(x, y)
    return x > self.x and x < self.x + self.width and y > self.y + constants.BAR_HEIGHT and y < self.y + constants.BAR_HEIGHT + self.height
end

function Window:in_bar(x, y)
    return x >= self.x and x <= self.x + self.width and y >= self.y and y <= self.y + constants.BAR_HEIGHT
end

function Window:in_window(x, y)
    return self:in_content(x, y) or self:in_bar(x, y)
    -- return x > self.x and x < self.x + self.width and y > self.y and y < self.y + self.height
    -- This is more efficient but less fun
end

return Window
