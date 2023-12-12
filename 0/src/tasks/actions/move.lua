local NextLocation = require("src.tasks.actions.util.NextLocation")
local Progress = require("src.state.Progress")
local move = {}

--- @param state TaskState
function move.forward(state)
  return move.direction(state, "forward")
end

--- @param state TaskState
function move.back(state)
  return move.direction(state, "back")
end

--- @param state TaskState
function move.up(state)
  return move.direction(state, "up")
end

--- @param state TaskState
function move.down(state)
  return move.direction(state, "down")
end

--- @param state TaskState
--- @param direction string
function move.direction(state, direction)
  assert(state.orientation, { name = "orient" })
  assert(state.location, { name = "locate" })

  return Progress.watch("move", function()
    local success, error = turtle[direction]()
    if success then
      state.location = NextLocation.forward(state.location, state.orientation)
    end
    return success, error
  end)
end

return move
