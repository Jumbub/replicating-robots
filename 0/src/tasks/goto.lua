local move = require("src.tasks.actions.move")
local rotate = require("src.tasks.actions.rotate")

--- @param c TaskContext
return function(c)
  assert(c.state.orientation, { name = "orient" })
  assert(c.state.location, { name = "locate" })

  local toGoal = c.args.location - c.state.location

  -- resolve z
  rotate.face(c.state, math.sign(toGoal.z) + 1)
  for _ = 1, math.abs(toGoal.z) do
    assert(move.forward(c.state))
  end

  -- resolve x
  rotate.face(c.state, 2 - math.sign(toGoal.x))
  for _ = 1, math.abs(toGoal.x) do
    assert(move.forward(c.state))
  end

  -- resolve y
  local direction = math.sign(toGoal.y) == 1 and "up" or "down"
  for _ = 1, math.abs(toGoal.y) do
    assert(move.vertical(c.state, direction) == true)
  end
end
