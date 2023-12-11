local t = {}

function t:run(i)
  if not i.state.gps then
    i.tasks:push({ name = "absolute.locate" })
    return
  end

  if i.state.direction == nil then
    i.tasks:push({ name = "mutative.findDirection" })
    return
  end

  i.tasks:pop(self)
end

return t
