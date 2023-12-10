local SerializedFile = require("data.SerializedFile")
local PersistedTable = {}
PersistedTable.__index = PersistedTable

--- @param path string
function PersistedTable.new(path, default)
  return setmetatable({
    data = SerializedFile.read(path) or default or {},
    path = path,
  }, PersistedTable)
end

function PersistedTable:__index(key)
  return self.data[key]
end

function PersistedTable:__newindex(key, value)
  self.data[key] = value
  SerializedFile.write(self.path, self.data)
end

function PersistedTable:__len()
  return #self.data
end

function PersistedTable:__pairs()
  return pairs(self.data)
end

function PersistedTable:__ipairs()
  return ipairs(self.data)
end

function PersistedTable:__tostring()
  return textutils.serialise(self.data)
end

return PersistedTable
