local PersistedTable = require("src.state.PersistedTable")

local Progress = {}
local store = PersistedTable.new("progress.txt")

--- @param name string
function Progress.partial(name)
  return store[name] == true
end

--- @param name string
--- @param task function
function Progress.watch(name, task)
  store[name] = true
  local result = { task() }
  store[name] = nil
  return unpack(result)
end

--- @param name string
function Progress.watcher(name)
  --- @param task function
  return function(task)
    return Progress.watch(name, task)
  end
end

return Progress
