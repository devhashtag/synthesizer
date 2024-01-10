local constants = require('constants.ui')
local Window = require('ui.window')
local WindowManager = Window:new({ windows={} })

function WindowManager:add(window)
    table.insert(self.windows, window)
end

function WindowManager:update()
    for _, window in ipairs(self.windows) do
        window:update()
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
            love.graphics.setScissor(
                window.x + constants.BORDER_THICKNESS,
                window.y + constants.BAR_HEIGHT,
                window.width - 2 * constants.BORDER_THICKNESS,
                constants.BAR_HEIGHT + window.height - constants.BORDER_THICKNESS)
            window:draw()
            love.graphics.setScissor()
        love.graphics.translate(-window.x, -window.y - constants.BAR_HEIGHT)
    end
end

function WindowManager:draw_border(window)
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle('line', 0, -constants.BAR_HEIGHT, window.width, window.height)
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
