local EventListener = { }

function EventListener:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function EventListener:on_event(event)
    print('unhandled event: ' .. event.name)
end

return EventListener
