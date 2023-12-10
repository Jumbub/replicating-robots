local TaskStack = {}
TaskStack.__index = TaskStack

--- @param stack table
--- @param checkStack table
function TaskStack.new(stack, checkStack)
  assert(math.abs(stack:length() - checkStack:length()) <= 1, "Invalid task stack state")

  -- This can only happen if we failed during "TaskStack:push", therefore just append to the second
  if stack:length() > checkStack:length() then
    checkStack:push(stack:peek())
  end

  -- This can only happen when bugs exist
  assert(math.abs(stack:length() - checkStack:length()) < 2)

  return setmetatable({ stack = stack, checkStack = checkStack }, TaskStack)
end

--- @param task table
function TaskStack:push(task)
  assert(self:_stackLengthDiff() == 0, "Cannot push to unbalanced task stack")

  self.stack:push(task)
  self.checkStack:push(task) -- Must be second to ensure integrity checker can work

  return self
end

--- @return table
function TaskStack:peek()
  assert(self:_stackLengthDiff() == 0 or self:_stackLengthDiff() == -1, "Invalid task stack state")

  if self.stack:length() == self.checkStack:length() then
    return self:_getTaskMeta(self.stack:peek())
  else
    return self:_getTaskMeta(self.checkStack:peek())
  end
end

--- @param task table
function TaskStack:pop(task)
  assert(self:_stackLengthDiff() == -1, "No in progress tasks")
  assert(task == self.checkStack:peek(), "Unknown task being marked as complete")

  self.checkStack:pop()
end

--- @param task table
function TaskStack:_getTaskMeta(task)
  return setmetatable(task, assert(require("tasks." .. task.name)))
end

function TaskStack:_stackLengthDiff()
  return self.stack:length() - self.checkStack:length()
end

return TaskStack
