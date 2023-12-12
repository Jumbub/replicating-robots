local gps = require("src.tasks.actions.gps")

--- @param c TaskContext
return function(c)
  assert(gps.available())

  local startLocation = gps.locate()
  assert(turtle.forward())
  local newLocation = gps.locate()

  local diff = newLocation - startLocation
  if diff.z == 1 then
    c.state.orientation = 2
  elseif diff.z == -1 then
    c.state.orientation = 0
  elseif diff.x == 1 then
    c.state.orientation = 1
  elseif diff.x == -1 then
    c.state.orientation = 3
  end
end
