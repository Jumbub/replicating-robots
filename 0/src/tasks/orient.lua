local gps = require("src.tasks.actions.gps")
local rotate = require("src.tasks.actions.rotate")

--- @param c TaskContext
local function moveHorizontallyOnce(c)
  for _ = 1, 4 do
    local block = turtle.inspect()
    if not block then
      assert(turtle.forward() == true)
      return
    end
    move
    moveHorizontallyOnce(c)
    return
  end
end

--- @param c TaskContext
local function useGps(c)
  local startLocation = gps.locate()
  moveHorizontallyOnce(c)
  assert(turtle.forward())
  local newLocation = gps.locate()

  local diff = newLocation - startLocation
  if diff.z == 1 then
    return 2
  elseif diff.z == -1 then
    return 0
  elseif diff.x == 1 then
    return 1
  elseif diff.x == -1 then
    return 3
  end
end

--- @param c TaskContext
return function(c)
  if c.state.orientation then
    return
  end

  c.state.orientation = useGps()
  if c.state.orientation then
    return
  end

  c.state.orientation = useGps()
  if c.state.orientation then
    return
  end
end
