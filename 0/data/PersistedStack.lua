local Stack = require("data.Stack")
local SerializedFile = require("data.SerializedFile")
local PersistedStack = {}
PersistedStack.__index = PersistedStack

--- @param path string
function PersistedStack.new(path)
  local fileData = SerializedFile.read(path)
  local self = { stack = Stack.new(fileData), path = path }
  return setmetatable(self, PersistedStack)
end

function PersistedStack:push(item)
  self.stack:push(item)
  SerializedFile.write(self.path, self.stack)
  return self
end

function PersistedStack:pop()
  local item = self.stack:pop()
  SerializedFile.write(self.path, self.stack)
  return item
end

function PersistedStack:peek()
  return self.stack:peek()
end

function PersistedStack:__len()
  return #self.stack
end

return PersistedStack
