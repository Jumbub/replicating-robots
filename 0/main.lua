require("lib")
require("old.report")
local PersistedTable = require("data.PersistedTable")
local PersistedStack = require("data.PersistedStack")
local TaskStack = require("tasks.TaskStack")

fs.makeDir("memory")
local tasks = TaskStack.new(PersistedStack.new("memory/tasks.txt"))

-- Push a default task
if not tasks:peek() then
  tasks:push({ name = "idempotent.goto", args = { x = 0, y = 0, z = 0 } })
end

while true do
  local task = tasks:peek()
  assert(task, "Ran out of work")

  if task.idempotent then
    task.idempotent()
  end

  sleep(0.1) -- Avoid loops completely running away
end
