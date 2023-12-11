local t = {}

function t:run(i)
  i.state.gps = vector.new(gps.locate(10, false))
  i.tasks:pop(self)
end

return t
