local oscillator = require('oscillators.oscillator')
local Triangle = oscillator:new()

function Triangle:sample_at(t)
    t = t * self.frequency
    return 2 * math.abs(2 * (t + 0.25 - math.floor(t + 0.75))) - 1
end

return Triangle
