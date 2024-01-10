local constants = require('constants.ui')
local Window = require('ui.window')
local WindowManager = Window:new()

WindowManager.windows = {}
WindowManager.drag = nil
WindowManager._resize = nil


function WindowManager:add(window)
    table.insert(self.windows, window)
end

function WindowManager:update(dt)
    for _, window in ipairs(self.windows) do
        window:update()
    end
end

function WindowManager:mousepressed(x, y, button, istouch, presses)
    for _, window in ipairs(self.windows) do
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
        self._resize.width = self._resize.width + dx
        self._resize.height = self._resize.height + dy
    end
end

function WindowManager:draw()
    for _, window in ipairs(self.windows) do
        -- Restrict canvas to the designated area for this window
        if not self:in_bounds(window) then
            return
        end

        love.graphics.translate(window.x, window.y + constants.BAR_HEIGHT)
        self:draw_border(window)
        love.graphics.setScissor(window.x + constants.BORDER_THICKNESS, window.y + constants.BAR_HEIGHT, window.width, window.height)
        window:draw()
        love.graphics.setScissor()
        love.graphics.translate(-window.x, -window.y - constants.BAR_HEIGHT)
    end
end

function WindowManager:draw_border(window)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle('line', 0, -constants.BAR_HEIGHT, window.width, window.height + constants.BAR_HEIGHT)
    love.graphics.rectangle('fill', 0, -constants.BAR_HEIGHT, window.width, constants.BAR_HEIGHT)
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


return WindowManager
