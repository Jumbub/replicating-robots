--- @param c TaskContext
return function(c)
  c.state.gps = vector.new(gps.locate(10, false))
  c.tasks:pop(c.task)
end
