local SerializedFile = require("util.SerializedFile")

local PersistedTable = { mt = {} }

--- @param path string
--- @return table
function PersistedTable.new(path)
  local data = SerializedFile.read(path)
  local l = {}
  -- for k, v in pairs(data) do
  --   dd(k)
  --   l[k] = v
  -- end
  l.__path = path
  return setmetatable(l, PersistedTable.mt)
end

function PersistedTable.mt.__index(table, key)
  dd("__index", { table = table, key = key })
  return rawget(table, key)
end

function PersistedTable.mt.__newindex(table, key, value)
  dd("__newindex[PRE]", { table = table, key = key, value = value })
  rawset(table, key, value)
  dd(table.__path, Object.omit(table, { "__path" }))
  SerializedFile.write(table.__path, Object.omit(table, { "__path" }))
  dd("__newindex[POST]", { table = table, key = key, value = value })
end

function PersistedTable.mt.__tostring(table)
  return textutils.serializeJSON(table)
end

return PersistedTable
