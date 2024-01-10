local Window = require('ui.window')

local map = require('common').map
local tern = require('common').tern
local truncate = require('common').truncate

local Graph = Window:new()

-- State
Graph.xmin = -10
Graph.xmax = 10
Graph.ymin = -10
Graph.ymax = 10
Graph.mode_translate = false
Graph.points = nil

-- Settings
Graph.min_gap = 50
Graph.max_gap = 200  -- TODO write warning if difference between min_gap and max_gap is too small
Graph.zoom_factor = 0.05
Graph.max_points = 25000 -- How many points can be shown at once
Graph.oscillator = nil

Graph.nth_line = 2
Graph.x_gap = 2
Graph.y_gap = 2

-- Events
Graph.viewport_changed = { }

-- Make it an instance of Window
Window:new(Graph)

-- API
function Graph:set_points(points)
    self.points = points
end

function Graph:set_oscillator(oscillator)
    self.oscillator = oscillator

    local width = (2 / oscillator.frequency)
    local padding = 0.1 * width

    self:set_viewport(0 - padding, width + padding, -1.1, 1.1)
end

-- Screen coordinates to cartesian coordinates
function Graph:x_s2c(x)
    return map(x, 0, self.width, self.xmin, self.xmax)
end

function Graph:y_s2c(y)
    return map(y, 0, self.height, self.ymax, self.ymin)
end

-- Cartesian coordinates to screen coordinates
function Graph:x_c2s(x)
    return map(x, self.xmin, self.xmax, 0, self.width)
end

function Graph:y_c2s(y)
    return map(y, self.ymax, self.ymin, 0, self.height)
end

function Graph:ratio()
    return self.height / self.width
end

-- x_gap and y_gap in pixels
function Graph:x_gaps()
    return self:x_c2s(self.x_gap) - self:x_c2s(0)
end

function Graph:y_gaps()
    return self:y_c2s(self.y_gap) - self:y_c2s(0)
end

function Graph:set_size(width, height)
    Window:set_size(width, height)

    self.ymin = self.xmin * (self.height / self.width)
    self.ymax = self.xmax * (self.height / self.width)
end

function Graph:load()
    self:set_size(love.graphics.getWidth(), love.graphics.getHeight())
    table.insert(self.viewport_changed, self.graph_oscillator)
end

function Graph:draw()
    self.mode_translate = love.keyboard.isDown('lshift')

    self:draw_axes()
    self:draw_lines()
    self:draw_points()
    self:draw_oscillator()
end

-- This will draw the layout of the graph,
-- i.e. what you see when the graph is empty

function Graph:draw_axes()
    love.graphics.setLineStyle('smooth')
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.line(0, self:y_c2s(0), self.width, self:y_c2s(0))
    love.graphics.line(self:x_c2s(0), 0, self:x_c2s(0), self.height)
end

function Graph:draw_lines()
    self:draw_vertical_lines()
    self:draw_horizontal_lines()
end

function Graph:draw_vertical_lines()
    local n = self.x_gap
    local x = math.floor(self.xmin / n) * n

    while x < self.xmax do
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.setLineStyle('rough')
        love.graphics.line(self:x_c2s(x), 0, self:x_c2s(x), self.height)

        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.setLineStyle('smooth')
        love.graphics.print(tostring(x), self:x_c2s(x), self:y_c2s(0), 0, 1, 1, -3, -3)
        x = truncate(x + n, 8)
    end
end

function Graph:draw_horizontal_lines()
    local n = self.y_gap
    local y = math.floor(self.ymin / n) * n

    while y < self.ymax do
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.setLineStyle('rough')
        love.graphics.line(0, self:y_c2s(y), self.width, self:y_c2s(y))

        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.setLineStyle('smooth')
        love.graphics.print(tostring(y), self:x_c2s(0), self:y_c2s(y), 0, 1, 1, -3, -3)
        y = truncate(y + n, 8)
    end
end

-- The points constitute the actual graph

