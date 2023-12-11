local Stack = {}
Stack.__index = Stack

function Stack.new(seed)
  return setmetatable(seed or {}, Stack)
end

--- @param item table
function Stack:push(item)
  table.insert(self, item)
  return self
end

--- @return table
function Stack:pop()
  return table.remove(self)
end

function Stack:peek()
  return self[#self]
end

return Stack
