local PersistedTable = require("src.data.PersistedTable")
local Sanity = {}
Sanity.__index = Sanity

local store = PersistedTable.new("sanity.txt")

function Sanity:sane()
  assert(#Object.keys(store) == 0, "Sanity check failed: " .. tostring(store))
end

function Sanity:track(name, task)
  store[name] = true
  task()
  store[name] = nil
end

return Sanity
