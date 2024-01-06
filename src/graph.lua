local Graph = {}

-- State
Graph.xmin = -10
Graph.xmax = 10
Graph.ymin = -10
Graph.ymax = 10
Graph.mode_translate = false

Graph.points = nil

-- Settings
Graph.width = 0
Graph.height = 0
Graph.min_lines = 5
Graph.max_lines = 10
Graph.zoom_factor = 0.15
Graph.nth_line = 4

-- Events
Graph.viewport_changed = { }

local function map(x, a1, b1, a2, b2)
    return a2 + (b2 - a2) * (x - a1) / (b1 - a1)
end

-- Screen coordinates to cartesian coordinates
function Graph:x_s2c(x)
    return map(x, 0, self.width, self.xmin, self.xmax)
end

function Graph:y_s2c(y)
    return map(y, 0, self.height, self.ymax, self.ymin)
end

function Graph:x_c2s(x)
    return map(x, self.xmin, self.xmax, 0, self.width)
end

function Graph:y_c2s(y)
    return map(y, self.ymax, self.ymin, 0, self.height)
end

function Graph:ratio()
    return self.height / self.width
end

function Graph:plot_points(points)
    self.points = points
end

function Graph:load()
    self.width = love.graphics.getWidth()
    self.height = love.graphics.getHeight()
    self.ymin = self.xmin * (self.height / self.width)
    self.ymax = self.xmax * (self.height / self.width)
end

function Graph:draw()
    self.mode_translate = love.keyboard.isDown('lshift')

    self:draw_axes()
    self:draw_lines()
    self:draw_points()
end

-- This will draw the layout of the graph,
-- i.e. what you see when the graph is empty

function Graph:draw_axes()
    love.graphics.setLineStyle('smooth')
    love.graphics.setColor(1, 1, 1)

    love.graphics.line(0, self:y_c2s(0), self.width, self:y_c2s(0))
    love.graphics.line(self:x_c2s(0), 0, self:x_c2s(0), self.height)
end

function Graph:draw_lines()
    love.graphics.setColor(1, 1, 1, 0.5)
    love.graphics.setLineStyle('rough')

    local n = self.nth_line

    local x = self.xmin
    x = math.floor(x / n) * n
    while x < self.xmax do
        love.graphics.setColor(1, 1, 1, 0.5)
        love.graphics.setLineStyle('rough')
        love.graphics.line(self:x_c2s(x), 0, self:x_c2s(x), self.height)

        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.setLineStyle('smooth')
        love.graphics.print(tostring(x), self:x_c2s(x), self:y_c2s(0), 0, 1, 1, -3, -3)
        x = x + n
    end

    local y = self.ymin
    y = math.floor(y / n) * n
    while y < self.ymax do
        love.graphics.setColor(1, 1, 1, 0.5)
        love.graphics.setLineStyle('rough')
        love.graphics.line(0, self:y_c2s(y), self.width, self:y_c2s(y))

        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.setLineStyle('smooth')
        love.graphics.print(tostring(y), self:x_c2s(0), self:y_c2s(y), 0, 1, 1, -3, -3)
        y = y + n
    end

end

-- The points constitute the actual graph

function Graph:draw_points()
    if self.points == nil then
        return
    end

    love.graphics.setLineStyle('smooth')
    love.graphics.setColor(1, 0, 0)

    local arguments = { }

    local i = 1

    for _, point in ipairs(self.points) do
        arguments[i] = self:x_c2s(point.x)
        arguments[i+1] = self:y_c2s(point.y)

        i = i + 2
    end

    love.graphics.points(arguments)

    if false then
        local prev_point = nil
        for _, point in ipairs(self.points) do
            if prev_point == nil then
                goto continue
            end

            love.graphics.line(
                self:x_c2s(prev_point.x),
                self:y_c2s(prev_point.y),
                self:x_c2s(point.x),
                self:y_c2s(point.y))


            ::continue::
            prev_point = point
        end
    end

end


-- Event handling and navigation (translation, universal zoom)
-- TODO: make zoom separate in both x- and y-direction


function Graph:wheelmoved(horizontal, vertical)
    local x_s, y_s = love.mouse.getPosition()
    local rate_x = x_s / self.width
    local rate_y = y_s / self.height
    local diff_x = (self.xmax - self.xmin) * self.zoom_factor
    local diff_y = (self.ymax - self.ymin) * self.zoom_factor

    -- zoom in (scroll up)
    if vertical > 0 then
        self.xmin = self.xmin + rate_x * diff_x
        self.xmax = self.xmax - (1 - rate_x) * diff_x

        self.ymin = self.ymin + (1 - rate_y) * diff_y
        self.ymax = self.ymax - rate_y * diff_y

        if math.floor((self.xmax - self.xmin) / self.nth_line) < self.min_lines then
            self.nth_line = self.nth_line / 2
        end
    -- zoom out (scroll down)
    elseif vertical < 0 then
        self.xmin = self.xmin - rate_x * diff_x
        self.xmax = self.xmax + (1 - rate_x) * diff_x

        self.ymin = self.ymin - (1 - rate_y) * diff_y
        self.ymax = self.ymax + rate_y * diff_y

        if math.floor((self.xmax - self.xmin) / self.nth_line) > self.max_lines then
            self.nth_line = self.nth_line * 2
        end
    end

    self:notify(self.viewport_changed)
end


function Graph:mousemoved(x, y, dx, dy, istouch)
    if self.mode_translate then
        local x_pixels_per_unit = self.width / (self.xmax - self.xmin)
        local y_pixels_per_unit = self.height / (self.ymin - self.ymax)

        self.xmin = self.xmin - dx / x_pixels_per_unit
        self.xmax = self.xmax - dx / x_pixels_per_unit

        self.ymin = self.ymin - dy / y_pixels_per_unit
        self.ymax = self.ymax - dy / y_pixels_per_unit

        self:notify(self.viewport_changed)
    end
end

function Graph:notify(listeners)
    for _, listener in ipairs(listeners) do
        listener(self)
    end
end

return Graph
