require("lib")
local PersistedTable = require("data.PersistedTable")
local PersistedStack = require("data.PersistedStack")
local TaskStack = require("tasks.TaskStack")
local Logger = require("logs.Logger")
local FileLogger = require("logs.FileLogger")
local Trace = require("debug.Trace")
local RateLimit = require("debug.RateLimit")

local fileLogger = FileLogger.new("logs.txt")
local tasks = TaskStack.new("tasks.txt")
local log = Logger.new(fileLogger):setupGlobalDebug()
local temp = { position = vector.new(gps.locate(10, false)) }

-- tasks = Trace.table(tasks, log, { "next" })
tasks.next = RateLimit.fn(0.1, tasks.next)

-- Push a default task
if not tasks:peek() then
  tasks:push({ name = "idempotent.goto", args = { x = 0, y = 0, z = 0 } })
end

for task in tasks.next do
  if task.idempotent then
    log:info("Running idempotent task: " .. task.name)
    -- task.idempotent({ args = task.args, temp = temp })
    tasks:pop(task)
  else
    error("ohno")
  end

  sleep(0.1) -- Avoid loops completely running away
end
log:warning("Ran out of work.")
