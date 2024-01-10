local EventListener = require('classes.event')
local event_emitter = EventListener:new({ listeners={} })

function event_emitter:add_listener(listener)
    table.insert(self.listeners, listener)
end

function event_emitter:on_event(event)
    for _, listener in ipairs(self.listeners) do
        listener:on_event(event)
    end
end

return event_emitter
