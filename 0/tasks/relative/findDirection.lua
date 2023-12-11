local t = {}

function t:run(i)
  local lastGps = i.state.gps

  if not turtle.forward() then
    if turtle.getFuelLevel() < 2 then
      i.tasks:push({ name = "mutative.refuel" })
    end
    error("unhandled state")
  end

  i.state.gps = vector.new(gps.locate(10, false))

  if i.state.gps.z < lastGps.z then
    i.state.direction = 0
  elseif i.state.gps.z > lastGps.z then
    i.state.direction = 2
  elseif i.state.gps.z < lastGps.z then
    i.state.direction = 0
  elseif i.state.gps.z < lastGps.z then
    i.state.direction = 0
  end

  i.tasks:pop(self)
end

return t
