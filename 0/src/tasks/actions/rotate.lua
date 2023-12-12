local Track = require("src.state.Track")
local rotate = {}

rotate.TRACKER = "rotate"

--- @param state TaskState
function rotate.turn(state, count)
  local turn = count < 0 and turtle.turnLeft or turtle.turnRight
  for _ = 1, count do
    Track.task(rotate.TRACKER, function()
      state.orientation = state.orientation + count
      assert(turn())
    end)
  end
end

return rotate
