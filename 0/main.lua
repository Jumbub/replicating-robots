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
local tasks = TaskStack.new(PersistedStack.new("memory/tasks.txt"))

-- Push a default task
if not tasks:peek() then
  tasks:push({ name = "idempotent.goto", args = { x = 0, y = 0, z = 0 } })
end

dd("ohno")

log:warning("Starting loop...")
while true do
  local task = tasks:peek()
  assert(task, "Ran out of work")

  if task.idempotent then
    log:info("Running idempotent task: " .. task.name)
    task.idempotent()
  else
    error("unimplemenetd")
  end

  sleep(0.1) -- Avoid loops completely running away
end
