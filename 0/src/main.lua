require("lib")
local Logger = require("src.logs.Logger")
local TaskStack = require("src.loop.TaskStack")
local FileLogger = require("src.logs.FileLogger")

fs.delete("tasks.txt")

local fileLogger = FileLogger.new("logs.txt")
local log = Logger.new(fileLogger):setupGlobalDebug()
local tasks = TaskStack.new("tasks.txt")

tasks.next = require("src.debug.RateLimit").fn(0.1, tasks.next)
tasks = require("src.debug.Trace").table(tasks, log, { "next" })

if not tasks:peek() then
  tasks:push({ name = "goto", args = { location = vector.new(0, 0, 0) } })
end

local state = {}
for task in tasks.next do
  task(state)
  sleep(0.2) -- Avoid loops completely running away
end

log:warning("Ran out of work.")
