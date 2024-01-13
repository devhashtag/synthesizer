local constants = require('constants.ui')
local List = require('data_structures.linked_list')
local Window = require('ui.window')
local WindowManager = Window:new()

WindowManager.windows = List:new()
WindowManager.drag = nil
WindowManager._resize = nil

function WindowManager:add(window)
    self.windows:prepend(window)
end

function WindowManager:update(dt)
    for window in self.windows:iter() do
        window:update()
    end
end

function WindowManager:mousepressed(x, y, button, istouch, presses)
    for window in self.windows:iter() do
        if button == 1 and window:in_bar(x, y) then
            self.drag = window
        end

        if button == 2 and window:in_window(x, y) then
            self._resize = window
        end
    end
end

function WindowManager:mousereleased(x, y, button, istouch, presses)
    if button == 1 then
        self.drag = nil
    elseif button == 2 then
        self._resize = nil
    end
end

function WindowManager:mousemoved(x, y, dx, dy, istouch)
    if self.drag then
        self.drag.x = self.drag.x + dx
        self.drag.y = self.drag.y + dy
    end

    if self._resize then
        self._resize:set_inner_size(
            math.max(constants.MIN_WINDOW_SIZE, self._resize.width + dx),
            math.max(constants.MIN_WINDOW_SIZE, self._resize.height + dy))
    end
end

function WindowManager:draw()
    for window in self.windows:iter() do
        -- Restrict canvas to the designated area for this window
        if not self:in_bounds(window) then
            return
        end

        love.graphics.translate(window.x, window.y)
        self:draw_border(window)
        love.graphics.translate(constants.BORDER_THICKNESS, constants.BAR_HEIGHT)
        love.graphics.setScissor(window.x + constants.BORDER_THICKNESS, window.y + constants.BAR_HEIGHT, window.width, window.height)
        love.graphics.clear()
        window:draw()
        love.graphics.setScissor()
        love.graphics.translate(-window.x - constants.BORDER_THICKNESS, -window.y - constants.BAR_HEIGHT)
    end
end

function WindowManager:draw_border(window)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle('fill', 0, 0, window.outer_width, constants.BAR_HEIGHT)
    love.graphics.rectangle('fill', 0, 0, constants.BORDER_THICKNESS, window.outer_height)
    love.graphics.rectangle('fill', window.outer_width - constants.BORDER_THICKNESS, 0, constants.BORDER_THICKNESS, window.outer_height)
    love.graphics.rectangle('fill', 0, window.outer_height - constants.BORDER_THICKNESS, window.outer_width, constants.BORDER_THICKNESS)
end

function WindowManager:in_bounds(window)
    if window.x > self.width or window.x + window.width < 0 then
        return false
    end

    if window.y > self.height or window.y + window.height < 0 then
        return false
    end

    return true
end

function WindowManager:keypressed(key)
    if key == 'r' then
        for window in self.windows:iter() do
            if not self:in_bounds(window) then
                window.x = 100
                window.y = 100
                break
            end
        end
    end
end

function WindowManager:resize()
    self.width = love.graphics.getWidth()
    self.height = love.graphics.getHeight()
end

return WindowManager
