local dig = {}

---@param side? turtleSide
---@return boolean
---@return string|nil
function dig.forward(side)
  return dig.direction("forward", side)
end

---@param side? turtleSide
---@return boolean
---@return string|nil
function dig.up(side)
  return dig.direction("up", side)
end

---@param side? turtleSide
---@return boolean
---@return string|nil
function dig.down(side)
  return dig.direction("down", side)
end

--- @param direction 'up'|'down'|'forward'
---@param side? turtleSide
---@return boolean
---@return string|nil
function dig.direction(direction, side)
  if direction == "up" then
    return turtle.digUp(side)
  elseif direction == "down" then
    return turtle.digDown(side)
  else
    return turtle.dig(side)
  end
end

function dig.all()
  dig.forward()
  dig.down()
  dig.up()
end

return dig
