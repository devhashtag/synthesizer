local Object = require('oop.object')
local LinkedList = Object:new()

LinkedList.length = 0
LinkedList.list = nil
LinkedList.tail = nil

function LinkedList:prepend(value)
    local new = {value=value, next=self.list, prev = nil}

    self.length = self.length + 1

    if self.list == nil then
        self.list = new
        self.tail = new
        return
    end

    self.list.prev = new
    self.list = new
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
            self.length = 0
        end

        return self.list == nil
    end

    -- Case for 2+ elements
    local prev = self.list
    local element = prev.next

    while element ~= nil do
        if element.value == value then
            prev.next = element.next
            self.length = self.length - 1
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

function LinkedList:reverse_iter()
    local element = self.tail

    return function()
        if element ~= nil then
            local value = element.value
            element = element.prev
            return value
        end
    end
end

return LinkedList
