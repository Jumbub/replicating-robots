--- @param c TaskContext
return function(c)
  if not c.state.gps then
    c.tasks:push({ name = "move.locate" })
    return
  end

  c.tasks:pop(c.task)
end
