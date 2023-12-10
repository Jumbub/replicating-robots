local PersistedTable = require("util.PersistedTable")
local Queue = require("util.Queue")

local PersistedQueue = {}

--- @param path string
function PersistedQueue.new(path)
  return Queue.new(PersistedTable.new(path))
end

return PersistedQueue
