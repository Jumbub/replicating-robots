local PersistedStack = require("src.state.PersistedStack")

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

  local function push(...)
    self:push(...)
  end

  --- @param state TaskState
  return function(state)
    --- @type TaskContext
    local context = { state = state, args = task.args or {}, push = push }
    local runner = require("src.tasks." .. task.name)

    local success, result = xpcall(runner, debug.traceback, context)

    if success then
      self.stack:pop()
    else
      if type(result) == "table" then
        if result.name ~= nil then
          self:push(result)
        elseif result.complete ~= nil then
          self.stack:pop()
        end
      else
        error(result)
      end
    end
  end
end

return TaskStack
