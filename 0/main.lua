-- Check application sanity, unrecoverable errors may have occured
local Sanity = require("debug.Sanity")
Sanity:sane()

require("lib")
require("old.report")
local PersistedTable = require("data.PersistedTable")
local PersistedStack = require("data.PersistedStack")
local TaskStack = require("tasks.TaskStack")

fs.makeDir("memory")
local state = PersistedTable.new("memory/state.txt")
local stack = PersistedStack.new("memory/tasks.txt")
local checkStack = PersistedStack.new("memory/tasks.check.txt")
local taskStack = TaskStack.new(stack, checkStack)

-- There should always exist one item on the todo list.
if not taskStack:peek() then
  taskStack:push({ name = "debug.count", args = { from = 0, to = 100 } })
end

while true do
  local task = taskStack:peek()

  local complete, nextState = task.complete({ confirmedState = Object.freeze(state.current) })

  if complete then
    Sanity:track("popping stack, updating state", function()
      taskStack:pop(task)
      state.current = nextState
    end)
  end

  task.perform({ state })

  sleep(0.1) -- Avoid loops completely running away
end
