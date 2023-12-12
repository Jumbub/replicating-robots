local PersistedStack = require("src.data.PersistedStack")

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

  self.next = function()
    return self:peek()
  end

  return setmetatable(self, TaskStack)
end

--- @param task Task
function TaskStack:push(task)
  self.stack:push(task)
end

function TaskStack:peek()
  --- @type Task
  local task = self.stack:peek()
  if not task then
    return nil
  end

  local function complete()
    self:pop(task)
  end

  local function push(...)
    self:push(...)
  end

  --- @param state TaskState
  return function(state)
    --- @type TaskContext
    local context = { state = state, args = task.args or {}, complete = complete, push = push }
    return require("src.tasks." .. task.name)(context)
  end
end

--- @param task Task
function TaskStack:pop(task)
  assert(task == self.stack:peek(), "Unknown task being popped")
  self.stack:pop()
end

return TaskStack
