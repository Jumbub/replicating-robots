local inventory = require("src.actions.inventory")

local fuel = {}

--- @param limit? number
function fuel.consume(limit)
  return turtle.refuel(limit)
end

return fuel
