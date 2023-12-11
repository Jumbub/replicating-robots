require("lib")
local PersistedTable = require("data.PersistedTable")
local PersistedStack = require("data.PersistedStack")
local TaskStack = require("tasks.TaskStack")
local Logger = require("logs.Logger")
local FileLogger = require("logs.FileLogger")

local fileLogger = FileLogger.new("logs.txt")
local log = Logger.new(fileLogger)
log:setupGlobalDebug()

fs.makeDir("memory")
local tasks = TaskStack.new("memory/tasks.txt")
local temp = {
  position = vector.new(gps.locate(10, false)),
}

-- Push a default task
if not tasks:peek() then
  tasks:push({ name = "idempotent.goto", args = { x = 0, y = 0, z = 0 } })
end

log:warning("Starting loop...")
for task in tasks.next do
  dd(task)

  -- if task.idempotent then
  --   log:info("Running idempotent task: " .. task.name)
  --   local output = task.idempotent({ args = task.args, temp = temp })
  --   tasks:pop(task)
  -- else
  --   error("ohno")
  -- end

  tasks:pop(task)

  sleep(0.1) -- Avoid loops completely running away
end
log:warning("Ran out of work.")
