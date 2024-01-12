Text = {}
Text.x = 0
Text.y = 0
Text.text = ''
Text.font = love.graphics.getFont()
Text.width = nil
Text.padding = 5

function Text:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Text:draw()
    local height = self.font:getHeight()
    local width = self.font:getWidth(self.text)

    love.graphics.rectangle('line', self.x, self.y, width + 2 * self.padding, height + 2 * self.padding)
    love.graphics.draw(love.graphics.newText(self.font, self.text),
                       self.x + self.padding,
                       self.y + self.padding)
end

return Text
