require("lib")
local TaskStack = require("tasks.TaskStack")
local Logger = require("logs.Logger")
local FileLogger = require("logs.FileLogger")

local fileLogger = FileLogger.new("logs.txt")
local log = Logger.new(fileLogger):setupGlobalDebug()
local tasks = TaskStack.new("tasks.txt")
tasks.next = require("debug.RateLimit").fn(0.1, tasks.next)
-- tasks = require("debug.Trace").table(tasks, log, { "next" })

if not tasks:peek() then
  tasks:push({ name = "absolute.goto", args = { x = 0, y = 0, z = 0 } })
end

local state = {}
for task in tasks.next do
  task:run({ args = task.args, state = state, tasks = tasks })

  sleep(0.1) -- Avoid loops completely running away
end
log:warning("Ran out of work.")
