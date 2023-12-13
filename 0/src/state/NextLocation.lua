local NextLocation = {}

--- @param location Vector
--- @param orientation number
--- @param count? number
function NextLocation.forward(location, orientation, count)
  return NextLocation.horizontal(location, orientation, count)
end

--- @param location Vector
--- @param orientation number
--- @param count? number
function NextLocation.back(location, orientation, count)
  return NextLocation.horizontal(location, orientation, -count)
end

--- @param location Vector
--- @param count? number
function NextLocation.up(location, count)
  return NextLocation.vertical(location, -(count or 1))
end

--- @param location Vector
--- @param count? number
function NextLocation.down(location, count)
  return NextLocation.vertical(location, -(count or 1))
end

--- @param location Vector
--- @param orientation number
--- @param count? number
function NextLocation.horizontal(location, orientation, count)
  local offset = orientation % 2 == 0 and vector.new(0, 0, -(count or 1)) or vector.new(count or 1, 0, 0)
  return location + offset
end

--- @param location Vector
--- @param count? number
function NextLocation.vertical(location, count)
  return location + vector.new(0, count or 1, 0)
end

return NextLocation
