local Progress = require("src.state.Progress")
local rotate = {}

--- @param state TaskState
--- @param count number
function rotate.turn(state, count)
  assert(state.orientation, { name = "orient" })

  local turn = count < 0 and turtle.turnLeft or turtle.turnRight
  local direction = math.sign(count)

  for _ = 1, math.abs(count) do
    Progress.watch("rotate", function()
      state.orientation = (state.orientation + direction) % 4
      assert(turn())
    end)
  end
end

--- @param state TaskState
--- @param direction number
function rotate.face(state, direction)
  assert(state.orientation, { name = "orient" })

  local left = (state.orientation - direction) % 4
  local right = (direction - state.orientation) % 4

  if left < right then
    return rotate.turn(state, -left)
  else
    return rotate.turn(state, right)
  end
end

return rotate
