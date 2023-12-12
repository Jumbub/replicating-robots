local move = require("src.tasks.actions.move")
--- @param c TaskContext
return function(c)
  error("hi")
  -- assert(c.state.orientation, { name = "orient" })
  -- assert(c.state.location, { name = "locate" })

  -- local diff = c.args.location - c.state.location
  -- move.forward(c)
end
