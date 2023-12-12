local gps = require("src.tasks.actions.gps")

--- @param c TaskContext
return function(c)
  c.state.location = gps.locate()
end
