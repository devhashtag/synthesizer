Object = {}

function Object:super()
    return getmetatable(self)
end

function Object:new()
    local object = {}
    setmetatable(object, self)
    self.__index = self
    return object
end

return Object
