local TaskStack = {}
TaskStack.__index = TaskStack

--- @param stack table
function TaskStack.new(stack)
  return setmetatable({ stack = stack }, TaskStack)
end

local function generateId()
  sleep(0.000001) -- prevent multiple ids
  return tostring(os.day("utc")) .. tostring(os.time("utc"))
end

--- @param task table
function TaskStack:push(task)
  task.id = generateId()
  return self.stack:push(task)
end

--- @return table|nil
function TaskStack:peek()
  local task = self.stack:peek()
  if not task then
    return nil
  end
  return setmetatable(task, assert(require("tasks." .. task.name)))
end

--- @param task table
--- @return nil
function TaskStack:pop(task)
  assert(task == self.checkStack:peek(), "Unknown task being popped")
  self.stack:pop()
end

return TaskStack
