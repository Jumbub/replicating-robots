require("lib")
require("old.report")
local PersistedQueue = require("util.PersistedQueue")
local PersistedTable = require("util.PersistedTable")

dd("-------------------------------------------")

local a = PersistedTable.new("asdf.json")
a.asdf = "!"
-- a.asdf = a.asdf
dd(a)

-- local z = PersistedQueue.new("asdf.json")
-- z:enqueue("hi")
-- dd(z)

-- x = TablePersisted.new("asdf.json")
-- print(x)
-- x.a = "a"

-- local tasks = queue:new()
-- tasks:enqueue({ label = "up" })

-- while sleep(1) == nil and true do
--   local task = tasks:dequeue()

--   if task == nil then
--     break
--   end

--   local handler = handlers[task.label]
--   assert(handler)
--   if handler.check() then
--     handler.perform()
--     if handler.validate() then
--     end
--   end
-- end
