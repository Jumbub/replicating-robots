local NextLocation = require("src.tasks.actions.util.NextLocation")
local Progress = require("src.state.Progress")
local move = {}

move.TRACKER = "move"

--- @param state TaskState
function move.forward(state)
  -- assert(state.orientation, { name = "orient" })
  -- assert(state.location, { name = "locate" })

  return Progress.track(move.TRACKER, function()
    local success, error = turtle.forward()
    if success then
      -- state.location = NextLocation.forward(state.location, state.orientation)
    end
    return success, error
  end)
end

return move
