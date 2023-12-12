local PersistedStack = require("data.PersistedStack")
local Unique = require("data.Unique")
local Task = require("tasks.Task")

--- @class TaskStack
--- @field next function
--- @field stack Stack
local TaskStack = {}
TaskStack.__index = TaskStack

--- @param path string
function TaskStack.new(path)
  local self = {
    stack = PersistedStack.new(path),
  }

  while not Task.isIdempotent(self.stack:peek()) do
    self.stack:pop()
  end

  self.next = function()
    return self:peek()
  end
  return setmetatable(self, TaskStack)
end

--- @param task PlainTask
function TaskStack:push(task, ...)
  self.stack:push(Object.assign(task, { id = Unique.id() }))

  if #{ ... } > 0 then
    self:push(...)
  end
end

--- @return Task|nil
function TaskStack:peek()
  local task = self.stack:peek()
  if not task then
    return nil
  end

  local taskMeta = assert(require("tasks." .. task.name))
  taskMeta.__index = taskMeta

  return setmetatable(task, taskMeta)
end

--- @param task Task
--- @return nil
function TaskStack:pop(task)
  assert(task == self.stack:peek(), "Unknown task being popped")
  self.stack:pop()
end

return TaskStack
