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

return common
