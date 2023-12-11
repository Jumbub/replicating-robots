--- @class Stack
local Stack = {}
Stack.__index = Stack

function Stack.new(seed)
  return setmetatable(seed or {}, Stack)
end

function Stack:push(item)
  table.insert(self, item)
  return self
end

function Stack:pop()
  return table.remove(self)
end

function Stack:peek()
  return self[#self]
end

return Stack
