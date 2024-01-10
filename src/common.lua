local common = { }

function common.map(x, a1, b1, a2, b2)
    return a2 + (b2 - a2) * (x - a1) / (b1 - a1)
end

function common.sign(x)
    return x < 0 and -1 or 1
end

function common.tern(condition, trew, fallse)
    return condition and trew or fallse
end

function common.round(x)
    return math.floor(x + 0.5)
end

function common.truncate(x, digits)
    local mult = 10^(digits)

    return math.modf(x*mult)/mult
end

-- TODO test bounds
function common.create_buffer(osc, length)
    local buffer = { }
    for i = 0, length-1 do
        table.insert(buffer, i, osc:sample())
    end

    return buffer
end


-- Multiple inheritance system
local function search(property, metatables)
    for i=1, #metatables do
        local value = metatables[i][property]
        if value then return value end
    end
end

function common.create_class(...)
    local class = {}

    setmetatable(class, {__index=function(_, k)
        return search(k, arg)
    end})

    class.__index = class

    function class:new(o)
        o = o or {}
        setmetatable(o, class)
        return o
    end

    return class
end

return common
