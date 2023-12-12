--- @param c TaskContext
return function(c)
  if not c.state.gps then
    c.push({ name = "locate" })
    return
  end

  c.complete()
end
