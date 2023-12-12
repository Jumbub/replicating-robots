require("lib")
local Logger = require("src.logs.Logger")
local TaskStack = require("src.loop.TaskStack")
local FileLogger = require("src.logs.FileLogger")

local fileLogger = FileLogger.new("logs.txt")
local log = Logger.new(fileLogger):setupGlobalDebug()
local tasks = TaskStack.new("tasks.txt")

tasks.next = require("src.debug.RateLimit").fn(0.1, tasks.next)
tasks = require("src.debug.Trace").table(tasks, log, { "next" })

if not tasks:peek() then
  tasks:push({ name = "goto", args = { x = 0, y = 0, z = 0 } })
end

local state = {}
for task in tasks.next do
  task(state)
  sleep(1) -- Avoid loops completely running away
end

log:warning("Ran out of work.")
