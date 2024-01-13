local A = { }

A.a = 1

function A:new()
    print(self)
    local object = {}
    setmetatable(object, self)
    self.__index = self
    return object
end

local B = A:new()
B.b = 1
local C = B:new()
function B:new()
    return A.new(self)
end
C.c = 1
function C:new()
    return B.new(self)
end

local c = C:new()
print()
print(A)
print(B)
print(C)
print()

print(getmetatable(c))
print(getmetatable(getmetatable(c)))
print(getmetatable(getmetatable(getmetatable(c))))