function Graph:draw_points()
    if self.points == nil then
        return
    end

    love.graphics.setLineStyle('smooth')
    --love.graphics.setColor(1, 0, 0, 1)

    local arguments = { }
    local i = 1

    for _, point in ipairs(self.points) do
        arguments[i] = self:x_c2s(point.x)
        arguments[i+1] = self:y_c2s(point.y)

        i = i + 2
    end

    love.graphics.points(arguments)

    -- Draw lines between the points
    -- disabled until its useful
    if false then
        local prev_point = nil
        for _, point in ipairs(self.points) do
            if prev_point ~= nil then
                love.graphics.line(
                    self:x_c2s(prev_point.x),
                    self:y_c2s(prev_point.y),
                    self:x_c2s(point.x),
                    self:y_c2s(point.y))
            end

            prev_point = point
        end
    end
end


-- Event handling and navigation (translation, universal zoom)
-- TODO: make zoom separate in both x- and y-direction

function Graph:x_first_non_zero()
   return tostring(self.x_gap):gsub('0', ''):gsub('%.', ''):sub(1, 1)
end

function Graph:y_first_non_zero()
   return tostring(self.y_gap):gsub('0', ''):gsub('%.', ''):sub(1, 1)
end

function Graph:decrease_lines()
    local pixels_x = self:x_c2s(self.x_gap) - self:x_c2s(0)
    local pixels_y = self:y_c2s(0) - self:y_c2s(self.y_gap)

    if pixels_x < self.min_gap then
        local contains_two = '2' == self:x_first_non_zero()
        local multiplier = tern(contains_two, 2.5, 2)

        self.x_gap = self.x_gap * multiplier
    end

    if pixels_y < self.min_gap then
        local contains_two = '2' == self:y_first_non_zero()
        local multiplier = tern(contains_two, 2.5, 2)

        self.y_gap = self.y_gap * multiplier
    end
end

function Graph:increase_lines()
    local pixels_x = self:x_c2s(self.x_gap) - self:x_c2s(0)
    local pixels_y = self:y_c2s(0) - self:y_c2s(self.y_gap)

    if pixels_x > self.max_gap then
        local contains_five = '5' == self:x_first_non_zero()
        local multiplier = tern(contains_five, 2.5, 2)

        self.x_gap = self.x_gap / multiplier
    end

    if pixels_y > self.max_gap then
        local contains_five = '5' == self:y_first_non_zero()
        local multiplier = tern(contains_five, 2.5, 2)

        self.y_gap = self.y_gap / multiplier
    end
end

function Graph:wheelmoved(horizontal, vertical)
    -- Screen coordinates of mouse pointer
    local x_s, y_s = love.mouse.getPosition()

    -- Normalized zoom target (still in screen coordinates)
    local target_x = x_s / self.width
    local target_y = y_s / self.height

    -- change the viewport by this much units (in cartesian coordinates)
    local diff_x = (self.xmax - self.xmin) * self.zoom_factor
    local diff_y = (self.ymax - self.ymin) * self.zoom_factor


    -- whether to apply zoom
    local zoom_x = true
    local zoom_y = not love.keyboard.isDown('lshift')

    -- zoom in (scroll up)
    if vertical > 0 then
        if zoom_x then
            self.xmin = self.xmin + target_x * diff_x
            self.xmax = self.xmax - (1 - target_x) * diff_x
        end

        if zoom_y then
            self.ymin = self.ymin + (1 - target_y) * diff_y
            self.ymax = self.ymax - target_y * diff_y
        end

        self:increase_lines()
    -- zoom out (scroll down)
    elseif vertical < 0 then
        if zoom_x then
            self.xmin = self.xmin - target_x * diff_x
            self.xmax = self.xmax + (1 - target_x) * diff_x
        end

        if zoom_y then
            self.ymin = self.ymin - (1 - target_y) * diff_y
            self.ymax = self.ymax + target_y * diff_y
        end

        self:decrease_lines()
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

function Graph:set_viewport(xmin, xmax, ymin, ymax)
    self.xmin = xmin
    self.xmax = xmax
    self.ymin = ymin
    self.ymax = ymax

    while self:x_gaps() + self:y_gaps() > 2 * self.max_gap do
        self:increase_lines()
    end
end

-- Use case

function Graph:draw_oscillator()
    if self.oscillator == nil then
        return
    end

    love.graphics.setColor(1, 0, 0 , 1)

    local n = (self.xmax - self.xmin) / (self.max_points)
    local x = self.xmin
    while x < self.xmax do
        local y = self.oscillator:sample_at(x)
        love.graphics.circle('fill', self:x_c2s(x), self:y_c2s(y), 1)
        x = x + n
    end
end

return Graph
