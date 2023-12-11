--- @class Task
--- @field id string
--- @field name string
--- @field run function
local z = {}

local Task = {}

--- @param task Task
function Task.isIdempotent(task)
  return String.startsWith(task.name, "absolute.")
end

return Task
