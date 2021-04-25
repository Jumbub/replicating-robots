local fuel = require("common.fuel")
local inventory = require("common.inventory")
local chest = require("common.chest")
local move = require("common.move")
local craft = require("common.craft")
local report = require("common.report")

local tree = require("core.tree")

print(tree.chop())

-- print(chest.stashExceptSingle("log", function()
-- 	print("done")
-- 	return true
-- end))
