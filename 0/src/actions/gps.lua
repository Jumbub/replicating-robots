local _gps = gps

local gps = {}

function gps.locate()
  local x, y, z = _gps.locate(10, false)
  if x == nil then
    return nil
  end
  return vector.new(x, y, z)
end

return gps
