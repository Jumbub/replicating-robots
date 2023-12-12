local _gps = gps

local gps = {}

function gps.available()
  return _gps.locate(10, false) ~= nil
end

function gps.locate()
  local x, y, z = _gps.locate(10, false)
  if x == nil then
    error("todo")
  end
  return vector.new(x, y, z)
end

return gps
