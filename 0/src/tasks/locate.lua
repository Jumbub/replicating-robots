local gps = require("src.tasks.actions.gps")

--- @param c TaskContext
return function(c)
  if c.state.location then
    return
  end

  c.state.location = gps.locate()
end
