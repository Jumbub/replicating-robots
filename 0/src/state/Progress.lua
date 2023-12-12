local PersistedTable = require("src.state.PersistedTable")

local Progress = {}
local store = PersistedTable.new("progress.txt")

--- @param name string
function Progress.partial(name)
  return store[name] == true
end

--- @param name string
--- @param task function
function Progress.track(name, task)
  store[name] = true
  task()
  store[name] = nil
end

return Progress
