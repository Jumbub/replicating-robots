local move = {}

---@return boolean
---@return string|nil
function move.forward()
  return move.direction("forward")
end

---@return boolean
---@return string|nil
function move.back()
  return move.direction("back")
end

--- @return boolean
--- @return string|nil
function move.up()
  return move.direction("up")
end

--- @return boolean
--- @return string|nil
function move.down()
  return move.direction("down")
end

--- @param direction 'up'|'down'|'forward'|'back'
--- @return boolean
--- @return string|nil
function move.direction(direction)
  return turtle[direction]()
end

return move
