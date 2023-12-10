-- Inspired by Queue.js (https://github.com/darkwark/queue-lua)

local Queue = {}

--- @param data table Container for storing queue state
function Queue.new(data)
  data = data or {}
  data.array = data.array or {}
  data.offset = data.offset or 1

  dd(data)

  return setmetatable({
    data = data,
  }, {
    __index = Queue,
  })
end

function Queue:enqueue(item)
  -- self.data.array[#self.data.array] = item
  self.data.test3 = 1
  self.data[53] = 1

  return self
end

function Queue:dequeue()
  if self:isEmpty() then
    return nil
  end

  local item = self.data.array[self.data.offset]
  self.data.offset = self.data.offset + 1

  if (self.data.offset * 2) >= #self.data.array then
    self:optimize()
  end

  return item
end

function Queue:length()
  return #self.data.array - self.data.offset
end

function Queue:isEmpty()
  return #self.data.array == 0
end

function Queue:peek()
  if self:isEmpty() then
    return nil
  end

  return self.data.array[self.data.offset]
end

function Queue:optimize()
  local pos, new = 1, {}

  for i = self.data.offset, #self.data.array do
    new[pos] = self.data.array[i]
    pos = pos + 1
  end

  self.data.offset = 1
  self.data.array = new
end

return Queue
