local Object = require('oop.object')
local LinkedList = Object:new()

LinkedList.list = nil

function LinkedList:prepend(value)
    self.list = {value=value, next=self.list}
end


-- Returns true if an element was removed, false otherwise
function LinkedList:remove(value)
    -- Case for 0 elements
    if self.list == nil then
        return false
    end

    -- Case for 1 element
    if self.list.next == nil then
        if self.list.value == value then
            self.list = nil
        end

        return self.list == nil
    end

    -- Case for 2+ elements
    local prev = self.list
    local element = prev.next

    while element ~= nil do
        if element.value == value then
            prev.next = element.next
            return true
        end

        prev = element
        element = element.next
    end

    return false
end

function LinkedList:head()
    return self.list.value
end

function LinkedList:iter()
    local element = self.list

    return function()
        if element ~= nil then
            local value = element.value
            element = element.next
            return value
        end
    end
end

return LinkedList
