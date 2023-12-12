local Stack = require("src.state.Stack")
local SerializedFile = require("src.state.SerializedFile")

--- @class PersistedStack : Stack
--- @field stack Stack
--- @field path string
local PersistedStack = {}
PersistedStack.__index = PersistedStack

--- @param path string
function PersistedStack.new(path)
  local stack = Stack.new(SerializedFile.read(path))
  return setmetatable({ stack = stack, path = path }, PersistedStack)
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
