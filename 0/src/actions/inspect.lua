local inspect = {}

--- @return boolean
--- @return inspectInfo|string
function inspect.forward()
  return inspect.direction("forward")
end

--- @return boolean
--- @return inspectInfo|string
function inspect.up()
  return inspect.direction("up")
end

--- @return boolean
--- @return inspectInfo|string
function inspect.down()
  return inspect.direction("down")
end

--- @param name string
--- @param present boolean
--- @param info inspectInfo|string
function inspect.is(name, present, info)
  return present and info.name == name
end

--- @param direction 'up'|'down'|'forward'
--- @return boolean
--- @return inspectInfo|string
function inspect.direction(direction)
  if direction == "up" then
    return turtle.inspectUp()
  elseif direction == "down" then
    return turtle.inspectDown()
  else
    return turtle.inspect()
  end
end

return inspect
